#!/bin/bash

#usage../runQpWave.script.sh -l=leftList -r=rightList -o=log -i=parfile
for i in "$@"
do
case $i in
    -l=*|--list=*)
    LEFT="${i#*=}"

    ;;
    -r=*|--list=*)
    RIGHT="${i#*=}"

    ;;
    -o=*|--out=*)
    LOG="${i#*=}"
    ;;

    -i=*|--infile=*)
    INFILE="${i#*=}"
    ;;
esac
done
echo LEFT= ${LEFT}
echo RIGHT=${RIGHT}
echo OUT = ${LOG}
echo INFILE=${INFILE}

echo "genotypename:   ../merged.bi.lmiss90.ed.nativeClustersAmericanGroups.geno
snpname:        ../merged.bi.lmiss90.ed.nativeClustersAmericanGroups.snp
indivname:      ../merged.bi.lmiss90.ed.nativeClustersAmericanGroups.ind
#popfilename:    test.list
#details: YES
#f4mode:        YES
popleft: ${LEFT}
popright: ${RIGHT}" > ${INFILE}

qpWave -p ${INFILE} > ${LOG}

