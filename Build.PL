#!/usr/bin/perl -w

use Module::Build;
my $build = new Module::Build
    ( module_name => 'Wx::Perl::FSHandler::LWP',
      license => 'perl',
      requires => { Wx         => 0.13,
                    IO::Scalar => 2,
                  },
    );
$build->create_build_script;
