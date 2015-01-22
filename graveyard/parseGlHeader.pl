#!/usr/bin/env perl
use warnings;
use strict;

# Pipe input through `cpp $FILENAME -P -dD -fpreprocessed -E` before passing to this script!
# This strips out potentially confusing comments.

my $MATCH_FUNCTION_DEF = 'GLAPI\s+(.+)\s+GLAPIENTRY\s+(\w+)\s*\((.*)\);';
my $MATCH_SIMPLE_TYPEDEF = 'typedef\s+(\b.+\b)\s+(\w+);';
my $MATCH_FUNCTION_TYPEDEF = 'typedef\s+(\b.+\b)\s+\(APIENTRYP (\w+)\)\s+((.*)\);

sub formatGlFunc {
	my $returnType = shift;
	my $name = shift;
	my @parameters = shift;
}

sub argC2D {
	my $arg = shift;
}

foreach (my $file in @ARGV) {
	# Open file and remove comments
	@output = `cpp $file -E -P -dD -fpreprocessed`;

	my $line;
	while (chomp($line = shift @output)) {

		# Handle #defines that really should be enums
		if ($line =~ /#define (GL_\w+) (\w+)/) {
			print "enum $1 = $2;\n";
		}

		# Handl API functions
		elsif ($line =~ /[^#]*GLAPI/) {
			# Handle line continuations
			until ($line =~ /;/) {
				chomp($line .= shift @output);
			}

			# Verify that the function is sane
			unless ($line =~ /$MATCH_FUNCTION_DEF/) {
				die "Cannot handle function definition \"$line\"";
			}

			my $returnType = $1;
			my $name = $2;
			my @parameters = split(/\s*,\s*/, $3);


		}

		# Handle typedefs
		elsif ($line =~ /$MATCH_SIMPLE_TYPEDEF/) {
			my $type = $1;
			my $def = $2;

			print "alias $def = $type;\n";
		}
		
	}
}


while ((my $line = <>)) {
}
