.print 'Loading mimic3 OUTPUTEVENTS csv files...'

.mode csv

DROP TABLE IF EXISTS load_temp;

.print 'OUTPUTEVENTS'
.import ../rawdata/OUTPUTEVENTS.csv load_temp
INSERT INTO OUTPUTEVENTS select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.exit
