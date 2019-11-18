#!/usr/bin/perl

my $hexip=$ARGV[0];
my $hexport=$ARGV[1];

print "hex: $hexip\n";

my @ip = map hex($_), ( $hexip =~ m/../g );

my $ip = join('.',reverse(@ip));

my $port = hex($hexport);

print "IP: $ip  PORT: $port\n";
