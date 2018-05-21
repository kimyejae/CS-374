#!/usr/bin/perl 

use strict;
use Net::Ping;
use List::Util 'shuffle';

my @hosts = qw/kernighan
augusta
church
codd
hillis
noyce-kilby
wilkes
taylor
backus-naur
englebart
thompson
wirth
turing
eckert-mauchly
babbage
zuse
hoare
stroustrup
atanasoff
knuth
torvalds
wall
leibniz
sutherland
hollerith
boole
aiken
chomsky
ritchie
hopper
kay
goldberg
dijkstra
stallman
vonneuman/;
# cray

my $p = Net::Ping->new("tcp",5);
$p->{port_num} = getservbyname("ssh", "tcp");
$p->service_check(1);
my $numchildren;

pipe(FIN,FOUT);

foreach my $host (@hosts) 
{
    $numchildren++;
    if ($numchildren > 100) {
            while(wait() != -1 && $numchildren > 50) { $numchildren--; }
    }
    unless(fork())
    {
        close(FIN);
        if ($p->ping($host))
        {
            print FOUT "$host\n";
        }
        exit 0;
    }
}

while (wait() != -1) { $numchildren--; }

close(FOUT);
my @linux_hosts;
while (<FIN>)
{
        push(@linux_hosts,$_);
}
close(FIN);

my @shuffled = shuffle(@linux_hosts);

foreach my $host(@shuffled) { chomp $host; print $host . "\n"; }
