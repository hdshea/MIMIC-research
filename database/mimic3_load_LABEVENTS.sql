.print 'Loading mimic3 LABEVENTS csv files...'

.mode csv

DROP TABLE IF EXISTS load_temp;

.print 'LABEVENTS'
.import ../rawdata/LABEVENTS.csv load_temp
INSERT INTO LABEVENTS select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.exit
