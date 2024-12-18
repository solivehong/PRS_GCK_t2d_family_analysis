bpm_manifest_file=$3
#/data/ref/2_ref/bpm_bpmcsv_egt/ASAMD-24v1-0_20025976_A2.bpm
egt_cluster_file=$2
#/data/ref/2_ref/bpm_bpmcsv_egt/ASAMD-24v1-0_A2_ClusterFile_2nd_CHANGED_50BTYPES_202209.egt
path_to_idat_folder=$1
#path_to_output_folder=$2
output=$4
mkdir -p ${output}/idat2gtc
CLR_ICU_VERSION_OVERRIDE="$(uconv -V | sed 's/.* //g')" LANG="en_US.UTF-8" $HOME/bin/iaap-cli/iaap-cli   gencall   $bpm_manifest_file   $egt_cluster_file   $path_to_output_folder   --idat-folder $path_to_idat_folder   --output-gtc ${output}/idat2gtc --gender-estimate-call-rate-threshold -0.2
