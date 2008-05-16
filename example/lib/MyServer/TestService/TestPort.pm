package MyServer::TestService::TestPort;
use strict;
use warnings;
use Class::Std::Fast::Storable;
use Scalar::Util qw(blessed);
use base qw(SOAP::WSDL::Client::Base);

# only load if it hasn't been loaded before
require MyTypemaps::TestService
    if not MyTypemaps::TestService->can('get_class');

my %transport_class_of :ATTR(:name<transport_class> :default<SOAP::WSDL::Server::CGI>);
my %transport_of :ATTR(:name<transport> :default<()>);
my %dispatch_to :ATTR(:name<dispatch_to>);

my $action_map_ref = {
    'http://www.example.org/benchmark/ListPerson' => 'ListPerson',

};

sub START {
    my ($self, $ident, $arg_ref) = @_;
    eval "require $transport_class_of{ $ident }" 
        or die "Cannot load transport class $transport_class_of{ $ident }: $@";
    $transport_of{ $ident } = $transport_class_of{ $ident }->new({
        action_map_ref => $action_map_ref,
        class_resolver => 'MyTypemaps::TestService',
        dispatch_to => $dispatch_to{ $ident },
    });
}

sub handle {
    $transport_of{ ${ $_[0] } }->handle();
}

1;



__END__

=pod

=head1 NAME

MyInterfaces::TestService::TestPort - SOAP Server Class for the TestService Web Service

=head1 SYNOPSIS

 use MyServer::TestService::TestPort;
 my $server = MyServer::TestService::TestPort->new({
    dispatch_to => 'My::Handler::Class',
    transport_class => 'SOAP::WSDL::Server::CGI',   # optional, default
 });
 $server->handle();


=head1 DESCRIPTION

SOAP Server handler for the TestService web service
located at http://localhost:81/soap-wsdl-test/person.pl.

=head1 SERVICE TestService



=head2 Port TestPort



=head1 METHODS

=head2 General methods

=head3 new

Constructor.

The C<dispatch_to> argument is mandatory. It must be a class or object 
implementing the SOAP Service methods listed below.

=head2 SOAP Service methods

Your dispatch_to class has to implement the following methods:

The examples below serve as copy-and-paste prototypes to use in your
class.

=head3 ListPerson



 sub ListPerson {
    my ($self, $body, $header) = @_;
    # body is a ??? object - sorry, POD not implemented yet
    # header is a ??? object - sorry, POD not implemented yet
    
    # do something with body and header...
    
    return  MyElements::ListPersonResponse->new(  {
    out =>     { # MyTypes::ArrayOfPerson
      NewElement =>       { # MyTypes::Person
        PersonID =>         { # MyTypes::PersonID
          ID =>  $some_value, # int
        },
        Salutation =>  $some_value, # string
        Name =>  $some_value, # string
        GivenName =>  $some_value, # string
        DateOfBirth =>  $some_value, # date
        HomeAddress =>         { # MyTypes::Address
          Street =>  $some_value, # string
          ZIP =>  $some_value, # string
          City =>  $some_value, # string
          Country =>  $some_value, # string
          PhoneNumber => $some_value, # PhoneNumber
          MobilePhoneNumber => $some_value, # PhoneNumber
        },
        WorkAddress =>         { # MyTypes::Address
          Street =>  $some_value, # string
          ZIP =>  $some_value, # string
          City =>  $some_value, # string
          Country =>  $some_value, # string
          PhoneNumber => $some_value, # PhoneNumber
          MobilePhoneNumber => $some_value, # PhoneNumber
        },
        Contracts =>         { # MyTypes::ArrayOfContract
          Contract =>           { # MyTypes::Contract
            ContractID =>  $some_value, # long
            ContractName =>  $some_value, # string
          },
        },
      },
    },
  },
 );

 }



=head1 AUTHOR

Generated by SOAP::WSDL on Mon Dec  3 22:20:32 2007

=pod