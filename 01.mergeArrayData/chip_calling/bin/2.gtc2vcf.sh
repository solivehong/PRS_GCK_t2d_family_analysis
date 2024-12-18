export PATH="$HOME/bin:$PATH"
export BCFTOOLS_PLUGINS="$HOME/bin"
bpm_manifest_file=$1
#/data/ref/2_ref/bpm_bpmcsv_egt/ASAMD-24v1-0_20025976_A2.bpm
egt_cluster_file=$2
#/data/ref/2_ref/bpm_bpmcsv_egt/ASAMD-24v1-0_A2_ClusterFile_2nd_CHANGED_50BTYPES_202209.egt
path_to_idat_folder=$3
#/data/IDAT/
csv_manifest_file=$4
#/data/ref/2_ref/bpm_bpmcsv_egt/ASAMD-24v1-0_20025976_A2.bpm.csv
path_to_gtc_folder=$5
#./
ref=$6
#"$HOME/GRCh37/human_g1k_v37.fasta" #$HOME/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna
##########################
out_prefix=$7

###########################
bcftools +gtc2vcf \
  --no-version -Ou \
  --bpm $bpm_manifest_file \
  --egt $egt_cluster_file \
  --gtcs $path_to_gtc_folder \
  --fasta-ref $ref \
  --extra $out_prefix.tsv | \
  bcftools sort -Ou -T ./bcftools. | \
  bcftools norm --no-version -Ob -c x -f $ref | \
  tee $out_prefix.bcf | \
  bcftools index --force --output $out_prefix.bcf.csi
