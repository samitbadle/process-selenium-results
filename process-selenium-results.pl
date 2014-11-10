#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;


sub read_file {
    my ($file) = @_;
    if (-f $file) {
        open( my $fh, '<', $file ) or die "Error: Could not open $file for reading: $!\n";
        local $/;
        my $data = <$fh>;
        close( $fh );
        return $data;
    }
    die "Error: Could not find $file for reading\n";
}


sub write_file {
    my ($file, $data) = @_;
    open( my $fh, '>', $file ) or die "Error: Could not open $file for writing: $!\n";
    print $fh $data;
    close $fh;
}


sub process_file {
    my ($data) = @_;

    my $comment_style = <<'EOT';
.comment {
    background-color: #d0d0d0;
}

EOT

    # add comment style
    $data =~ s/\.selected /$comment_style.selected /s;

    # convert comments to a table row
    $data =~ s/<!--(.*?)-->/<tr><td class="comment" colspan="3">$1<\/td><\/tr>/gs;

    return $data;
}


sub process {
    my ($in_file, $out_file) = @_;

    # open file
    my $data = read_file( $in_file );
    # process file
    $data = process_file( $data );
    # write file
    write_file( $out_file, $data );
}


# Parse command line and call the right processing subs
my $in;
my $out;
my $help;
GetOptions(
    'in=s' => \$in,
    'out=s' => \$out,
    'help|h' => \$help,
);
pod2usage(1) if $help;
pod2usage( -output => \*STDERR, -exitval => 2, -msg => "Error: Need an input file that exists with --in" ) unless $in && -f $in;
pod2usage( -output => \*STDERR, -exitval => 3, -msg => "Error: Need an output file that does not exists with --out" ) unless $out && ! -f $out;

process( $in, $out );


__END__

=head1 NAME

process-selenium-results.pl - Process the results file and apply transformations (currently make comments visible)

=head1 SYNOPSIS

process-selenium-results.pl --in input.html --out output.html

Process the results file and apply transformations (currently make comments visible)

    --in input.html     input results file to process.
    --out output.html   output file for processed results, must not exist.

=head1 AUTHOR

Samit Badle

=cut
