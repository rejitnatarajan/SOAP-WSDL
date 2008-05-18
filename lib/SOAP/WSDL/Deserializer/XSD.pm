package SOAP::WSDL::Deserializer::XSD;
use strict;
use warnings;
use Class::Std::Fast::Storable;
use SOAP::WSDL::SOAP::Typelib::Fault11;
use SOAP::WSDL::Expat::MessageParser;

use version; our $VERSION = qv('2.00.03');

my %class_resolver_of :ATTR(:name<class_resolver> :default<()>);

my %parser_of :ATTR();

sub BUILD {
    my ($self, $ident, $args_of_ref) = @_;

    # ignore all options except 'class_resolver'
    for (keys %{ $args_of_ref }) {
        delete $args_of_ref->{ $_ } if $_ ne 'class_resolver';
    }
}

sub deserialize {
    my ($self, $content) = @_;

    $parser_of{ ${ $self } } = SOAP::WSDL::Expat::MessageParser->new()
        if not $parser_of{ ${ $self } };
    $parser_of{ ${ $self } }->class_resolver( $class_resolver_of{ ${ $self } } );
    eval { $parser_of{ ${ $self } }->parse_string( $content ) };
    if ($@) {
        return $self->generate_fault({
            code => 'soap:Server',
            role => 'urn:localhost',
            message => "Error deserializing message: $@. \n"
                . "Message was: \n$content"
        });
    }
    return ( $parser_of{ ${ $self } }->get_data(), $parser_of{ ${ $self } }->get_header() );
}

sub generate_fault {
    my ($self, $args_from_ref) = @_;
    return SOAP::WSDL::SOAP::Typelib::Fault11->new({
            faultcode => $args_from_ref->{ code } || 'soap:Client',
            faultactor => $args_from_ref->{ role } || 'urn:localhost',
            faultstring => $args_from_ref->{ message } || "Unknown error"
    });
}

1;

__END__

=head1 NAME

SOAP::WSDL::Deserializer::XSD - Deserializer SOAP messages into SOAP::WSDL::XSD::Typelib:: objects

=head1 DESCRIPTION

Default deserializer for SOAP::WSDL::Client and interface classes generated by
SOAP::WSDL. Converts SOAP messages to SOAP::WSDL::XSD::Typlib:: based objects.

Needs a class_resolver typemap either passed by the generated interface
or user-provided.

SOAP::WSDL::Deserializer classes implement the API described in
L<SOAP::WSDL::Factory::Deserializer>.

=head1 USAGE

Usually you don't need to do anything to use this package - it's the default
deserializer for SOAP::WSDL::Client and interface classes generated by
SOAP::WSDL.

If you want to use the XSD serializer from SOAP::WSDL, set the outputtree()
property and provide a class_resolver.

=head1 METHODS

=head2 deserialize

Deserializes the message.

=head2 generate_fault

Generates a L<SOAP::WSDL::SOAP::Typelib::Fault11|SOAP::WSDL::SOAP::Typelib::Fault11>
object and returns it.

=head1 LICENSE AND COPYRIGHT

Copyright 2004-2007 Martin Kutter.

This file is part of SOAP-WSDL. You may distribute/modify it under
the same terms as perl itself.

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=head1 REPOSITORY INFORMATION

 $Rev: 677 $
 $LastChangedBy: kutterma $
 $Id: XSD.pm 677 2008-05-18 20:17:56Z kutterma $
 $HeadURL: http://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL/Deserializer/XSD.pm $

=cut
