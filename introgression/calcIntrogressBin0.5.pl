#To predict the section of introgression of one chromosome
my $dataPath=$ARGV[0];   #The path of the diff result data whcih is calculate by calcGenetypeLikehood.pl
my $chr=$ARGV[1];        #The name of chromosome , same with the chromosome name in the origin vcf file
my $partCount=$ARGV[2];  #The count that the chromosome has been split when calculating the diff result data 
my $snpCount=$ARGV[3];   #The count of snp in a section ,default is 500

my @result=();
my $colCount=0;
my $c=1;         #The counter of snp
my $binCount=1;  #The counter of section
for $i( 1 .. $partCount) {
	my $file="$dataPath/${chr}_$i.groupDiff";   # The name of diff result must be chromosome name+"_"+part index+".groupDiff"
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
			$result[$binCount][1]=$b[0];  
		}		
		for $j(1 .. @a-1){
			$result[$binCount][$j+2]+=$b[$j]; 
		}
		$result[$binCount][2]++;            
		if ($c eq $snpCount) {
                	$binCount++;                
			$result[$binCount][2]=1;    
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
		print "",$result[$i][0],"\t",$result[$i][1],"\t",$result[$i][2];	#print must begin with character
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
