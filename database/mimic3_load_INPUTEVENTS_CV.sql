.print 'Loading mimic3 INPUTEVENTS_CV csv files...'

.mode csv

DROP TABLE IF EXISTS load_temp;

.print 'INPUTEVENTS_CV'
.import ../rawdata/INPUTEVENTS_CV.csv load_temp
INSERT INTO INPUTEVENTS_CV select * from load_temp;
DROP TABLE IF EXISTS load_temp;


.exit
