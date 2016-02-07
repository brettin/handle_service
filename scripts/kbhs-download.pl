use strict;
use Bio::KBase::HandleService;
use Bio::KBase::Handle qw(decode_handle);
use Getopt::Long; 
use JSON;
use Pod::Usage;

my $man  = 0;
my $help = 0;
my ($in, $out);
my ($handle, $encode);

GetOptions(
	'h'	=> \$help,
        'i=s'   => \$in,
        'o=s'   => \$out,
        'e'     => \$encode,
	'help'	=> \$help,
	'man'	=> \$man,
	'input=s'  => \$in,
	'output=s' => \$out,
	'handle=s' => \$handle,
  'encode'   => \$encode,

) or pod2usage(0);


pod2usage(-exitstatus => 0,
	  -output => \*STDOUT,
	  -verbose => 1,
	  -noperldoc => 1,
	 ) if $help;

pod2usage(-exitstatus => 0,
          -output => \*STDOUT,
          -verbose => 2,
          -noperldoc => 1,
         ) if $man;

pod2usage(-exitstatus => 0,
          -output => \*STDOUT,
          -verbose => 1,
          -noperldoc => 1,
         ) if ! $out;


# do a little validation on the parameters


my ($ih, $oh);

if ($handle) {
    open $ih, "<", $handle
	or die "Cannot open input handle file $handle: $!";
}
else {
    $ih = \*STDIN;
}

# main logic
# there must be an ih and an out
my $obj = Bio::KBase::HandleService->new();
my $h = deserialize_handle($ih, $encode);
my $rv  = $obj->download($h, $out);


sub serialize_handle {
	my $handle = shift or
		die "handle not passed to serialize_handle";
        my $json_text = to_json( $handle, { ascii => 1, pretty => 1 } );
	print $oh $json_text;
}	


sub deserialize_handle {
	my $ih = shift or
		die "in not passed to deserialize_handle";
  my $encode = shift;

	my ($json_text, $perl_scalar);
	$json_text .= $_ while ( <$ih> );
  if( $encode ) {
    $json_text = decode_handle($json_text);
  }
 	$perl_scalar = from_json( $json_text, { utf8  => 1 } );
}

 

=pod

=head1	NAME

download

=head1	SYNOPSIS

download <options>

=head1	DESCRIPTION

The download command calls the download method of a Bio::KBase::HandleService object. It takes as input a JSON serialized handle either from a file (specified by the --handle option) or STDIN (if the --handle option is not provided) and downloads the data represented by the handle to a file that is specified by the --output option.

=head1	OPTIONS

=over

=item	-h, --help   Basic usage documentation

=item   --man        More detailed documentation

=item   --handle     The input file containing the handle. If not specified, then defaults to STDIN.

=item   -o, --output The file to write the downloaded data to (REQUIRED)

=item   -e, --encode The json representaiton of the handle is base64 encoded.

=back

=head1	AUTHORS

Thomas Brettin

=cut

1;

