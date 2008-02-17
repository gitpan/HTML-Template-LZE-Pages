use lib qw(lib);
use HTML::Template::LZE::Pages;
use Test::More tests => 1;
use Cwd;
my $cwd  = cwd();
my $test = new HTML::Template::LZE::Pages;

my %needed = (
        path  => "$cwd/cgi-bin",
        start => '20',

        length => '345',

        style => 'Crystal',

        mod_rewrite => 1,

        action => 'dbs',

        linkspropage => 3,

);

# print $test->makePages(\%needed);
ok(length($test->makePages(\%needed)) > 0);
