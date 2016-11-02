#!/usr/bin/perl -w

use Gtk;         # load the Gtk-Perl module
use strict;      # a good idea for all non-trivial Perl scripts

set_locale Gtk;  # internationalize
init Gtk;        # initialize Gtk-Perl

# convenience variables for true and false
my $false = 0;
my $true = 1;

# widget creation
my $window = new Gtk::Window( "toplevel" );
my $button = new Gtk::Button( "Goodbye World" );

# callback registration
$window->signal_connect( "delete_event", \&CloseAppWindow );   
$button->signal_connect( "clicked", \&CloseAppWindow );

# show button
$button->show();

# set window attributes and show it
$window->border_width( 15 );
$window->add( $button );
$window->show();

# Gtk event loop
main Gtk;

# Should never get here
exit( 0 );



### Callback function to close the window
sub CloseAppWindow
{
   Gtk->exit( 0 );
   return $false;
}


# END EXAMPLE PROGRAM
