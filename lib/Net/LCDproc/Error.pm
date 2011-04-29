package Net::LCDproc::Error;

use 5.010;

use Moose;
extends 'Throwable::Error';

use Data::Dumper qw//;

use namespace::autoclean;

has class_name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    default  => sub { caller(11) },    # XXX: this seems fragile
);

has object => (
    is        => 'ro',
    isa       => 'Object',
    predicate => 'has_object',
);

sub short_msg {
    my $self = shift;
    return sprintf "[%s] %s", $self->class_name, $self->message;
}

sub dump {
    my $self = shift;
    if ( $self->has_object ) {
        $Data::Dumper::Terse = 1;
        return Data::Dumper->Dump( [ $self->object ] );
    }

    return "No object was set by the throwing class";
}

sub throwf {
    my $self    = shift;
    my $msg_str = shift;
    my @args    = @_;

    $self->throw( sprintf $msg_str, @args );
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

1;

__END__

=for stopwords LCDproc Ioan stringified

=pod

=head1 NAME

Net::LCDproc::Error

=head1 SYNOPSIS

    use Net::LCDproc;
    use Try::Tiny;
    
    my $lcdproc = Net::LCDproc->new( server => 'no_such_host', port => 1234 );

    try {    
        $lcdproc->init;
    }
    catch {
        #die $_->message;
        #die $_->dump;
        #die $_->short_msg;
        die $_;
    };

=head1 DESCRIPTION

L<Throwable::Error|Throwable::Error> based exception class. You should probably
read its documentation first, then come back here.

When C<Net::LCDproc> encounters an error, it will throw an exception you can catch, or not.

By default C<Throwable::Error> will provide the error message with a stack trace.
This module offers a few other options for you to choose from.

=head1 ATTRIBUTES

=over 

=item C<class_name>

B<Required>. A string containing the name of the throwing class. 

=item C<object>

Any blessed object, usually a copy of the throwing class' C<$self>.

=back

=head1 METHODS

=over

=item C<short_msg>

Returns a string containing the C<class_name> and the C<message>.

=item C<dump>

Returns a stringified C<< $self->object >>, using L<Data::Dumper|Data::Dumper>. If C<< $self->object >> 
isn't set, returns a string saying so.

=back

=head1 SEE ALSO

L<Throwable::Error|Throwable::Error>

=cut
