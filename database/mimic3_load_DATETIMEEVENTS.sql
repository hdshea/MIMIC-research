.print 'Loading mimic3 DATETIMEEVENTS csv files...'

.mode csv

DROP TABLE IF EXISTS load_temp;

.print 'DATETIMEEVENTS'
.import ../rawdata/DATETIMEEVENTS.csv load_temp
INSERT INTO DATETIMEEVENTS select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.exit
