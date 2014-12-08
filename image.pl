#! /usr/bin/perl
use strict;
use GD;

sub rgb2n { unpack 'N', pack 'CCCC', 0, @_ }

for my $n ( 1, 2 ) {
    my $im1 = GD::Image->new( 600, 400, 1 );

    $im1->filledRectangle( 0, 0, 600, 400, rgb2n( 255, 255, 255 ) );
$im1->filledRectangle( 100, 100, 500, 300, rgb2n( 255za - $n, 0, 0 ) );

    open O, '>:raw', $n . '.png' or die $!;
    print O $im1->png;
    close O;
}

system q[zip 1.zip 1.png];
system q[zip 2.zip 2.png];
system q[zip 3.zip 1.png 2.png];

my $size1 = -s '1.zip';
my $size2 = -s '2.zip';
my $size3 = -s '3.zip';

print +( $size1 + $size2 ) / $size3;
