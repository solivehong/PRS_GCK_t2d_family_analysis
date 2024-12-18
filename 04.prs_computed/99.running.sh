:<<!
parallel -j 22 -q hrun '

plink2 --pfile 
--maf 0.005

' ::: $(seq 22)


parallel -j 22 -q hrun '

plink2 --vcf all_vcf/chr{}.dose.vcf.gz
--extract-if-info R2">"=0.8
--make-pgen --out pgen/chr{}

' ::: $(seq 22)

parallel -j 10 -q hrun '
### --score beta_file SNPid effect_allele effect_value header
plink2
--pfile pgen/chr{}
#chr{}_imputation
--score <(cat summary_GWAS/PGS002308_GRS_T2D_Ge_T_CATALOG_SCORING_FILE/SNPid_beta.txt|grep -E "hm_chr|chr{}:") 6 3 5  header-read list-variants-zs cols='sid,nallele,dosagesum,scoresums'
--out prs_TW/chr{}
' :::: chr.sh

python /storage/syncthing/ucloud/biotools/pipeline/genotype/PRS/prs_TW/prsResultAdd.py


################## JP  test 
parallel -j 10 -q hrun '
### --score beta_file SNPid effect_allele effect_value header
plink2
--pfile pgen/chr{}
#chr{}_imputation
--score <(cat summary_GWAS/japen_T2D/v7new_version_file_uniq|grep -E "^{}|CHR" |sh awk.sh) 2 4 7  header-read list-variants-zs cols='sid,nallele,dosagesum,scoresums'
--out JP_T2D/chr{}
' :::: chr.sh
python /storage/syncthing/ucloud/biotools/pipeline/genotype/PRS/prs_TW/prsResultAdd.py

hrun '
                plink
                        --bfile  bed/chr22 
                        --clump-p1 1
                        --clump-r2 0.3
                        #--clump-kb 250 
                        --clump <(cat summary_GWAS/japen_T2D/v7new_version_file_uniq|grep -E "^22|CHR" |sh awk.sh)
                        --clump-snp-field chrSNP 
                        --clump-field P 
                        --out JP_T2D/PT22
' |bash


#### prs Huerta compute  T2D_LAT_EAS

parallel -j 10 -q hrun '
### --score beta_file SNPid effect_allele effect_value header
plink2
--pfile pgen/chr{}
#chr{}_imputation
--score <(cat summary_GWAS/PGS003444_PRScsx_T2D_LAT_EASweights_Huerta-Chagoya/SNPid_beta.txt|grep -E "chr_name|chr{}:") 6 3 5  header-read list-variants-zs cols='sid,nallele,dosagesum,scoresums'
--out prs_Huerta/chr{}
' :::: chr.sh

#### prs Zhang_H_logTG
parallel -j 10 -q hrun '
### --score beta_file SNPid effect_allele effect_value header
plink2
--pfile pgen/chr{}
#chr{}_imputation
--score <(cat summary_GWAS/PGS003809_Zhang_H_logTG_EAS_LDpred2/SNPid_beta.txt|grep -E "chr_name|chr{}:") 6 3 5  header-read list-variants-zs cols='sid,nallele,dosagesum,scoresums'
--out prs_Zhang_H/chr{}
' :::: chr.sh

### TG 
parallel -j 10 -q hrun '
### --score beta_file SNPid effect_allele effect_value header
plink2
--pfile pgen/chr{}
#chr{}_imputation
--score <(cat summary_GWAS/PGS003809_Zhang_H_logTG_EAS_LDpred2/SNPid_beta.txt|grep -E "chr_name|chr{}:") 6 3 5  header-read list-variants-zs cols='sid,nallele,dosagesum,scoresums'
--out prs_Zhang_H/chr{}
' :::: chr.sh

##################################################################重新分析

################ sort id
parallel -j 22 -q hrun '

zcat all_vcf/chr{}.dose.vcf.gz
|VCFSetID.py -s |bgzip > sort_vcf/chr{}.dose.vcf.gz

' ::: $(seq 22)


parallel -j 22 -q hrun '

plink2 --vcf sort_vcf/chr{}.dose.vcf.gz
--extract-if-info R2">"=0.8
--make-pgen --out pgen_sortid/chr{}

' ::: $(seq 22)
##### 
parallel -j 10 -q hrun '
### --score beta_file SNPid effect_allele effect_value header
plink2
--pfile pgen_sortid/chr{}
#chr{}_imputation
--score <(cat summary_GWAS/PGS002308_GRS_T2D_Ge_T_CATALOG_SCORING_FILE/SNPid_beta.txt|grep -E "hm_chr|chr{}:") 6 3 5  header-read list-variants-zs cols='sid,nallele,dosagesum,scoresums'
--out prs_TW_T2D_GEt/chr{}
' :::: chr.sh

