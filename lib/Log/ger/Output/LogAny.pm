package Log::ger::Output::LogAny;

# DATE
# VERSION

use strict;
use warnings;

my %Log_Any_Loggers;

sub get_hooks {
    my %conf = @_;

    return {
        create_log_routine => [
            __PACKAGE__, 50,
            sub {
                my %args = @_;

                return [] unless $args{target} eq 'package';
                my $pkg = $args{target_arg};

                {
                    my $log = Log::Any->get_logger(category => $pkg);
                    $Log_Any_Loggers{$pkg} = $log;
                }

                my $meth = $args{str_level};
                my $logger = sub {
                    my $ctx = shift;
                    $Log_Any_Loggers{$pkg}->$meth(@_);
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
