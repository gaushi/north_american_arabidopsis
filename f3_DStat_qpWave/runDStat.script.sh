#!/bin/bash

# Loop through the list files
#usage../runDStat.script.sh -l=test.list -o=log -i=parfile
for i in "$@"
do
case $i in
    -l=*|--list=*)
    LIST="${i#*=}"

    ;;
    -o=*|--out=*)
    LOG="${i#*=}"
    ;;

    -i=*|--infile=*)
    INFILE="${i#*=}"
    ;;
esac
done
echo LIST= ${LIST}
echo OUT = ${LOG}
echo INFILE=${INFILE}

echo "genotypename:   ../merged.bi.lmiss90.ed.nativeClustersAmericanGroups.geno
snpname:        ../merged.bi.lmiss90.ed.nativeClustersAmericanGroups.snp
indivname:      ../merged.bi.lmiss90.ed.nativeClustersAmericanGroups.ind
#popfilename:    test.list
#f4mode:        YES
popfilename: ${LIST}
printsd:        YES" > ${INFILE}

qpDstat -p ${INFILE} > ${LOG}

