#和版本0.2相比，不在使用有效的位点计算比例，而是使用群体的材料数量作为比例计算的分母，因为有效位点个数不合理，比如目标群非渐渗个体在此位点有很少的有效位点，这样计算出来的比例就会很高。
my $file=$ARGV[0]; #vcf文件
my $popu1=$ARGV[1]; #目标群(计算群)
my $popu2=$ARGV[2]; #参考群（来源群）


open(IN,$file) or die "not find $file!\n";
my $line=<IN>;
while($line=~m/^##.+/){ # discrad anno
	$line=<IN>;
}

my %sampleIndexMap=();

my @a=split "\t",$line; #title
print "pos";  #output the title
foreach $i (9 .. $#a){	
	$sampleIndexMap{$a[$i]}=$i;  #recode the column index of sample 
}

my @popu1=();
open(POPU,$popu1) or die "not find $popu1\n";
@a=<POPU>; chomp @a;
my $popu1Count=@a;
foreach $i (0 .. $popu1Count-1) {
	$popu1[$i][0]=$a[$i];
	$popu1[$i][1]=$sampleIndexMap{$a[$i]};
	print "\t",$a[$i];
}
close(POPU);
print "\n";

my @popu2=();
open(POPU,$popu2) or die "not find $popu2\n";
@a=<POPU>; chomp @a;
my $popu2Count=@a;
foreach $i (0 .. $popu2Count-1) {
        $popu2[$i][0]=$a[$i];
        $popu2[$i][1]=$sampleIndexMap{$a[$i]};
}
close(POPU);

my @result=();

my %diffMap=(); #统计相似率差异分布

while(<IN>) {
	chomp ;
	my @a=split "\t";	

        my %map1=();
        foreach $i (0 .. $popu1Count-1){ #目标群体的各个碱基的数量
                my @b=split ":",$a[$popu1[$i][1]];
                if ($b[0] ne "./."){
			my @c=split "/",$b[0]; #考虑杂合
			if ($c[0] ne $c[1]) {
                       		$map1{$c[0]}++;
				$map1{$c[1]}++;
			}else {
				$map1{$c[0]}++;
			}
                }
        }


        my %map2=();
        foreach $i (0 .. $popu2Count-1){ #参考群体的各个剑姬的数量
                my @b=split ":",$a[$popu2[$i][1]];
                if ($b[0] ne "./."){
			my @c=split "/",$b[0]; 
			if ($c[0] ne $c[1]) {
 				$map2{$c[0]}++;
        	                $map2{$c[1]}++;
			}else {
				$map2{$c[0]}++;
			}
                }
        }
	
	my $pos=$a[1];
	
	print $pos;
	foreach $i (0 .. $popu1Count-1){ #计算每个位点的两个群相似度差 
		my @b=split ":",$a[$popu1[$i][1]];
		my $diff=0.0;		
		if ($b[0] ne "./."){
			my @c=split "/",$b[0];
			$diff=int((($map2{$c[0]}+$map2{$c[1]})/(2*$popu2Count)-($map1{$c[0]}+$map1{$c[1]})/(2*$popu1Count))*100);
		}
		print "\t$diff";
		$diffMap{$diff}++;
	}		
	print "\n";		
}			
close(IN);

