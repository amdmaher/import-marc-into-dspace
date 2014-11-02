import-marc-into-dspace
=======================
1- check you mrc file

2- run mk2dc.pl to convert from mrc to dubline core 
./mk2dc.pl 762.mrc > 762.xml
3- run build.pl to build dspace file folders
create import dir 
run this ./build.pl 762.xml
4- now import records to dspace
./dspace import -a -e amaher@kwareict.com -c [CollectionID] -s import -m mapfile


import marc into dspace
