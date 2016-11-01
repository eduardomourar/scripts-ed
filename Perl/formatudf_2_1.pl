#!/usr/bin/perl -w

#   formatudf.pl - partition and format a device using UDF
#   Working on Perl version 5.10.1 and 5.16.1
#   Tested on Ubuntu 11.10 and Mac OSX 10.6
#   Copyright (C) 2010   Pieter Wuille
#   Copyright (C) 2012   Eduardo Rodrigues
#   Version - 2.1
#
#   This script uses mkudffs (Linux) and newfs_udf (OSX)
#   as basis for formatting UDF.
#   The Windows 'format' was tested, but did not show compatibility:
#       format X: /FS:UDF /V:UDF /R:2.01 /A:512
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

my $SECTORSIZE=512;

sub encode_lba {
	my ($lba) = @_;
	my $res=pack("V",$lba);
	return $res;
}

sub encode_chs {
	my ($lba,$heads,$sects) = @_;
	my $C= $lba/($heads*$sects);
	$C=1023 if ($C>1023);
	my $S=1+($lba % $sects);
	my $H=($lba/$sects) % $heads;
	my $res=pack("WWW",$H & 255,($S&63)|((($C/256)&3)*64),$C&255);
	return $res;
}

sub encode_entry {
	my ($begin_sect,$size_sect,$bootable,$type,$heads,$sects) = @_;
	return (pack("W",0) x 16) if ($size_sect == 0);
	my $res="";
	if ($bootable) { $res=pack("W",0x80); } else { $res=pack("W",0); }
	$res .= encode_chs($begin_sect,$heads,$sects);
	$res .= pack("W",$type);
	$res .= encode_chs($begin_sect+$size_sect-1,$heads,$sects);
	$res .= encode_lba($begin_sect);
	$res .= encode_lba($size_sect);
	return $res;
}

sub generate_fmbr {
	use integer;
	my ($maxlba,$heads,$sects)=@_;
	$maxlba -= ($maxlba % ($heads*$sects));
	my $res=pack("W",0) x 440; # code section
	$res .= pack("V",0);       # disk signature
	$res .= pack("W",0) x 2;   # padding
	$res .= encode_entry(0,$maxlba,0,0x0B,$heads,$sects); # primary partition spanning whole disk
	$res .= pack("W",0) x 48;  # 3 unused partition entries
	$res .= pack("W",0x55);    # signature part 1
	$res .= pack("W",0xAA);    # signature part 2
	return ($res,$maxlba);
}

$|=1;

if (! -e $ARGV[0]) {
	print "\n";
	print "Perl script for partition and format a device using UDF\n";
	print "Working on Perl version 5.16.1\n";
	print "\n";
	print "Syntax: $0 /dev/diskdevice [HD|FLASH] [label] [size_in_bytes]\n";
	print "Example: sudo perl $0 /dev/sdb HD UDF\n";
	print "\n";
}

my $udfpath="";
my $udftype;
if (-x "/usr/bin/mkudffs") { $udfpath="/usr/bin/mkudffs"; $udftype="mkudffs" }
if (-x "/sbin/newfs_udf") { $udfpath="/sbin/newfs_udf"; $udftype="newfs_udf" }

my $mounttype;
if (-x "/usr/bin/mount") { $mounttype="mount" }
if (-x "/usr/sbin/diskutil") { $mounttype="diskutil" }

if (! defined($udftype)) {
	print STDERR "Neither mkudffs or newfs_udf could be found. Exiting.\n";
} elsif (! defined($mounttype)) {
	print STDERR "Neither mount or disktutil could be found. Exiting.\n";
} else {
	
	my $dev=shift @ARGV;
	
	my $type="";
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

	print "Cleaning first 4098 sectors...";
	for (my $i=0; $i<4097; $i++) {
		print DISK (pack("W",0)x$SECTORSIZE) || die "Cannot clear sector $i: $!";
	}
	print "done\n";
	system("sync");
	
	close DISK || die "Cannot close disk device: $!";

	my ($mbr,$maxlba) = 0;
	if ($type eq "HD") {
		($mbr,$maxlba) = generate_fmbr($size/$SECTORSIZE,255,63);
	} else {
		$maxlba=$size/$SECTORSIZE;
	}
	system("sync");
	
	print "Creating $maxlba-sector UDF v2.01 filesystem with label '$label' on $type $dev using $udftype...\n";
	if ($udftype eq "mkudffs") {
		system($udfpath,"--blocksize=$SECTORSIZE","--udfrev=0x0201","--lvid=$label","--vid=$label","--media-type=hd","--utf8",$dev,$maxlba);
	} elsif ($udftype eq "newfs_udf") {
		system($udfpath,"-b",$SECTORSIZE,"-m","blk","-t","ow","-s",$maxlba,"-r","2.01","-v",$label,"--enc","utf8",$dev);
	}
	
	if ($type eq "HD") {
		open DISK,"+<",$dev || die "Cannot open '$dev' read/write: $!";
		
		print "Writing MBR...";
		print DISK $mbr || die "Cannot write MBR: $!";
		print "done\n";
		
		close DISK || die "Cannot close disk device: $!";
	}
	system("sync");
}
