package Bio::KBase::Handle;
use MIME::Base64;
use JSON;


use Exporter qw(import);
# our @EXPORT = qw(encode_handle decode_handle handle_to_perl handle_to_json);
our @EXPORT_OK = qw(encode_handle decode_handle handle_to_perl handle_to_json);
our %EXPORT_TAGS = ( all => [qw(encode_handle decode_handle handle_to_perl handle_to_json)] );



sub encode_handle {
  my $h = shift or die "must provide a json string or perl hash to encode_handle";
  my $encoded;

  if (ref $h eq 'HASH') {
    $encoded = encode_base64(handle_to_json( $h ));
  }
  else {
    $encoded = encode_base64($h, "");
  }
  return $encoded;
}


sub decode_handle {
  my $h = shift or die "must prvide an encoded handle to decode_handle";
  return decode_base64($h);
}


sub handle_to_perl {
  my $utf8_encoded_json_text = shift
    or die "must provide utf8_encoded_json_text to handle_to_perl";
  return decode_json $utf8_encoded_json_text;
}


sub handle_to_json {
  my $perl_hash_or_arrayref = shift
    or die "must provide perl_hash_or_arrayref to handle_to_json";
  return encode_json ($perl_hash_or_arrayref);
}


=pod

=head1 NAME

 Bio::KBase::Handle - used on handles returned from the handle
 service


=head1 SYNOPSIS

 use Bio::KBase::HandleService
 use Bio::KBase::Handle qw(:all);
   -- or --
 use Bio::KBase::Handle qw(encode_handle
                           decode_handle
                           handle_to_perl
                           handle_to_json);

 $obj = Bio::KBase::HandleService->new($url)
 $h = $obj->new_handle()

 # encode_handle
 $e = encode_handle($h);

 # decode_handle
 $js = decode_handle($e);

 # handle_to_perl
 $ph = handle_to_perl($js);

 # handle_to_json
 $js = handle_to_json($ph);



=head1 DESCRIPTION

This module provides functions for encoding and decoding base64
json representations of handle service handles.

=head2 Methods

=over 12

=item C<encode_handle>

Encodes a base64 json representation of a handle. This function can
take either a json string or a perl hash representation of the json
handle.

=item C<decode_handle>

Decodes a base64 json representation of a handle.

=item C<handle_to_perl>

Converts a json represetnation of a handle into a perl hash.

=item C<handle_to_jason>

Converts a perl hash representation of a handle into a json string.

=back

=head1 AUTHOR

Thomas Brettin

=head1 SEE ALSO

HandleService

=cut



1;

