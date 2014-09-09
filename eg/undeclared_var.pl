#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Text::Xslate;
use Text::Xslate::AST::Walker;

my $template = do {
  my $template_file = "$FindBin::Bin/undeclared_var.tx";
  open my $fh, '<', $template_file;
  join '', <$fh>;
};

my $tx = Text::Xslate->new;
my $parser = $tx->_compiler->parser;
my $nodes = $parser->parse($template);
my $tw = Text::Xslate::AST::Walker->new(nodes => $nodes);

my $undeclared_vars = $tw->search_descendants(sub {
  my ($node) = @_;
  ($node->arity eq 'variable') && !$node->is_defined && !$node->is_reserved;
});

printf "Undeclared var: %s @ Line %d\n", $_->id, $_->line for @$undeclared_vars;
