.print 'Loading mimic3 NOTEEVENTS csv files...'

.mode csv

DROP TABLE IF EXISTS load_temp;

.print 'NOTEEVENTS'
.import ../rawdata/NOTEEVENTS.csv load_temp
INSERT INTO NOTEEVENTS select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.exit
