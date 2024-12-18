# 获取当前脚本的绝对路径
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# 打印脚本路径
echo "脚本路径: $SCRIPT_PATH"

# 将脚本路径添加到 PATH 环境变量中
# 注意: 这只会在当前脚本运行期间有效
export PATH="$PATH:$SCRIPT_PATH"


bpm=$1
csv=$2
egt=$3
idatpath=$4
output=$5
ref=$6
out_prefix=$7
#idat2gtc
bash $SCRIPT_PATH/1.idat2gtc.sh $idatpath $egt $bpm  $output
#gtc2vcf
bash $SCRIPT_PATH/2.gtc2vcf.sh $bpm $egt $idatpath $csv ${output}/idat2gtc $ref $out_prefix
