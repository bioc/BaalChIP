#!/bin/perl

my $snpfile=$ARGV[0];
my $genomepath=$ARGV[1];
my $readlength=$ARGV[2];
my $readquality=$ARGV[3];
my $sequencefile;
my $chr;
#perl -ne '@chromlist=(1..22, X, Y); print "@chromlist";exit'
#perl -ne 'foreach my $i (1..22, X, Y) {print "chr$i ";};exit'
foreach my $i (1..22, X, Y) {
$chr=$i;
read_files();
print_overlaps();
}

sub read_files {
open(SNP, $snpfile) or die "cannot open snpfile";
open(SEQUENCE, "zcat $genomepath/chr$chr.fa.gz |") or die "cannot open sequencefile";
}

sub print_overlaps {
@sequence=<SEQUENCE>;
chomp(@sequence);
$sequence=join("",@sequence);
$sequence =~ s/>chr$chr//g;
#print $sequence;
<SNP>;
while($line=<SNP>){
chomp($line);
my @line = split(/ /, $line);
#print("$line[2]\n");
my $plusbase;
#print "$line[1]\tchr$chr\n";
if($line[1] eq "chr$chr"){
if($line[3] eq "+"){
$plusbase=$line[4]
}
elsif($line[3] eq "-"){
$plusbase = $line[4];
$plusbase =~ tr/ATGCYRKMBDHVatgcyrkmbdhv/TACGRYMKVHDBtacgrymkvhdb/;
}

for(my $i=0; $i<$readlength; $i++) {
my $short = substr($sequence, ($line[2]-($readlength-1-$i)-1), $readlength-1-$i).$plusbase.substr($sequence, ($line[2]), $i);
my $RC = $short;
$RC =~ tr/ATGCYRKMBDHVatgcyrkmbdhv/TACGRYMKVHDBtacgrymkvhdb/;
$RC = reverse($RC);
print('@', "$line[0]_$line[1]_$line[2]_REF_+_$plusbase", "_$i", "\n$short\n", '+', "$line[0]_$line[1]_$line[2]_REF_+_$plusbase", "_$i", "\n$readquality\n");
print('@', "$line[0]_$line[1]_$line[2]_REF_-_$plusbase", "_$i", "\n$RC\n", '+', "$line[0]_$line[1]_$line[2]_REF_-_$plusbase", "_$i", "\n$readquality\n");
}

if($line[3] eq "+"){
$plusbase=$line[5]
}
elsif($line[3] eq "-"){
$plusbase = $line[5]; 
$plusbase =~ tr/ATGCYRKMBDHVatgcyrkmbdhv/TACGRYMKVHDBtacgrymkvhdb/;
}

for(my $i=0; $i<$readlength; $i++) {
my $short = substr($sequence, ($line[2]-($readlength-1-$i)-1), $readlength-1-$i).$plusbase.substr($sequence, ($line[2]), $i);
my $RC = $short;
$RC =~ tr/ATGCYRKMBDHVatgcyrkmbdhv/TACGRYMKVHDBtacgrymkvhdb/;
$RC = reverse($RC);
print('@', "$line[0]_$line[1]_$line[2]_NONREF_+_$plusbase", "_$i", "\n$short\n", '+', "$line[0]_$line[1]_$line[2]_NONREF_+_$plusbase", "_$i", "\n$readquality\n");
print('@', "$line[0]_$line[1]_$line[2]_NONREF_-_$plusbase", "_$i", "\n$RC\n", '+', "$line[0]_$line[1]_$line[2]_NONREF_-_$plusbase", "_$i", "\n$readquality\n");
}
}
}
close(SNP);
close(SEQUENCE);
}


