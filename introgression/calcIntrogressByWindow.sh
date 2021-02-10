#$1 dataPath   #diff 的数据位置
#$2 chr
#$3 vcf parCount #支持根据chr拆分的多个部分进行计算
#$4 snp 的个数
#$5 cutoff

window=$(( $4*1000))

prefix=$1/$2
perl $WORK/script/introgression/calcIntrogressBin0.5.pl $1 $2 $3 $4 >$prefix.bin.$4

prefix=$prefix.bin.$4

perl $WORK/script/introgression/selectIntrogressBin.pl $prefix $5 > $prefix.cutoff$5

prefix=$prefix.cutoff$5
sort -k1,1 -k2,2n $prefix > $prefix.sort

perl $WORK/script/introgression/combineBin.pl $prefix.sort > $prefix.combine
