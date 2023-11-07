#!/usr/bin/bash

# 10-25-2023
# This script goes through the results and summarizes the cross validation results
# for models using all peaks or 95% selected peaks
#
# How to run:
# ./summarize_cv_results.sh -d <results_dir>

while getopts "d:" option
do
        case $option in
                d) results_dir=$OPTARG;;
        esac
done

result_files="$(ls "$results_dir"/*/*_results.txt)"

echo -e "Gene\tMethod\tnPeaks\tPeakCat\tCV_R2" > cv_summary.txt

for file in $result_files
do
        gene="$(echo "$file" | rev | cut -d"/" -f1 | rev | cut -d"_" -f1)"
        #echo $gene
        method="$(echo "$file" | rev | cut -d"/" -f1 | rev | cut -d"_" -f2,3,4)"
        #echo $method
        # get info for all peaks
        npeaks_all="$(awk -F"," '{if (NR == 2) {print $1}}' "$file")"
        r2_all="$(awk -F"," '{if (NR == 2) {print $2}}' "$file")"
        # get info for select peaks
        npeaks_select="$(awk -F"," '{if (NR == 3) {print $1}}' "$file")"
        r2_select="$(awk -F"," '{if (NR == 3) {print $2}}' "$file")"
        # save to summary
        echo -e $gene"\t"$method"\t"$npeaks_all"\tAll_Peaks\t"$r2_all >> cv_summary.txt
        echo -e $gene"\t"$method"\t"$npeaks_select"\tSelect_Peaks\t"$r2_select >> cv_summary.txt
done
