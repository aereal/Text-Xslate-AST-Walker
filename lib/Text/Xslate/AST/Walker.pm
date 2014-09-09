package Text::Xslate::AST::Walker;

use strict;
use warnings;
use Class::Accessor::Lite (
  new => 1,
  ro => [qw(nodes)],
);

sub search_descendants {
  my ($self, $predicate) = @_;
  return [ map { @{$self->_recursive_search($_, $predicate)} } @{$self->nodes} ];
}

sub _recursive_search {
  my ($self, $node, $predicate) = @_;
  my @matched;
  push @matched, $node if $predicate->($node);
  my @matched_descendants = map { @{$self->_recursive_search($_, $predicate)} } @{$node->child_symbols};
  push @matched, @matched_descendants;
  return \@matched;
}

package
  Text::Xslate::Symbol;

use strict;
use warnings;

sub child_symbols {
  my ($self) = @_;
  return [
    grep { $_->isa(ref($self)) }
    @{$self->child_nodes}
  ];
}

sub child_nodes {
  my ($self) = @_;
  return [
    grep { defined($_) }
    map { @{_ensure_array_ref($self->$_)} }
    qw(first second third)
  ];
}

sub _ensure_array_ref {
  my ($maybe_arrayref) = @_;
  return ref($maybe_arrayref) eq 'ARRAY' ? $maybe_arrayref : [$maybe_arrayref];
}

1;
