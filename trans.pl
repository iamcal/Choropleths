#!/usr/bin/perl

use strict;
use warnings;
use XML::Parser;


##########################################################################
#
# this is where the real meat is - these functions get passed a FIPs code
# and a label (including state) and return a color.
#

my $input_file = 'USA_Counties_with_FIPS_and_names.svg';
my $colorize_func = \&colorize_by_state;

sub colorize_random {
	my ($id, $label) = @_;

	my @cols = ('#FFFFD9', '#EDF8B1', '#C7E9B4', '#7FCDBB', '#41B6C4', '#1D91C0', '#225EA8', '#253494', '#081D58');
	return $cols[rand @cols];
}

my %state_map;

sub colorize_by_state {
	my ($id, $label) = @_;

	my $state = substr $label, -2, 2;

	if (!$state_map{$state}){
		my @cols = ('#FFF7EC', '#FEE8C8', '#FDD49E', '#FDBB84', '#FC8D59', '#EF6548', '#D7301F', '#B30000', '#7F0000');
		$state_map{$state} = $cols[rand @cols];
	}

	return $state_map{$state};
}

##########################################################################
#
# below this point, you don't need to modify anything
#

my $indent = 0;
my $p = new XML::Parser(XStyle => 'Debug', Handlers => {
	Start	=> \&handle_start,
	End	=> \&handle_end,
	Char	=> \&handle_char,
	Proc	=> \&handle_proc,
	XMLDecl	=> \&handle_decl,
});

$p->parsefile($input_file);


sub handle_start {
	my $expat = shift;
	my $tag = shift;
	my %args = @_;

	#
	# if you change input files, mess with this to detect country/county/whatever outline
	#

	if ($tag eq 'path' && $args{id} && $args{'inkscape:label'} && $args{id} ne 'State_Lines'){

		my $col = &$colorize_func($args{id}, $args{'inkscape:label'});
		$args{style} =~ s/fill:#d0d0d0;/fill:${col};/;
	}

	my $flat = '';
	for my $k(keys %args){
		$flat .= ' '.$k.'="' . &escape($args{$k}) . '"';
	}

	print "\t" x $indent;
	print "<$tag$flat>\n";
	$indent++;
}

sub handle_end {
	my $expat = shift;
	my $tag = shift;
	$indent--;
	print "\t" x $indent;
	print "</$tag>\n";
}

sub handle_char {
	my $expat = shift;
	my $text = shift;

	$text =~ s/^\s+//;
	$text =~ s/\s+$//;

	if (length($text)){
		print "\t" x $indent;
		print $text."\n";
	}
}

sub handle_proc {
	my $expat = shift;
 	my $target = shift;
 	my $text = shift;

	print "$target / $text\n";
	exit;
}

sub handle_decl {
	my $expat = shift;
	my $version = shift;
	my $encoding = shift;
	my $standalone = shift;

	print "<?xml version=\"$version\"";
	print " encoding=\"".($encoding || 'UTF-8')."\"";
	print " standalone=\"".($standalone?'yes':'no')."\"";
	print "?>\n";
}

sub escape {
	$_[0] =~ s/&/&amp;/g;
	$_[0] =~ s/</&lt;/g;
	$_[0] =~ s/>/&gt;/g;
	$_[0] =~ s/"/&quot;/g;
	return $_[0];
}
