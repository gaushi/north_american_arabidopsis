#!/bin/bash
for i in {1..5}
do
ldhelmet post_to_text -m -p 0.025 -p 0.50 -p 0.975 -o rho_chr${i}.txt output_chr${i}.post
done
