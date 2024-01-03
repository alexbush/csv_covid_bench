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

	my $header = <$fh>;
	while(<$fh>) {
		chomp;

		next if $_ =~ m/"/;
		my ($date, $region, undef, $confirmed, $recovered, $deaths) = split /,/, $_;

		my ($year) = split /-/, $date;

		$stat->{$region}{$year}{c} += $confirmed if $confirmed;
		$stat->{$region}{$year}{r} += $recovered if $recovered;
		$stat->{$region}{$year}{d} += $deaths if $deaths;

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
