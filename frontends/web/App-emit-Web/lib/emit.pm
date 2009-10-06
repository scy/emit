use MooseX::Declare;

class emit {
	use Data::Dumper;

	has 'version' => (is => 'ro', isa => 'Str', default => 'foo');

	method fields($current_fields?) {
		# TODO: correctly format the fields if given
		# TODO: correctly receive the fields via HTTP and decode the JSON

		return [ { name => 'version', type => 'line', default => '3.c' } ];
	}
}
