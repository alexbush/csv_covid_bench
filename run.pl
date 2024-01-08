#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature qw(say);
use Data::Dumper;

exit main() unless caller;

sub main {
	my $stat = {};
	open my $fh, '<time-series-19-covid-combined.csv';
	<$fh>;
	while(<$fh>) {
		chomp;

		my ($date, $region, $confirmed, $recovered, $deaths) = (parse($_))[0,1,3,4,5];
		my ($year) = split /-/, $date;

		$stat->{$region}{$year}{c} += $confirmed if $confirmed;
		$stat->{$region}{$year}{r} += $recovered if $recovered;
		$stat->{$region}{$year}{d} += $deaths    if $deaths;

	}
	close $fh;

	for my $region (sort keys %$stat) {
		say "$region:";
		while (my ($year, $data) = each %{$stat->{$region}}) {
			say "\t$year - ",
				$data->{c} ? "$data->{c}" : "",
				$data->{r} ? ", $data->{r}" : "",
				$data->{d} ? ", $data->{d}" : "";
		}
	}

	return 0;
}

sub parse {
	my ($str) = shift;
	my @result;
	if ($str =~ m/"/) {
		my $cell = '';
		my $quote = 0;

		my @line = split //, $str;
		for(my $i = 0; $i < scalar @line; $i++) {
			my $char = $line[$i];
			if($char eq '"' and $line[$i + 1] eq '"') {
				$cell .= $char;
				$i++;
			} elsif($char eq '"') {
				$quote = !$quote;
			} elsif(!$quote and $char eq ',') {
				push @result, $cell;
				$cell = '';
			} else {
				$cell .= $char;
			}
			if ( $i == scalar @line - 1 and $cell) {
				push @result, $cell;
			}
		}
	} else {
		@result = split /,/, $str;
	}
	return @result;
}
