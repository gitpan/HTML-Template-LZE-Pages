use lib qw(lib);
use HTML::Template::LZE::Pages;
use Test::More tests => 1;
use Cwd;
my $cwd  = cwd();
my $test = new HTML::Template::LZE::Pages;
use CGI::LZE qw(:all);
print header;
print start_html(-title => 'Window', -style => '/style/Crystal/pages.css',);
$ENV{SCRIPT_NAME} = "pages.pl";
my %needed = (

        start => '20',

        length => '345',

        style => 'Crystal',

        mod_rewrite => 0,

        action => 'dbs',

        linkspropage => 3,

);
print $test->makePages(\%needed);
print end_html;
