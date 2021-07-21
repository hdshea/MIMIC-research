.print 'Loading mimic3 INPUTEVENTS_MV csv files...'

.mode csv

DROP TABLE IF EXISTS load_temp;

.print 'INPUTEVENTS_MV'
.import ../rawdata/INPUTEVENTS_MV.csv load_temp
INSERT INTO INPUTEVENTS_MV select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.exit
