# Text::BarGraph - a module to generate bar graphs in plain text
# See example program at the end of this file.
# Kirk Baucom <kbaucom@schizoid.com>

package Text::BarGraph;

use strict;
use vars qw /$VERSION %fields $AUTOLOAD %data/;

$VERSION = 0.01;


%fields = (
	dot	=>	".",	# character to graph with
	num	=>	undef,	# display data value in ()'s
	sort	=>	"key",	# key or data
	zero	=>	0,	# value to start the graph with
	max_data =>	0,	# where to end the graph
	autozero =>	undef,	# automatically set start value
	autosize =>	undef,	# requires Term::ReadKey
	xsize	=>	80,	# columns
);

%data = ();

sub new {
   my $that = shift;
   my $class = ref($that) || $that;
   my $self = {
      _permitted => \%fields,
      %fields,
   };
   bless $self, $class;
   return $self;
}

sub AUTOLOAD {
   my $self = shift;
   my $type = ref($self) || die "$self is not an object";
   my $name = $AUTOLOAD;
   $name =~ s/.*://; # strip fully qualified portion
   unless (exists $self->{_permitted}->{$name} ) {
      die "Can't access `$name' field in object of class $type";
      }
   if (@_) {
      return $self->{$name} = shift;
   } else {
      return $self->{$name};
   }
}

sub DESTROY { }

sub graph {
  my ($self, $data, $dot) = @_;
  my ($gtext, $junk) = '';
  
  if($self->{'autosize'}) {
    require Term::ReadKey;
    import Term::ReadKey;
    ($self->{'xsize'}, $junk, $junk, $junk) = GetTerminalSize('STDOUT');
  }
  unless(defined($dot) && $dot =~ /^\S$/) { $dot = $self->{'dot'}; }
  my $tag = 5;
  my $scale = 1;
  %data = %$data;

  # find initial column width and scaling
  my $min_data = undef;
  my $max_data = undef;

  for(keys %data) {
    if(!defined($min_data) || $min_data > $data{$_}) { $min_data = $data{$_}; }
    if(length($_) > $tag) { $tag = length($_); }
    if(!defined($max_data) || $data{$_} > $max_data) {
      $max_data = $data{$_};
    }
  }
  if(!defined($max_data) || $self->{'max_data'} > $max_data) {
    $max_data = $self->{'max_data'};
  }

  my $data_length = length($max_data);
  my $sep = " ";
  my ($barsize, $sort, $dots) = '';

  if($tag > ($self->{'xsize'} * .25)) { 
    $sep = "\n"; 
    $barsize = $self->{'xsize'};
  } 
  else { 
    $sep = " ";
    if($self->{'num'}) {
      $barsize = $self->{'xsize'} - ($tag + $data_length + 4);
    }
    else {
      $barsize = $self->{'xsize'} - ($tag + 1);
    }
  }

  if($self->{'autozero'}) { 
    $self->{'zero'} = int($min_data - (($max_data - $min_data) / ($barsize - 1))); 
  }

  if($max_data) { $scale = $barsize / ($max_data - $self->{'zero'}); }
  $sort = $self->{'sort'};

  # print stuff
  if($self->{'num'}) {
    for(sort $sort keys %data) { 
      $dots = int(($data{$_} - $self->{'zero'}) * $scale);
      if($self->{'dataonly'}) { }
      else {
        $gtext .= sprintf "%${tag}s (%${data_length}d)${sep}%s\n", 
             $_, $data{$_}, ${dot}x$dots;
      }
    }
    if($self->{'zero'} && !$self->{'dataonly'}) {
      $gtext .= sprintf "%${tag}s  %${data_length}d /\n", '<zero>', $self->{'zero'};
    }
  }
  else {
    for(sort $sort keys %data) { 
      $dots = int(($data{$_} - $self->{'zero'}) * $scale);
      if($self->{'dataonly'}) { }
      else {
        $gtext .= sprintf "%${tag}s${sep}%s\n", $_, ${dot}x$dots;
      }
    }
    if($self->{'zero'} && !$self->{'dataonly'}) {
      $gtext .= sprintf "%${tag}s/\n", "$self->{'zero'} ";
    }
  }
  return $gtext;
}

sub key {
  return $a cmp $b;
}

sub data {
  return $data{$a} <=> $data{$b};
}

1;

__DATA__

=head1 NAME

Text::BarGraph - Text Bar graph generator

=head1 SYNOPSIS

use Text::BarGraph;

=head1 DESCRIPTION

This module takes as input a hash, where the keys are labels for bars on
a graph and the values are the magnitudes of those bars.

=head1 USAGE

$g = Text::BarGraph->new();

%hash = (
  alpha => 30,
  beta  => 40,
  gamma => 25
);

print $g->graph(\%hash);

=head1 OPTIONS

There are several options available to determine how the data is graphed.
After creating an object $g, you can set an option by entering:

$g->{'option_name'} = "value";

The options (and default values) that are available are:

  dot     =>      ".",    # character to graph with
  num     =>      undef,  # display data value in ()'s
  sort    =>      "key",  # key or data
  zero    =>      0,      # value to start the graph with
  max_data =>     0, 	  # where to end the graph
  autozero =>     undef,  # automatically set start value
  autosize =>     undef,  # requires Term::ReadKey
  xsize   =>      80,     # columns

=head1 AUTHOR

Kirk Baucom <kbaucom@schizoid.com>

=head1 COPYRIGHT

Copyright (c) 2001 Kirk Baucom.  All rights reserved.  This package
is free software; you can redistribute it and/or modify it under the same
terms as Perl itself.

=cut

