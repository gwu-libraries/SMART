#!/bin/bash
#
# FILENAME: 5getissn.sh
# FILEPATH: {docroot}/cgi-bin/queries/
# PARAMS  : bibid
# OUTPUT  : the ISSN(s) associated with the given bibid
# PURPOSE : collect ISSN values that will be used to find related records
#
LD_LIBRARY_PATH=/usr/lib/oracle/10.2.0.4/client64/lib
export LD_LIBRARY_PATH
echo 'LD_LIBRARY_PATH:' $LD_LIBRARY_PATH
#
SQLPATH=/usr/lib/oracle/10.2.0.4/client64/bin/
export SQLPATH
echo 'SQLPATH:' $SQLPATH
#
$SQLPATH/sqlplus -S dbread/<PASSWORD>@'(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=<HOST>)(PORT=1521)))(CONNECT_DATA=(SID=VGER)))'<<EOF
set HEADING off
set ECHO off
set PAGESIZE 1000
set WRAP off
set RECSEP off
set TERMOUT off
set FEEDBACK off
set SCAN off
set VERIFY off
column bib_index.normal_heading format A20
set HEADSEP off
spool /tmp/$1BS.out
select bib_index.bib_id,'|',bib_index.normal_heading
from bib_index
where 
bib_index.bib_id='$1' and
bib_index.index_code in ('022A', '022Z', '022L')
/
spool off
EOF
LOG=/var/www/wrlc/log/BIBID-$1.log
echo "TIMER|"`date +%T`"|5getissn" >> $LOG
echo "-----------------------------------------------" >> $LOG
echo "Retrieving  ISSNs in bib_index with index_codes" >> $LOG
echo "022A,022L,022Z" >> $LOG
echo "output from 5getissn.sh (BS)" >> $LOG
cat /tmp/$1BS.out | grep '|' >> $LOG
