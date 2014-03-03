package Net::LCDproc::Widget::VBar;

#ABSTRACT: draw a vertical bar

use v5.10.2;
use Moo;
use Types::Standard qw/Int/;
use namespace::sweep;

extends 'Net::LCDproc::Widget';
with 'Net::LCDproc::Role::Widget';

has ['x', 'y', 'length'] => (
    is       => 'rwp',
    isa      => Int,
    required => 1,
    trigger  => \&_set_attr,
);

has '+_set_cmd' => ( default => sub { [qw/ x y length /] } );

1;

