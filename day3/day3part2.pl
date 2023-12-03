#!/usr/bin/perl

use strict;
use warnings;
 
use List::Util      qw(sum product);

open my $fh, '<', 'day3part2.in';
my @grid = map { chomp; ".$_." } <$fh>;
close $fh;
 
push   ( @grid, '.' x length $grid[0] );
unshift( @grid, '.' x length $grid[0] );
 
my %gears;
 
foreach my $line (1 .. $#grid - 1) {
    while ($grid[$line] =~ m#(\d+)#g) {
        my $num = $1;
        my $x = pos($grid[$line]) - length($num) - 1;
        my $found = 0;
        foreach my $y ($line - 1 .. $line + 1) {
            my $str = substr( $grid[$y], $x, length($num) + 2 );
 
            $found = 1                                    if ($str =~ m#[^.0-9]#);
            push( $gears{$y, $x + pos($str)}->@*, $num )  while ($str =~ m#\*#g);
        }
    }
}
 
my $result = sum map { product @$_ } grep { @$_ == 2 } values %gears;
 
print "Sum: $result\n";