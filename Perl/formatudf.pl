#!/usr/bin/perl -w

#   formatudf.pl - partition and format a device using UDF
#   Tested running script on Perl version 5.10.1, 5.12.4 and 5.16.1
#   Tested formatting on Ubuntu 11.10/12.04 and Mac OSX 10.6/10.8
#	Tested opening drive on Windows XP/Vista/7, Ubuntu 11.10/12.04 and Mac OSX 10.6/10.8
#   Copyright (C) 2010   Pieter Wuille
#   Copyright (C) 2012   Eduardo Rodrigues
#   Version - 2.3
#
#   This script uses mkudffs (Linux) and newfs_udf (OSX)
#   as basis for formatting in UDF.
#   The Windows 'format' command was tested, but did not show compatibility:
#       format X: /Q /X /FS:UDF /V:UDF /R:2.01 /A:512
#
#   Best compatibility shown using newfs_udf (10.8).
#
#   UDF repairing tools:
#       - wrudf (Linux): not working, obsolete.
#       - fsck_udf (OSX): good analysis, but no correction.
#       - chkdsk (Win): not so good analysis, but does correct some issues found.
#         Usage: chkdsk X: /F /R
#
#   References:
#   http://sipa.ulyssis.org/2010/02/filesystems-for-portable-disks/
#   http://thestarman.narod.ru/asm/mbr/PartTables.htm
#   http://sites.google.com/site/udfintro/
#   http://code.google.com/p/understand/wiki/UDFInteroperabilityTesting
#   
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#   
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#   
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use Fcntl qw(SEEK_SET SEEK_END);

my $SECTORSIZE = 512;
my $os = "";
my $type = "";

sub encode_lba {
	my ($lba) = @_;
	my $res = pack("V",$lba);
	return $res;
}

sub encode_chs {
	my ($lba,$heads,$sects) = @_;
	my $C = $lba/($heads*$sects);
	$C = 1023 if ($C > 1023);
	my $S = 1+($lba % $sects);
	my $H = ($lba/$sects) % $heads;
	my $res = pack("WWW",$H&255,($S&63)|((($C/256)&3)*64),$C&255);
	return $res;
}

sub encode_entry {
	my ($begin_sect,$size_sect,$bootable,$type,$heads,$sects) = @_;
	return (pack("W",0) x 16) if ($size_sect == 0);
	my $res = "";
	if ($bootable) { $res = pack("W",0x80); } else { $res = pack("W",0); }
	$res .= encode_chs($begin_sect,$heads,$sects);
	$res .= pack("W",$type);
	$res .= encode_chs($begin_sect+$size_sect-1,$heads,$sects);
	$res .= encode_lba($begin_sect);
	$res .= encode_lba($size_sect);
	return $res;
}

