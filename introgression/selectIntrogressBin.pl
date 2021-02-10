my $file=$ARGV[0]; #dff文件
my $cutoff=$ARGV[1];
my $count=$ARGV[2]; # snp 的个数，小于一定的个数去掉

if (not defined($count)) {
	$count=0;
}

open(IN,$file) or die "not find $file!\n";
my $line=<IN>;
chomp $line;
my @a=split "\t",$line; #title

while (<IN>) {
	my @b=split ;
	if ($a[2]>=$count) {
		for (my $j=3;$j<@a;$j++){
			if ($b[$j]>$cutoff) {
				print $a[$j],"\t",$b[0],"\t",$b[1],"\t",$b[$j],"\n";
			}
		}
	}
}
close(IN);
