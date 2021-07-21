.print 'Loading mimic3 CHARTEVENTS csv files...'

.mode csv

DROP TABLE IF EXISTS load_temp;

.print 'CHARTEVENTS'
.import ../rawdata/CHARTEVENTS.csv load_temp
INSERT INTO CHARTEVENTS select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.exit
