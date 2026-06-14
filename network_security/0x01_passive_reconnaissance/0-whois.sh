#!/bin/bash
whois $1|awk -F': *' '/^(Registrant|Admin|Tech)/{k=$1;v=$2;if(k~/ Ext$/)k=k":";print (v==""?k", ":k", "v)}' > $1.csv
