#!/bin/bash
for i in {1..5}; do grep "# left_snp" -A 1000000000 rho_chr${i}.txt > final_rho_chr${i}.txt ; done
for i in {1..5}; do sed -i 's/# //g' final_rho_chr${i}.txt ; done
for i in {1..5};do sed -i 's/ /\t/g' final_rho_chr${i}.txt ; done
