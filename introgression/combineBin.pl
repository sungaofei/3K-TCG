my $bins=$ARGV[0];

open(IN,$bins) or die "not find $!";

#RAD_M280	21700000        21800000        49.23

my $pre="";
my $preStart=0;
my $preEnd=0;
my $total=0;
my $count=0;

while(<IN>){
	chomp;
	my @a=split ;
	if (($a[0] eq $pre) and ($a[1]>$preStart) and ($a[1]<=$preEnd)){
		if ($preStart==0){
			$pre=$a[0];
			$preStart=$a[1];
			$preEnd=$a[2];
			$total=$a[3];
			$count=1;
			
		}else {
                        $preEnd=$a[2];
                        $total=$total+$a[3];
                        $count++;	
			
		}
	}
	else{
		
		if ($count ne 0){
			print $pre,"\t",$preStart,"\t",$preEnd,"\t",$total/$count,"\n";
		}
                $pre=$a[0];
                $preStart=$a[1];
                $preEnd=$a[2];
                $total=$a[3];
                $count=1;
	}	
}
if ($count ne 0){
        print $pre,"\t",$preStart,"\t",$preEnd,"\t",$total/$count,"\n";
}

close(IN);
