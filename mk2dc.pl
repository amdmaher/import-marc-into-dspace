#!/usr/bin/perl -w

use MARC::Crosswalk::DublinCore;
use MARC::File::USMARC;

$/ = chr(29); # MARC record separator

print qq|<collection>\n|;

while (my $blob = <>) { # suck in one MARC record at a time

        print qq|<dublin_core>\n|;

        # convert the MARC to DC
        my $marc = MARC::Record->new_from_usmarc( $blob );
        my $crosswalk = MARC::Crosswalk::DublinCore->new( qualified => 1 );
        my $dc        = $crosswalk->as_dublincore( $marc );

        # output the DC as XML
        for( $dc->elements ) {

               # lowercase all attributes
                my $element     = lc $_->name;
                my $qualifier   = lc $_->qualifier;
                my $scheme      = lc $_->scheme;
                my $content     = $_->content;

                # escape reserved characters
                $content =~ s/&/&amp;/gs;
                $content =~ s/</&lt;/gs;
                $content =~ s/>/&gt;/gs;

                # munge attributes for DSpace compatibility
                                
                if ($element eq 'creator') {
                        $element = 'contributor';
                        $qualifier = 'author';
                }
                if ($element eq 'format') {
                        $element = 'description';
                        $qualifier = '';
                }
                if ($element eq 'language') {
                    if ($scheme eq 'iso 639-2') {
                        $qualifier = 'iso';
                        $scheme = '';
                    } else {
                        $element = 'description';
                        $qualifier = '';
                    }
                }
                if ($qualifier eq 'ispartof') {
                        $qualifier = 'ispartofseries';
                }
              #-----------------ahmad-------------#
               if ($element eq 'type') {
                      
                        $qualifier = 'none';
                }
                #--------------------------#  
            
                    
                printf qq|  <dcvalue element="%s"|, $element;
                printf qq| qualifier="%s"|, $qualifier if $qualifier;
                # output scheme as qualifier
                printf qq| qualifier="%s"|, $scheme if $scheme;
                printf qq| language="en">%s</dcvalue>\n|, $content;

        }

        print qq|</dublin_core>\n|;
}

print qq|</collection>\n|;

exit;

