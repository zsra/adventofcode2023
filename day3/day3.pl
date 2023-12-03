#!/usr/bin/perl

use strict; 
use warnings; 

my $filename = 'day3.in';
my @char_matrix;

open my $fh, '<', $filename;

while (my $line = <$fh>) {
    chomp($line);
    my @chars = split //, $line;
    push @char_matrix, \@chars;
}

close $fh;

my @number_info;

for my $i (0 .. $#char_matrix) {
    my $j = 0;

    while ($j <= $#{$char_matrix[$i]}) {
        my $char = $char_matrix[$i][$j];

        if ($char =~ /\d/) {
            my $number = '';
            my $start_j = $j;

            while ($j <= $#{$char_matrix[$i]} && $char_matrix[$i][$j] =~ /\d/) {
                $number .= $char_matrix[$i][$j++];
            }
            my $end_j = $j - 1;
            push @number_info, [$i, $start_j, $end_j, $number];
        } else {
            $j++;
        }
    }
}

my $sum = 0;

foreach my $info (@number_info) {
    my ($row, $start, $end, $number) = @$info;
    my $has_non_dot_neighbor = 0;

    for my $r ($row - 1 .. $row + 1) {
        for my $c ($start - 1 .. $end + 1) {
            next if $r == $row && $c > $start - 1 && $c < $end + 1;
            next if $#char_matrix <= $r;
            next if $c >= @{$char_matrix[$r]};

            if (
                $r >= 0 && $r <= $#char_matrix &&
                $c >= 0 && $c < @{$char_matrix[$r]} &&
                $char_matrix[$r][$c] ne '.'
            ) {
                $has_non_dot_neighbor = 1;
                last;
            }
        }
        last if $has_non_dot_neighbor;
    }

    if ($has_non_dot_neighbor) {
        $sum += $number;
    }
}

print "Sum of valid numbers: $sum\n";