parallel -j 10 -q hrun '
### --score beta_file SNPid effect_allele effect_value header
plink2
--pfile pgen_sortid/chr{}
#chr{}_imputation
--score <(cat summary_GWAS/PGS002277_pPS_Insulin_secretion_1based_on_SNPs_associated_with_insulin_secretion/SNPid_beta.txt|grep -E "chr_name|chr{}:") 6 4 3  header-read list-variants-zs cols='sid,nallele,dosagesum,scoresums'
--out prs_insulin_PRS_T2D/chr{}
' :::: chr.sh
# 加和 prsscore

python /storage/syncthing/ucloud/biotools/pipeline/genotype/PRS/prsResultAdd.py
# sed 替换name
less sumPrsscors |sed -e "s#206863650127_R07C02#hxt_F#g" -e "s#206863650127_R06C02#hxt_M#g" -e "s#206863650127_R05C02#hxt#g" -e "s#0_##g" > sumPrsscors_sed_name
sed -i "s/#//g" sumPrsscors_sed_name
# R  regress 
Rscript /storage/syncthing/ucloud/biotools/pipeline/genotype/PRS/regress.r -pca  ../../imputation/result/PCA/pca_prs.pc -s sumPrsscors_sed_name
#plot result
python /storage/syncthing/ucloud/biotools/pipeline/genotype/PRS/prsResidPlot.py residual.txt hxt --index_names hxt hxt_F hxt_M


parallel -j 10 -q hrun '
### --score beta_file SNPid effect_allele effect_value header
plink2
--pfile pgen_sortid/chr{}
#chr{}_imputation
--score <(cat summary_GWAS/PGS003809_Zhang_H_logTG_EAS_LDpred2/SNPid_beta.txt|grep -E "chr_name|chr{}:") 6 3 5  header-read list-variants-zs cols='sid,nallele,dosagesum,scoresums'
--out prs_TG_Zhang_H_sort/chr{}
' :::: chr.sh

################## Insulin_resistance 胰岛素抵抗
parallel -j 10 -q hrun '
### --score beta_file SNPid effect_allele effect_value header
plink2
--pfile pgen_sortid/chr{}
#chr{}_imputation
--score <(cat summary_GWAS/PGS000877_Insulin_resistance_Lotta/SNPid_beta.txt|grep -E "chr_name|chr{}:") 6 4 3  header-read list-variants-zs cols='sid,nallele,dosagesum,scoresums'
--out prs_Insulin_resistance/chr{}
' :::: chr.sh
############ BMI 
parallel -j 10 -q hrun '
### --score beta_file SNPid effect_allele effect_value header
plink2
--pfile pgen_sortid/chr{}
#chr{}_imputation
--score <(cat summary_GWAS/PGS002360_BMI_Weissbrod/SNPid_beta.txt|grep -E "chr_name|chr{}:") 6 4 3  header-read list-variants-zs cols='sid,nallele,dosagesum,scoresums'
--out prs_BMI_Weissbrod/chr{}
' :::: chr.sh
########### T1D

parallel -j 10 -q hrun '
### --score beta_file SNPid effect_allele effect_value header
plink2
--pfile pgen_sortid/chr{}
#chr{}_imputation
--score <(cat summary_GWAS/PGS002025_T1D_UKB_EA12.5/SNPid_beta.txt|grep -E "chr_name|chr{}:") 6 4 3  header-read list-variants-zs cols='sid,nallele,dosagesum,scoresums'
--out prs_T1D_UKB_EA12/chr{}
' :::: chr.sh


!
########黄心甜专属画图代码

python /storage/syncthing/ucloud/biotools/pipeline/genotype/PRS/prsResultAdd.py
# sed 替换name
less sumPrsscors |sed -e "s#206863650127_R07C02#hxt_F#g" -e "s#206863650127_R06C02#hxt_M#g" -e "s#206863650127_R05C02#hxt#g" -e "s#0_##g" > sumPrsscors_sed_name
sed -i "s/#//g" sumPrsscors_sed_name
# R  regress 
Rscript /storage/syncthing/ucloud/biotools/pipeline/genotype/PRS/regress.r -pca  ../../imputation/result/PCA/pca_prs.pc -s sumPrsscors_sed_name
#plot result
python /storage/syncthing/ucloud/biotools/pipeline/genotype/PRS/prsResidPlot.py residual.txt hxt --index_names hxt hxt_F hxt_M




