:<<!
# htop 
#1. setID vcf 
zcat 1.jointCalling/11.hxt_Family.left.multiallelics.pass.HFILTER.vcf.gz|VCFSetID.py|bgzip >1.jointCalling/12.hxt_Family_WES_setID.left.multiallelics.pass.HFILTER.vcf.gz

zcat hxt_family2_lift_sort/lifted_over_sort_huangxt.vcf.gz|VCFSetID.py|bgzip > hxt_family2_lift_sort/lifted_over_sort_setID_huangxt.vcf.gz

#!!!check chrom of chr col

#2. merge format vcfs 
hrun '
plink --vcf hxt_family2_asa.vcf.gz
--make-bed 
--allow-extra-chr
--out hxt_family2_lift_sort/bed/lifted_over_sort_setID_huangxt

&&
plink --vcf 1.jointCalling/12.hxt_Family_WES_setID.left.multiallelics.pass.HFILTER.vcf.gz
--make-bed 
--allow-extra-chr
--out 1.jointCalling/bed/hxt_Family_WES_setID.left.multiallelics.pass.HFILTER
'
### merge tools 
 hrun "
   sh /disk/tools/syncthing/ucloud/biotools/pipeline/genotype/PCA/PCA_Pipeline/PCAKIN_1KG/mergeBedPlink.sh
        result/merged
        1.jointCalling/bed/hxt_Family_WES_setID.left.multiallelics.pass.HFILTER
        hxt_family2_lift_sort/bed/lifted_over_sort_setID_huangxt
        
|bash " 

##recheck wes with asa 
bedtools intersect -a hxt_family2_lift_sort/lifted_over_sort_setID_addchr_huangxt.vcf.gz -b /disk/reference/bed/Agilent_V6_r2/S07604514_Regions.bed -header|bgzip > asa_with_agilent.vcf.gz




##########################command end #################
!
############ runnning line ##############





