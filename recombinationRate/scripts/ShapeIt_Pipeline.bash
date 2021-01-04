#!/bin/bash

parallel --jobs 5 bash {} ::: 10X_chr*_extractPIRs.bash &&
parallel --jobs 5 bash {} ::: 10X_chr*_shapeIt.bash &&
bash haps2vcf.sh &&
mail -s 'phased vcf ready' gshirsekar@tuebingen.mpg.de < haps2vcf.sh
