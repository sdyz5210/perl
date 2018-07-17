use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'HelloPerlBuildWorld',
    license             => 'perl',
    dist_abstract       => 'HelloPerlBuildWorld short description',
    dist_author         => 'Author Name <summer>',
    build_requires => {
        'Test::More' => '0.10',
    },
);

$builder->create_build_script();