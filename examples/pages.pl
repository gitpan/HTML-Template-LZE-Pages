#!/usr/bin/perl -w
use lib qw(lib);
use HTML::Template::LZE::Pages;
use Cwd;
my $cwd  = cwd();
my $test = new HTML::Template::LZE::Pages;
use CGI::LZE qw(:all);
print header;
print start_html(-title => 'HTML::Template::LZE::Pages', -style => '/style/Crystal/pages.css',);
my %needed = (

        length => '345',

        style => 'Crystal',

        mod_rewrite => 0,

        action => "Pages",

        start => param('von') ? param('von') : 0,

        path => "/home/groups/l/li/lindnerei/cgi-bin/",

);
print $test->makePages(\%needed);

use showsource;
&showSource("./pages.pl");
print end_html;
