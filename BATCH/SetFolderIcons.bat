@echo off

REM Set drive's icons related files to hidden
REM Must run as administrator

REM Set to ANSI Western European 1 coding pages
CHCP 1252

cd /D F:\

attrib +S +H +R -A autorun.inf
attrib -S +H -R -A .VolumeIcon.icns
attrib -S +H -R -A .VolumeIcon.ico

REM Set all OSX/Linux files to hidden
attrib /S -S -H -R -A .directory
attrib /S -S +H -R -A .DS_Store
attrib /S -S +H -R -A Icon_#DB7F
attrib /S /D -S +H -R -A .Spotlight-V100
attrib /S /D -S -H -R -A .Trash-1000
attrib /S /D -S +H -R -A .Trashes
attrib /S /D -S -H -R -A .fseventsd

del /F /S /A:H desktop.ini
del /F /S /A:H .directory

REM Creates .directory file
echo [Desktop Entry] > .directory
echo Icon=/media/disk/_Arquivos/Sistema/Configurações/Ícones/VolumeIcon.png >> .directory

REM Assigns attributes
attrib -S -H -R -A .directory

cd /D \_Arquivos

REM Creates desktop.ini file
echo [.ShellClassInfo] > desktop.ini
echo IconResource=\_Arquivos\Sistema\Configurações\Ícones\Arquivos.ico,0 >> desktop.ini
echo InfoTip=Pasta principal com toda a organização de arquivos digitais. >> desktop.ini

REM Creates .directory file
echo [Desktop Entry] > .directory
echo Icon=/media/disk/_Arquivos/Sistema/Configurações/Ícones/Arquivos.png >> .directory
echo Comment=Pasta principal com toda a organização de arquivos digitais. >> .directory

REM Assigns attributes
attrib -S -H +R -A .
attrib +S +H +R -A desktop.ini
attrib -S -H -R -A .directory

cd /D \_Arquivos\_Inbox

REM Creates desktop.ini file
echo [.ShellClassInfo] > desktop.ini
echo IconResource=\_Arquivos\Sistema\Configurações\Ícones\Inbox.ico,0 >> desktop.ini
echo InfoTip=Pasta com arquivos que ainda precisam ser arquivados nas devidas categorias. >> desktop.ini

REM Creates .directory file
echo [Desktop Entry] > .directory
echo Icon=/media/disk/_Arquivos/Sistema/Configurações/Ícones/Inbox.png >> .directory
echo Comment=Pasta com arquivos que ainda precisam ser arquivados nas devidas categorias. >> .directory

REM Assigns attributes
attrib -S -H +R -A .
attrib +S +H +R -A desktop.ini
attrib -S -H -R -A .directory

cd /D \_Arquivos\Pessoal

REM Creates desktop.ini file
echo [.ShellClassInfo] > desktop.ini
echo IconResource=\_Arquivos\Sistema\Configurações\Ícones\Pessoal.ico,0 >> desktop.ini
echo InfoTip=Pasta com arquivos de caráter pessoal como documentos, músicas, vídeos, etc. >> desktop.ini

REM Creates .directory file
echo [Desktop Entry] > .directory
echo Icon=/media/disk/_Arquivos/Sistema/Configurações/Ícones/Pessoal.png >> .directory
echo Comment=Pasta com arquivos de caráter pessoal como documentos, músicas, vídeos, etc. >> .directory

REM Assigns attributes
attrib -S -H +R -A .
attrib +S +H +R -A desktop.ini
attrib -S -H -R -A .directory

cd /D \_Arquivos\Pessoal\_Família

REM Creates desktop.ini file
echo [.ShellClassInfo] > desktop.ini
echo IconResource=\_Arquivos\Sistema\Configurações\Ícones\Família.ico,0 >> desktop.ini
echo InfoTip=Pasta com arquivos referente a família consanguínea e em Cristo. >> desktop.ini

REM Creates .directory file
echo [Desktop Entry] > .directory
echo Icon=/media/disk/_Arquivos/Sistema/Configurações/Ícones/Família.png >> .directory
echo Comment=Pasta com arquivos referente a família consanguínea e em Cristo. >> .directory

REM Assigns attributes
attrib -S -H +R -A .
attrib +S +H +R -A desktop.ini
attrib -S -H -R -A .directory

cd /D F:\_Arquivos\Pessoal\Docs

