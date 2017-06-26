package Log::ger::Output::LogAny;

# DATE
# VERSION

use strict;
use warnings;

sub get_hooks {
    my %conf = @_;

    return {
        create_log_routine => [
            __PACKAGE__, 50,
            sub {
                my %args = @_;

                my $pkg;
                if ($args{target} eq 'package') {
                    $pkg = $args{target_arg};
                } elsif ($args{target} eq 'object') {
                    $pkg = ref $args{target_arg};
                } else {
                    return [];
                }

                # use init_args as a per-target stash
                $args{init_args}{_la} ||= do {
                    require Log::Any;
                    Log::Any->get_logger(category => $pkg);
                };

                my $meth = $args{str_level};
                my $logger = sub {
                    my $ctx = shift;
                    $args{init_args}{_la}->$meth(@_);
                };
                [$logger];
            }],
    };
}

1;
# ABSTRACT: Send logs to Log::Any

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 use Log::ger::Output 'LogAny';
 use Log::ger;

 log_warn "blah ...";


=head1 DESCRIPTION


=head1 TODO

Can we use L<B::CallChecker> to replace log_XXX calls directly, avoiding extra
call level?


=head1 SEE ALSO

L<Log::Any>
