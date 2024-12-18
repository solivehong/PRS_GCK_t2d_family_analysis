#!/bin/bash
cp -r /storage/syncthing/ucloud/biotools/pipeline/chip_calling/bin .
docker run  -it --network host -v `pwd`:/data gtc2vcf:v1




# docker run  -it --network host -v `pwd`:/data gtc2vcf:v1 bash -c "bash /data/bin/1.idat2gtc.sh $idatpath $egt $bpm $output && bash /data/bin/2.gtc2vcf.sh $bpm $egt $idatpath $csv ${output}/idat2gtc $ref $out_prefix"