REM Creates desktop.ini file
echo [.ShellClassInfo] > desktop.ini
echo IconResource=\_Arquivos\Sistema\Configurações\Ícones\Docs.ico,0 >> desktop.ini
echo InfoTip=Pasta com documentos, como certidões, livros, tutoriais, etc. >> desktop.ini

REM Creates .directory file
echo [Desktop Entry] > .directory
echo Icon=/media/disk/_Arquivos/Sistema/Configurações/Ícones/Docs.png >> .directory
echo Comment=Pasta com documentos, como certidões, livros, tutoriais, etc. >> .directory

REM Assigns attributes
attrib -S -H +R -A .
attrib +S +H +R -A desktop.ini
attrib -S -H -R -A .directory

cd /D \_Arquivos\Pessoal\Interesses

REM Creates desktop.ini file
echo [.ShellClassInfo] > desktop.ini
echo IconResource=\_Arquivos\Sistema\Configurações\Ícones\Interesses.ico,0 >> desktop.ini
echo InfoTip=Pasta com arquivos referentes a interesses específicos, como artes, computação, línguas, lutas, etc. >> desktop.ini

REM Creates .directory file
echo [Desktop Entry] > .directory
echo Icon=/media/disk/_Arquivos/Sistema/Configurações/Ícones/Interesses.png >> .directory
echo Comment=Pasta com arquivos referentes a interesses específicos, como artes, computação, línguas, lutas, etc. >> .directory

REM Assigns attributes
attrib -S -H +R -A .
attrib +S +H +R -A desktop.ini
attrib -S -H -R -A .directory

cd /D \_Arquivos\Pessoal\Multimídia

REM Creates desktop.ini file
echo [.ShellClassInfo] > desktop.ini
echo IconResource=\_Arquivos\Sistema\Configurações\Ícones\Multimídia.ico,0 >> desktop.ini
echo InfoTip=Pasta com arquivos multimídia, como áudio, imagem e vídeo. >> desktop.ini

REM Creates .directory file
echo [Desktop Entry] > .directory
echo Icon=/media/disk/_Arquivos/Sistema/Configurações/Ícones/Multimídia.png >> .directory
echo Comment=Pasta com arquivos multimídia, como áudio, imagem e vídeo. >> .directory

REM Assigns attributes
attrib -S -H +R -A .
attrib +S +H +R -A desktop.ini
attrib -S -H -R -A .directory

cd /D \_Arquivos\Profissional

REM Creates desktop.ini file
echo [.ShellClassInfo] > desktop.ini
echo IconResource=\_Arquivos\Sistema\Configurações\Ícones\Profissional.ico,0 >> desktop.ini
echo InfoTip=Pasta com arquivos de caráter profissional como acadêmicos, concursos ou trabalho. >> desktop.ini

REM Creates .directory file
echo [Desktop Entry] > .directory
echo Icon=/media/disk/_Arquivos/Sistema/Configurações/Ícones/Profissional.png >> .directory
echo Comment=Pasta com arquivos de caráter profissional como acadêmicos, concursos ou trabalho. >> .directory

REM Assigns attributes
attrib -S -H +R -A .
attrib +S +H +R -A desktop.ini
attrib -S -H -R -A .directory

cd /D \_Arquivos\Profissional\Acadêmico

REM Creates desktop.ini file
echo [.ShellClassInfo] > desktop.ini
echo IconResource=\_Arquivos\Sistema\Configurações\Ícones\Acadêmico.ico,0 >> desktop.ini
echo InfoTip=Pasta com arquivos acadêmicos, relacionado a faculdade, iniciação científica ou pós graduação. >> desktop.ini

REM Creates .directory file
echo [Desktop Entry] > .directory
echo Icon=/media/disk/_Arquivos/Sistema/Configurações/Ícones/Acadêmico.png >> .directory
echo Comment=Pasta com arquivos acadêmicos, relacionado a faculdade, iniciação científica ou pós graduação. >> .directory

REM Assigns attributes
attrib -S -H +R -A .
attrib +S +H +R -A desktop.ini
attrib -S -H -R -A .directory

cd /D \_Arquivos\Profissional\Concursos

REM Creates desktop.ini file
echo [.ShellClassInfo] > desktop.ini
echo IconResource=\_Arquivos\Sistema\Configurações\Ícones\Concursos.ico,0 >> desktop.ini
echo InfoTip=Pasta com arquivos referentes a concursos e afins. >> desktop.ini

