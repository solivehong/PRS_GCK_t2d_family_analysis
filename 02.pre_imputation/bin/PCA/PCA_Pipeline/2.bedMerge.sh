#!/usr/bin/env bash 



function bedmerge()
{
prefix_1=$1
prefix_2=$2
if [ ! -n "$3" ];then
  thread=$3
else
  # shellcheck disable=SC2034
  thread=22
fi
(wecho "
   sh /storage/data/project/tianjin_DM/hxt_family/imputation/bin/PCA/PCA_Pipeline/PCAKIN_1KG/mergeBedPlink.sh
        result/merge/merged
        ${prefix_1}
        ${prefix_2}
        {}
    | bash
" )|bash

rm *temp*
}

bedmerge $1 $2