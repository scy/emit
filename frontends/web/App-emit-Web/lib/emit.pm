use MooseX::Declare;

class emit {
	use Data::Dumper;

	has 'version' => (is => 'ro', isa => 'Str', default => 'foo');

	method fields($current_fields?) {
		# TODO: correctly format the fields if given
		# TODO: correctly receive the fields via HTTP and decode the JSON

		return [
			{ name => 'description', type => 'line', default => '' },
			{ name => 'comment', type => 'text', default => '' },
			{ name => 'type', type => 'list', allowed => [ qw(bug feature-request task) ] },
			{ name => 'priority', type => 'list', allowed => [ qw(important normal minor) ] },
			{ name => 'version', type => 'list', allowed => [ qw(3.a 3.b 3.c) ] },
			{ name => 'os', type => 'list', 'name-en' => 'Operating System', allowed => [ 'Affects all', 'Linux', 'BSD', 'Other' ] },
			{ name => 'distro', type => 'line', 'name-en' => 'Distribution / flavor' },
			{ name => 'notfinal', type => 'checkbox', 'name-en' => 'I recognize this software is not final' },
		];
	}
}
