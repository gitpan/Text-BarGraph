#!/usr/local/bin/perl -w
#
# Example of the Text::Bargraph module
# Try commenting and uncommenting the options to see how they affect the output
#
# Kirk Baucom <kbaucom@schizoid.com>

use Text::BarGraph;

$g = Text::BarGraph->new();

#### OPTIONS ####

# for the options below, if an option is a toggle, 0 = off, 1 = on
# all of the options have defaults set at the beginning of the module

# whether or not to print the numerical magnitude of the bar
$g->{'num'} = 1;    # default: 0 (off)

# what value to set the far right of the screen to
$g->{'max_data'} = 100;   # default: automatically determined from data

# what character to use when printing the graphs
$g->{'dot'} = "#";    # default: '.'

# what value to set the far left of the screen to
$g->{'zero'} = 10;   # default: 0

# whether or not to automatically determine the value of the far left side
# of the screen. if this is set, the value of 'zero' is ignored.
$g->{'autozero'} = 1;   # default: 0 (off)

# whether or not to automatically determine the size of your screen. this
# requires the module Term::Readkey. if this is off, your screen is assumed
# to be 80 columns
$g->{'autosize'} = 1;    # default: 0 (off)

# number of lines on your display
$g->{'xsize'} = 80;      # default: 80

# whether to sort the data by keys ("key") or values ("data"). 
$g->{'sort'} = "data";  # default: "key"

# whether to sort keys numerically or stringily (stringmatogically?)
$g->{'sorttype'} = "numeric";  # default: "string"

# add color to the graph, denoting the size of the bars
$g->{'color'} = 1;      # default: 0 (off)

# a small graph of some random numbers  

%hash = (
  alpha => 300,
  beta  => 400,
  gamma => 250,
  delta => 350,
);      

# print the graph. note that the graph routine just returns a text string,
# so you can manipulate it (for example, to HTMLize it) before you print it.

print $g->graph(\%hash);
