package HTML::Template::LZE::Pages;
use HTML::Template::LZE::Template;
use strict;
use warnings;

require Exporter;
use vars qw(
  $DefaultClass
  @EXPORT
  @ISA
  $action
  $length
  $start
  $style
  $mod_rewrite
  $append
  $pages
  $linksProPage
  $path
);

@HTML::Template::LZE::Pages::EXPORT = qw(makePages);
@ISA                                = qw(Exporter);

$HTML::Template::LZE::Pages::VERSION = '0.24';

$DefaultClass = 'HTML::Template::LZE::Pages' unless defined $HTML::Template::LZE::Pages::DefaultClass;

=head1 NAME

HTML::Template::LZE::Pages

=head1 SYNOPSIS

use HTML::Template::LZE::Pages;

=head2 OO Syntax.

        my $test = new HTML::Template::LZE::Pages;

        my %needed =(

                start  => '20',

                length    => '345',

                style  => 'Crystal',

                mod_rewrite => 1,

                action  => 'dbs',

                linkspropage => 3,

        );

        print $test->makePages(\%needed );

=head2 FO Syntax.

        my %needed =(

                start  => '20',

                length    => '345',

                style  => 'Crystal',

                mod_rewrite => 1,

                action  => 'dbs',

                append => '?queryString=testit'

        );

        print makePages(\%needed );


=head2 EXPORT

makePages

=head1 Public

=head2 Public new()


=cut

sub new {
        my ($class, @initializer) = @_;
        my $self = {};
        bless $self, ref $class || $class || $DefaultClass;
        return $self;
}

=head2 makePages()

     see SYNOPSIS

=cut

sub makePages {
        my ($self, @p) = getSelf(@_);
        my $hashref = $p[0];
        $action       = $hashref->{action};
        $start        = $hashref->{start} > 0 ? $hashref->{start} : 0;
        $style        = $hashref->{style};
        $mod_rewrite  = $hashref->{mod_rewrite};
        $append       = $hashref->{append} ? $hashref->{append} : '';
        $length       = $hashref->{length} ? $hashref->{length} : 0;
        $pages        = $hashref->{title} ? $hashref->{title} : "Seiten";
        $linksProPage = $hashref->{linkspropage} ? $hashref->{linkspropage} : 10;
        $path         = $hashref->{path} ? $hashref->{path} : 'cgi-bin/';
        $self->ebis() if($length > 10);
}

=head2 ebis()

=cut

sub ebis {
        my ($self, @p) = getSelf(@_);
        my $previousPage = (($start- $linksProPage) > 0) ? $start- $linksProPage : 0;
        my $nextPage = $start;
        $nextPage = 10 if($previousPage <= 0);
        my %template = (path => "$path/templates", style => $style, template => "pages.html", name => 'pages');
        my @data = ({name => 'header', pages => $pages,},);
        my $link = ($mod_rewrite) ? "/$previousPage/$nextPage/$action.html?$append" : "$ENV{SCRIPT_NAME}?von=$previousPage&amp;bis=$nextPage&amp;action=$action$append";
        push @data, {name => "previous", href => "$link",} if($start- $linksProPage >= 0);
        my $sites = (int($length/ 10)+ 1)* 10 unless ($length % $linksProPage== 0);
        $sites = (int($length/ 10))* 10 if($length % $linksProPage== 0);
        my $beginn = $start/ 10;
        $beginn = (int($start/ 10)+ 1)* 10 unless ($start % $linksProPage== 0);
        $beginn = 0 if($beginn < 0);
        my $b = ($sites >= 10) ? $beginn : 0;
        $b = ($beginn- $linksProPage >= 0) ? $beginn- $linksProPage : 0;
        my $end = ($sites >= 10) ? $b+ 10 : $sites;

        while($b < $end) {    # append links
                my $c = $b* $linksProPage;
                my $d = $c+ $linksProPage;
                $d = $length if($d > $length);
                my $svbis = ($mod_rewrite) ? "/$c/$d/$action.html?$append" : "$ENV{SCRIPT_NAME}?von=$c&amp;bis=$d&amp;action=$action$append";
                push @data, ($b* 10 eq $start) ? {name => 'currentLink', href => $svbis, title => $b} : {name => 'link', href => $svbis, title => $b};
                last if($d eq $length);
                $b++;
        }
        my $v    = $start+ $linksProPage;
        my $next = $v+ $linksProPage;
        $next = $length if($next > $length);
        my $esvbis = ($mod_rewrite) ? "/$v/$next/$action.html?$append" : "$ENV{SCRIPT_NAME}?von=$v&amp;bis=$next&amp;action=$action$append";
        push @data, {name => "next", href => $esvbis} if($v < $length);    # apend the Next "button"
        push @data, {name => 'footer'};                                    # apend the footer
        return initTemplate(\%template, \@data);
}

=head2  getSelf()

=cut

sub getSelf {
        return @_ if defined($_[0]) && (!ref($_[0])) && ($_[0] eq 'HTML::Template::LZE::Pages');
        return (defined($_[0]) && (ref($_[0]) eq 'HTML::Template::LZE::Pages' || UNIVERSAL::isa($_[0], 'HTML::Template::LZE::Pages'))) ? @_ : ($HTML::Template::LZE::Pages::DefaultClass->new, @_);
}

=head1 AUTHOR

Dirk Lindner <lindnerei@o2online.de>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 - 2008 by Hr. Dirk Lindner

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public License
as published by the Free Software Foundation; 
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

=cut

1;
