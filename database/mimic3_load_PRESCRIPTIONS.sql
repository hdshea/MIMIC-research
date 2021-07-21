.print 'Loading mimic3 PRESCRIPTIONS csv files...'

.mode csv

DROP TABLE IF EXISTS load_temp;

.print 'PRESCRIPTIONS'
.import ../rawdata/PRESCRIPTIONS.csv load_temp
INSERT INTO PRESCRIPTIONS select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.exit
