#!/usr/bin/perl
#
# Generate mid and thumb nail images from files in a directory.
# File names are preserved with _m and _tn postpended
#
# The width is set by variables m_wid and tn_wid
# and the height is scaled to the correct rato.
# 

use strict;
use Image::Size;
use Image::Magick;

use File::stat qw(:FIELDS);

sub bail
{
    my $error = "@_";
    print "Unexpected error $error\n";
    exit(0);
}

my $m_wid = 1000;  # mid size width
my $tn_wid = 260; # thumbnail size width
my $m_height;     # variable for mid size height
my $tn_height;    # variable for thumbnail height
my @dr_list;      # array of full size file names
my $fname;        # file name part, .jpg is assumed
my $fext;
my $fmout;        # mid output file name
my $ftnout;       # thumbnail output file name
my $ii = 0;
my $size_x;       # full image width
my $size_y;       # full image height
my $image = Image::Magick->new(magick=>'JPEG');
my $imx;          # image variabe
my $tmpfilename;   # holder for original file name

#
# First we build the list of  files in the directory
# assumed to be all full sized images
#

my $wheretolook = "/home/zero/Perlcode/test/";
opendir(MYDIR, $wheretolook );

    
while ($tmpfilename = readdir(MYDIR))
{
    next if (-d $wheretolook . $tmpfilename);
    stat($wheretolook . $tmpfilename);
    if ($st_size > 1)
    {
	$dr_list[$ii] = [$st_size, $tmpfilename ];
	$ii++;
    }
}
    
my $linenum = 0;

for($ii=0;$ii <= $#dr_list; $ii++)
{
    print "Processing $dr_list[$ii][1]\t $dr_list[$ii][0]\n";
    ++$linenum;
    ($fname, $fext) = split(/\./,$dr_list[$ii][1]);
    $fmout = $fname . "_m.jpg";
    $ftnout = $fname . "_tn.jpg";
    ($size_x, $size_y) = Image::Size::imgsize("test/$dr_list[$ii][1]");
    print "Image $fmout, $ftnout, size $size_y x $size_x (height x width)\n";
    $m_height = int(($m_wid / $size_x) * $size_y);
    $tn_height = int(($tn_wid / $size_x) * $size_y);
    print "Image scaling $m_wid, $m_height, $tn_wid, $tn_height\n";
    $imx = $image->Read("test/$dr_list[$ii][1]");
    $imx = $image->Scale(width=>$m_wid, height=>$m_height);
    $imx = $image->Write("test/$fmout");
    $imx = $image->Scale(width=>$tn_wid, height=>$tn_height);
    $imx = $image->Write("test/$ftnout");
    @$image = ();
}
         
print "\nProcessed $linenum entries\n";

exit();