sub generate_fmbr {
	use bigint;
	my ($maxlba,$heads,$sects) = @_;
	$maxlba -= ($maxlba % ($heads*$sects));
	my $res;
	my $disksign = int(rand(65536)); # random disk signature
	
	# Use win7 MBR format
	if (($type eq "HD") and ($os eq "7")) {	
		# executable code 1
		$res  = pack("N",0x33C08ED0);
		$res .= pack("N",0xBC007C8E);
		$res .= pack("N",0xC08ED8BE);
		$res .= pack("N",0x007CBF00);
		$res .= pack("N",0x06B90002);
		$res .= pack("N",0xFCF3A450);
		$res .= pack("N",0x681C06CB);
		$res .= pack("N",0xFBB90400);
		$res .= pack("N",0xBDBE0780);
		$res .= pack("N",0x7E00007C);
		$res .= pack("N",0x0B0F850E);
		$res .= pack("N",0x0183C510);
		$res .= pack("N",0xE2F1CD18);
		$res .= pack("N",0x88560055);
		$res .= pack("N",0xC6461105);
		$res .= pack("N",0xC6461000);
		$res .= pack("N",0xB441BBAA);
		$res .= pack("N",0x55CD135D);
		$res .= pack("N",0x720F81FB);
		$res .= pack("N",0x55AA7509);
		$res .= pack("N",0xF7C10100);
		$res .= pack("N",0x7403FE46);
		$res .= pack("N",0x10666080);
		$res .= pack("N",0x7E100074);
		$res .= pack("N",0x26666800);
		$res .= pack("N",0x00000066);
		$res .= pack("N",0xFF760868);
		$res .= pack("N",0x00006800);
		$res .= pack("N",0x7C680100);
		$res .= pack("N",0x681000B4);
		$res .= pack("N",0x428A5600);
		$res .= pack("N",0x8BF4CD13);
		$res .= pack("N",0x9F83C410);
		$res .= pack("N",0x9EEB14B8);
		$res .= pack("N",0x0102BB00);
		$res .= pack("N",0x7C8A5600);
		$res .= pack("N",0x8A76018A);
		$res .= pack("N",0x4E028A6E);
		$res .= pack("N",0x03CD1366);
		$res .= pack("N",0x61731CFE);
		$res .= pack("N",0x4E11750C);
		$res .= pack("N",0x807E0080);
		$res .= pack("N",0x0F848A00);
		$res .= pack("N",0xB280EB84);
		$res .= pack("N",0x5532E48A);
		$res .= pack("N",0x5600CD13);
		$res .= pack("N",0x5DEB9E81);
		$res .= pack("N",0x3EFE7D55);
		$res .= pack("N",0xAA756EFF);
		$res .= pack("n",0x7600);
		
		# executable code 2 (TPM support)
		$res .= pack("n",0xE88D);
		$res .= pack("N",0x007517FA);
		$res .= pack("N",0xB0D1E664);
		$res .= pack("N",0xE88300B0);
		$res .= pack("N",0xDFE660E8);
		$res .= pack("N",0x7C00B0FF);
		$res .= pack("N",0xE664E875);
		$res .= pack("N",0x00FBB800);
		$res .= pack("N",0xBBCD1A66);
		$res .= pack("N",0x23C0753B);
		$res .= pack("N",0x6681FB54);
		$res .= pack("N",0x43504175);
		$res .= pack("N",0x3281F902);
		$res .= pack("N",0x01722C66);
		$res .= pack("N",0x6807BB00);
		$res .= pack("N",0x00666800);
		$res .= pack("N",0x02000066);
		$res .= pack("N",0x68080000);
		$res .= pack("N",0x00665366);
		$res .= pack("N",0x53665566);
		$res .= pack("N",0x68000000);
		$res .= pack("N",0x00666800);
		$res .= pack("N",0x7C000066);
		$res .= pack("N",0x61680000);
		$res .= pack("n",0x07CD);
		$res .= pack("W",0x1A);
		
		# executable code 3 (TPM chip)
		$res .= pack("W",0x5A);
		$res .= pack("N",0x32F6EA00);
		$res .= pack("N",0x7C0000CD);
		$res .= pack("N",0x18A0B707);
		$res .= pack("N",0xEB08A0B6);
		$res .= pack("N",0x07EB03A0);
		$res .= pack("N",0xB50732E4);
		$res .= pack("N",0x0500078B);
		$res .= pack("N",0xF0AC3C00);
		$res .= pack("N",0x7409BB07);
		$res .= pack("N",0x00B40ECD);
		$res .= pack("N",0x10EBF2F4);
		$res .= pack("n",0xEBFD);
		
		# executable code 4
		$res .= pack("n",0x2BC9);
		$res .= pack("N",0xE464EB00);
		$res .= pack("N",0x2402E0F8);
		$res .= pack("n",0x2402);
		$res .= pack("W",0xC3);
		
		# error message 1
		$res .= pack("W",0x49);
		$res .= pack("N",0x6E76616C);
		$res .= pack("N",0x69642070);
		$res .= pack("N",0x61727469);
		$res .= pack("N",0x74696F6E);
		$res .= pack("N",0x20746162);
		$res .= pack("n",0x6C65);
		$res .= pack("W",0x00);
		
		# error message 2
		$res .= pack("W",0x45);
		$res .= pack("N",0x72726F72);
		$res .= pack("N",0x206C6F61);
		$res .= pack("N",0x64696E67);
		$res .= pack("N",0x206F7065);
		$res .= pack("N",0x72617469);
		$res .= pack("N",0x6E672073);
		$res .= pack("N",0x79737465);
		$res .= pack("n",0x6D00);
		
		# error message 3
		$res .= pack("n",0x4D69);
		$res .= pack("N",0x7373696E);
		$res .= pack("N",0x67206F70);
		$res .= pack("N",0x65726174);
		$res .= pack("N",0x696E6720);
		$res .= pack("N",0x73797374);
		$res .= pack("n",0x656D);
		$res .= pack("W",0x00);

		$res .= pack("W",0);          # padding
		$res .= pack("N",0x00637B9A); # windows 7 install
		$res .= pack("N",$disksign);  # disk signature
		$res .= pack("W",0) x 2;      # padding
	} else {
		$res  = pack("W",0) x 435;    # code section
		$res .= pack("W",0);          # padding
		$res .= pack("N",0);          # windows 7 install
		$res .= pack("N",$disksign);  # disk signature
		$res .= pack("W",0) x 2;      # padding
	}
	$res .= encode_entry(0,$maxlba,0,0x0B,$heads,$sects); # primary partition spanning whole disk
	$res .= pack("W",0) x 48;;        # 3 unused partition entries
	$res .= pack("n",0x55AA);         # signature ID
	return ($res,$maxlba);
}

