use Test::More;
use Config::Simple;

my $data = "./client-tests/test.handle";

BEGIN {
	use_ok( Bio::KBase::HandleService );
	use_ok( Bio::KBase::Handle );
}

use Bio::KBase::Handle qw(:all);
can_ok("Bio::KBase::Handle", qw(
    encode_handle
    decode_handle
    handle_to_perl
    handle_to_json
  )
);

# create a new handle

isa_ok ($obj = Bio::KBase::HandleService->new($url), Bio::KBase::HandleService);
ok ($h = $obj->new_handle(), "new_handle returns defined");
ok (exists $h->{url}, "url in handle exists");
ok (defined $h->{url}, "url defined in handle $h->{url}");
ok (exists $h->{id}, "id in handle exists");
ok (defined $h->{id}, "id defined in handle $h->{id}");
ok (exists $h->{hid}, "hid in handle exists");
ok (defined $h->{hid}, "hid defined in handle $h->{hid}");
ok ($obj->are_readable([$h->{hid}]), "hid $h->{hid} in h is readable");
ok ($obj->hids_to_handles([$h->{hid}]), "hid $h->{hid} fetchs a handle with node $h->{id}");
ok ($obj->ids_to_handles([$h->{id}]), "node id $h->{id} fetchs a handle with hid $h->{hid}");

# encode_handle
ok ($e = encode_handle($h), "encode_handle return defined");

# decode_handle
ok ($js = decode_handle($e), "decode_handle return defined");

# handle_to_perl
ok ($ph = handle_to_perl($js), "handle_to_perl returns defined");

# handle_to_json
ok ($js = handle_to_json($ph), "handle_to_json retuned defined");

# encode_handle
ok( $e = encode_handle($js), "encode_handle returned defined");

# decode_handle
ok( $js = decode_handle($e), "decode_handle retured defined");

# handle_to_perl
ok ($ph = handle_to_perl ($js), "handle_to_perl returned defined");

# decode it and pass
ok ( $js = handle_to_json ($ph), "handle_to_json returned defined");
pass (handle_to_json ($ph));


done_testing;
