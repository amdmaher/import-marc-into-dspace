import-marc-into-dspace
=======================
1- check the marc file

2- run mk2dc.pl to convert from mrc to dubline core 

./mk2dc.pl 762.mrc > 762.xml

3- create import dir

mkdir import

4- run build.pl to build dspace file folders


run this ./build.pl 762.xml

5- now import records to dspace

./dspace import -a -e email@mail.com -c [CollectionID] -s import -m mapfile


import marc into dspace
