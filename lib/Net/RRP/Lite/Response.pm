package Net::RRP::Lite::Response;

use strict;

sub new {
    my($class, $raw_data) = @_;
    my $self = bless {
	_code => 0,
	_message => '',
	_param => {},
    }, $class;
    $self->_initialize($raw_data);
    return $self;
}

sub _initialize {
    my($self, $raw_data) = @_;
    my @lines = split(/\r\n/, $raw_data);
    my $status_line = shift @lines;
    my($code, $message) = $status_line =~ m/^(\d+)\s+(.*)$/;
    $self->code($code);
    $self->message($message);
    my %vars;
    for my $line(@lines) {
	my($key, $val) = split(/\s*:\s*/, $line, 2);
	$self->param($key => $val);
    }
    return $self;
}

sub param {
    my $self = shift;
    if (@_ == 0) {
        return keys %{$self->{_param}};
    }
    elsif (@_ == 1) {
	$_[0] =~ s/_/ /g;
        return $self->{_param}->{$_[0]};
    }
    else {
        $self->{_param}->{$_[0]} = $_[1];
    }
}

sub code {
    my($self, $code) = @_;
    $self->{_code} = $code if $code;
    return $self->{_code};
}

sub message {
    my($self, $message) = @_;
    $self->{_message} = $message if $message;
    return $self->{_message};
}

1;

__END__
