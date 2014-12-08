#!/usr/bin/perl
use warnings;
use strict;
use Image::Compare;


my $file1 = shift; #some jpegs, or png
my $file2 = shift;

my ( $cmp ) = Image::Compare->new();

$cmp->set_image1(
    img  => $file1,
    type => 'png',
);

$cmp->set_image2(
    img => $file2,
    type => 'png' );

$cmp->set_method(
    method => &Image::Compare::THRESHOLD,
    args  => 25,
);

#$cmp->set_method(
#  method => &Image::Compare::EXACT,
#    );


if ( $cmp->compare() ) {
  # The images are the same, within the threshold
  print "same\n";
}
else {
# The images differ beyond the threshold
  print "not same\n";
}
