
## 
my $file=$ARGV[0]; # The vcf file name which contain complete path 
my $popu1=$ARGV[1]; # The file name of the group which is the object of introgression 
my $popu2=$ARGV[2]; # The file name of the group which is the source of introgression


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

my %diffMap=(); 
while(<IN>) {
	chomp ;
	my @a=split "\t";	

        my %map1=();
        foreach $i (0 .. $popu1Count-1){ 
                my @b=split ":",$a[$popu1[$i][1]];
                if ($b[0] ne "./."){
			my @c=split "/",$b[0]; 
			if ($c[0] ne $c[1]) {
                       		$map1{$c[0]}++;
				$map1{$c[1]}++;
			}else {
				$map1{$c[0]}++;
			}
                }
        }


        my %map2=();
        foreach $i (0 .. $popu2Count-1){ 
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
	foreach $i (0 .. $popu1Count-1){ # Calculate the ratio diff between two group
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

