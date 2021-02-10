#本版本相对于0.4版本，考虑在计算是将本窗口的最后一个snp作为下一个窗口snp的起始，以便窗口之间的合并
my $dataPath=$ARGV[0];
my $chr=$ARGV[1]; 
my $partCount=$ARGV[2];
my $snpCount=$ARGV[3];

my @result=();
my $colCount=0;
my $c=1; #snp计数器
my $binCount=1; #区间计数器
for $i( 1 .. $partCount) {
	my $file="$dataPath/${chr}_$i.groupDiff";
	open(IN,$file) or die "not find $file!\n";
	my $line=<IN>;
	chomp $line;
	my @a=split "\t",$line; #title
	if ($i eq 1 ) {
		$colCount=@a;
		print "begin\tend\tcount";
		foreach $j (1 .. @a-1){
			print "\t",$a[$j];
		}
		print "\n";
	}
	$line=<IN>;
	while ($line){
		my @b=split "\t",$line ;
		if ($c eq 1 ){
			$result[$binCount][0]=$b[0];  #记录区间起始位置
		}else {
			$result[$binCount][1]=$b[0];  #递增记录区间结束位置
		}		
		for $j(1 .. @a-1){
			$result[$binCount][$j+2]+=$b[$j]; #差异比例直接累加
		}
		$result[$binCount][2]++;            #记录snp个数，主要是为了处理最后一个区间
		if ($c eq $snpCount) {
                	$binCount++;                #区间计数加1
			$result[$binCount][2]=1;    #区间初始化snp值为1
                	$c=1;
		}else {
			$line=<IN>;
			$c++;
		}        	
	}
	close(IN);
}
my %diffMap=();
foreach $i (1 .. $binCount) {
		print "",$result[$i][0],"\t",$result[$i][1],"\t",$result[$i][2];	#打印必须以字符开头
		foreach $j (1 .. $colCount-1){ 
			print  "\t";
			my $avgDiff=$result[$i][$j+2]/$result[$i][2];			
                        printf  "%.2f",$avgDiff;
			$diffMap{int($avgDiff)}++;
                }	
		print "\n";
}

open(OUT,">$dataPath/$chr.stat");
foreach $key (keys %diffMap){
	print OUT $key,"\t",$diffMap{$key},"\n";
}
close(OUT);
