#!/usr/bin/env perl
use strict;
use warnings;

use IPC::Open2;

my $PSEUDO_HEADER_FILE = <<EOF;
#include<GL/glew.h>
#include<GL/freeglut.h>
EOF

my $pid = open2(\*CPP_OUT, \*CPP_IN, 'cpp', '-', '-');

print CPP_IN $PSEUDO_HEADER_FILE;
close CPP_IN;

while(defined(my $line = <CPP_OUT>)) {
	chomp($line);
	if ($line =~ /^[^#]/ and $line =~ /[^\w]/) {
		print $line;
		print "\n";
	}
}