$|=1;

if (! -e $ARGV[0]) {
	print "\n";
	print "Perl script for partition and format a device using UDF\n";
	print "Working on Perl version 5.16.1\n";
	print "\n";
	print "Syntax: $0 /dev/diskdevice [HD|FLASH] [label] [size_in_bytes] [VISTA|7]\n";
	print "Example: sudo perl $0 /dev/sdb HD UDF 1000000 7\n";
	print "\n";
}

my $udfpath="";
my $udftype;
if (-x "/usr/bin/mkudffs") { $udfpath="/usr/bin/mkudffs"; $udftype="mkudffs" }
if (-x "/sbin/newfs_udf") { $udfpath="/sbin/newfs_udf"; $udftype="newfs_udf" }

my $mounttype;
if (-x "/bin/mount") { $mounttype="mount" }
if (-x "/usr/sbin/diskutil") { $mounttype="diskutil" }

if (! defined($udftype)) {
	print STDERR "Neither mkudffs or newfs_udf could be found. Exiting.\n";
} elsif (! defined($mounttype)) {
	print STDERR "Neither mount or disktutil could be found. Exiting.\n";
} else {
	
	my $dev=shift @ARGV;
	
	if (defined $ARGV[0]) {
		$type=shift @ARGV;
	}
	
	my $label="UDF";
	if (defined $ARGV[0]) {
		$label=shift @ARGV;
	}
	
	# Unmount device
	if ($mounttype eq "mount") {
		system("u$mounttype -f $dev");
	} elsif ($mounttype eq "diskutil") {
		system("$mounttype unmountDisk force $dev");
	}
	
	open DISK,"+<",$dev || die "Cannot open '$dev' read/write: $!";
	
	my $size=(-s $dev);
	if (defined $ARGV[0]) {
		$size=shift @ARGV;
	}
	if ($size<=0) {
		$size=sysseek DISK, 0, 2;
		sysseek DISK, 0, 0;
	}
	if ($size<=0) {
		seek(DISK,0,SEEK_END) || die "Cannot seek to end of device: $!";
		my $size=tell(DISK);
	}
	seek(DISK,0,SEEK_SET) || die "Cannot seek to begin of device: $!";
	
	$size = (-s $dev) if ($size<=0);
	if ($size<=0) {
		die "Cannot calculate device size, please use: $0 device label [size_in_bytes]";
	}
	system("sync");
	
	if (defined $ARGV[0]) {
		$os=shift @ARGV;
	}
	
	my $maxlba = $size/$SECTORSIZE;
	my $mbr = 0;
	if ($type eq "HD") {
	    ($mbr,$maxlba) = generate_fmbr($maxlba,255,63);
		print "Cleaning first 4100 sectors...";
		for (my $i=0; $i<4100; $i++) {
		  print DISK (pack("W",0)x$SECTORSIZE) || die "Cannot clear sector $i: $!";
		}
		print "done\n";
	}
	
	close DISK || die "Cannot close disk device: $!";
	system("sync");
	
	print "Creating $maxlba-sector UDF v2.01 filesystem with label '$label' on $type $dev using $udftype...\n";
	if ($udftype eq "mkudffs") {
		system($udfpath,"--blocksize=$SECTORSIZE","--udfrev=0x0201","--lvid=$label","--vid=$label","--media-type=hd","--utf8",$dev,$maxlba);
	} elsif ($udftype eq "newfs_udf") {
		system($udfpath,"-b",$SECTORSIZE,"-m","blk","-t","ow","-s",$maxlba,"-r","2.01","-v",$label,"--enc","utf8",$dev);
	}
	system("sync");
	
	if ($type eq "HD") {
		open DISK,"+<",$dev || die "Cannot open '$dev' read/write: $!";
		
		print "Writing MBR...";
		print DISK $mbr || die "Cannot write MBR: $!";
		print "done\n";
		
		close DISK || die "Cannot close disk device: $!";
	}
	system("sync");
}
