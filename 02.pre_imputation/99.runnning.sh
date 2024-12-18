:<<!
#merge 1kg with hxt FAM vcf 
sh /disk/data_project/tianjin_DM/imputation/bin/PCA/PCA_Pipeline/2.bedMerge.sh 1kg/pgen_b38/results/1kg_HC_sample_all-bed hxt_family2_lift_sort/bed/lifted_over_sort_setID_huangxt
#QC 
plink --bfile result/merge/merged --geno 0.05 --maf 0.001 --hwe 1e-10 --make-bed --out result/QC/QC
### ld prune
 hrun "
 	plink
 	--bfile result/QC/QC
     --maf 0.01 --hwe 1e-10 --geno 0.05
 	--indep-pairwise 1000 50 0.2
 	--out result/LDprune/ld
 	&&
 	plink
 	--bfile result/QC/QC
 	--extract result/LDprune/ld.prune.in
     --make-bed
 	--out result/LDprune/pruned.all
 	"


#/disk/data_project/tianjin_DM/backup/0.data/1.data_61sampleAndhxt/bin/PCA_Pipeline/7.mapPOP.sh
### make pca
sh /disk/tools/syncthing/ucloud/biotools/pipeline/genotype/PCA/PCA_Pipeline/6.pcakin.plink.sh|bash
###  format pop add in pca result 
python /disk/tools/syncthing/ucloud/biotools/tools/bioinfo/MergeFile/mergeFilebyKey.py -m2 /data/publicData/1kg//20130606_g1k_3202_samples_ped_population.txt -m1 pca_test -l 2 -r 2  -H "FamilyID SampleID FatherID MotherID Sex Population Superpopulation" |l|xsv table -d "\t"|wcut -f 7,9- > result/PCA/PCA.POP.pc

cat result/PCA/PCA.POP.pc <(zcat result/PCA/PCA.pc.gz|tail -n 3 ) > result/PCA/PCA.POP_add_family.pc


#### plot for plotly

sh /disk/data_project/tianjin_DM/imputation/bin/PCA/PCA_Pipeline/7.PCAplot.sh

parallel -j 22 -q hrun '
plink --bfile QC -chr {} --recode vcf --out QC_imputation_chr{}

&&
bgzip -f QC_imputation_chr{}.vcf

&&

sh /disk/tools/syncthing/ucloud/biotools/tools/bioinfo/VcfAddChr/VCF_Add_chr.sh QC_imputation_chr{}.vcf.gz QC_imputation_adchr_chr{}.vcf.gz

' ::: $(seq 22)
###############

!

###############

