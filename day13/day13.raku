# Find the reflection line for patterns, combining horizontal and vertical checks
sub find-reflection-line(@pattern) {
    my $h = find-reflection-line-horizontal(@pattern);
    return $h < 0 ?? find-reflection-line-horizontal([Z] @pattern) !! $h * 100;
}

# Find the reflection line for horizontal patterns
sub find-reflection-line-horizontal(@pattern) {
    loop (my $row = 0; $row < @pattern.elems - 1; $row += 1) {
        my $i = $row;
        my $j = $row + 1;

        # Check for reflection line horizontally
        while $i >= 0 && $j < @pattern.elems {
            my $above = @pattern[$i];
            my $below = @pattern[$j];
            last unless $above eq $below;

            $i -= 1;
            $j += 1;
        }

        return $row + 1 if $i < 0 or $j >= @pattern.elems;
    }
    return -1;
}

# Find the reflection line for patterns with additional constraints
sub find-reflection-line-part2(@pattern) {
    my $h = find-reflection-line-horizontal-part2(@pattern);
    return $h < 0 ?? find-reflection-line-horizontal-part2([Z] @pattern) !! $h * 100;
}

# Find the reflection line for horizontal patterns with additional constraints
sub find-reflection-line-horizontal-part2(@pattern) {
    my $smudged = find-reflection-line-horizontal(@pattern);

    loop (my $row = 0; $row < @pattern.elems - 1; $row += 1) {
        my $i = $row;
        my $j = $row + 1;
        my $did-hamming = False;

        # Check for reflection line horizontally with additional constraints
        while $i >= 0 && $j < @pattern.elems {
            my $above = @pattern[$i];
            my $below = @pattern[$j];

            last if $above ne $below and $did-hamming;

            if $above ne $below and not $did-hamming {
                last if calc-hamming-distance($above, $below) > 1;
                $did-hamming = True;
            }

            $i -= 1;
            $j += 1;
        }

        next if $row + 1 == $smudged;
        return $row + 1 if $i < 0 or $j >= @pattern.elems;
    }
    return -1;
}

sub parse-input($file where *.IO.f) {
    # Split the file contents into patterns and rows
    my @patterns = $file.IO.split("\n\n", :skip-empty);
    return @patterns.map: { .split("\n", :skip-empty).map: { .comb } };
}

# Calculate the Hamming distance between two strings
sub calc-hamming-distance($a, $b) { return [+] $a.comb Zne $b.comb; }

# Main entry line
sub MAIN() {
    my $file = "day13.in";

    # Print the sum of reflection lines for different strategies
    say [+] parse-input($file).map: &find-reflection-line;
    say [+] parse-input($file).map: &find-reflection-line-part2;
}