REM Creates .directory file
echo [Desktop Entry] > .directory
echo Icon=/media/disk/_Arquivos/Sistema/Configurações/Ícones/Concursos.png >> .directory
echo Comment=Pasta com arquivos referentes a concursos e afins. >> .directory

REM Assigns attributes
attrib -S -H +R -A .
attrib +S +H +R -A desktop.ini
attrib -S -H -R -A .directory

cd /D \_Arquivos\Profissional\Trabalho

REM Creates desktop.ini file
echo [.ShellClassInfo] > desktop.ini
echo IconResource=\_Arquivos\Sistema\Configurações\Ícones\Trabalho.ico,0 >> desktop.ini
echo InfoTip=Pasta com arquivos de trabalho, referente a magistério, projetos e treinamentos. >> desktop.ini

REM Creates .directory file
echo [Desktop Entry] > .directory
echo Icon=/media/disk/_Arquivos/Sistema/Configurações/Ícones/Trabalho.png >> .directory
echo Comment=Pasta com arquivos de trabalho, referente a magistério, projetos e treinamentos. >> .directory

REM Assigns attributes
attrib -S -H +R -A .
attrib +S +H +R -A desktop.ini
attrib -S -H -R -A .directory

cd /D \_Arquivos\Sistema

REM Creates desktop.ini file
echo [.ShellClassInfo] > desktop.ini
echo IconResource=\_Arquivos\Sistema\Configurações\Ícones\Sistema.ico,0 >> desktop.ini
echo InfoTip=Pasta com arquivos dos sistema, relacionado a programação, configurações ou instalações. >> desktop.ini

REM Creates .directory file
echo [Desktop Entry] > .directory
echo Icon=/media/disk/_Arquivos/Sistema/Configurações/Ícones/Sistema.png >> .directory
echo Comment=Pasta com arquivos dos sistema, relacionado a programação, configurações ou instalações. >> .directory

REM Assigns attributes
attrib -S -H +R -A .
attrib +S +H +R -A desktop.ini
attrib -S -H -R -A .directory

cd /D \_Arquivos\Sistema\Configurações

REM Creates desktop.ini file
echo [.ShellClassInfo] > desktop.ini
echo IconResource=\_Arquivos\Sistema\Configurações\Ícones\Configurações.ico,0 >> desktop.ini
echo InfoTip=Pasta relativa a arquivos de configuração do sistema, como ícones, configurações específicas do Windows, Mac ou Linux. >> desktop.ini

REM Creates .directory file
echo [Desktop Entry] > .directory
echo Icon=/media/disk/_Arquivos/Sistema/Configurações/Ícones/Configurações.png >> .directory
echo Comment=Pasta relativa a arquivos de configuração do sistema, como ícones, configurações específicas do Windows, Mac ou Linux. >> .directory

REM Assigns attributes
attrib -S -H +R -A .
attrib +S +H +R -A desktop.ini
attrib -S -H -R -A .directory

cd /D \_Arquivos\Sistema\Instalações

REM Creates desktop.ini file
echo [.ShellClassInfo] > desktop.ini
echo IconResource=\_Arquivos\Sistema\Configurações\Ícones\Instalações.ico,0 >> desktop.ini
echo InfoTip=Pasta relativa a arquivos de instalação, como instalador de programa, firmware, driver, etc. >> desktop.ini

REM Creates .directory file
echo [Desktop Entry] > .directory
echo Icon=/media/disk/_Arquivos/Sistema/Configurações/Ícones/Instalações.png >> .directory
echo Comment=Pasta relativa a arquivos de instalação, como instalador de programa, firmware, driver, etc. >> .directory

REM Assigns attributes
attrib -S -H +R -A .
attrib +S +H +R -A desktop.ini
attrib -S -H -R -A .directory

cd /D \_Arquivos\Sistema\Programação

REM Creates desktop.ini file
echo [.ShellClassInfo] > desktop.ini
echo IconResource=\_Arquivos\Sistema\Configurações\Ícones\Programação.ico,0 >> desktop.ini
echo InfoTip=Pasta relativa a programação em geral, como scripts, c++, java, etc. >> desktop.ini

REM Creates .directory file
echo [Desktop Entry] > .directory
echo Icon=/media/disk/_Arquivos/Sistema/Configurações/Ícones/Programação.png >> .directory
echo Comment=Pasta relativa a programação em geral, como scripts, c++, java, etc. >> .directory

REM Assigns attributes
attrib -S -H +R -A .
attrib +S +H +R -A desktop.ini
attrib -S -H -R -A .directory

pause

exit
