# EBCDIC Reader

Converts EBCDIC data into csv

Usage:
```
$ cobc -x reader.cob
$ INFILE=./sample-customer-data.ebcdic OUTFILE=test.csv ./reader
...
$ file test.csv 
test.csv: CSV text
```