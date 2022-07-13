#!/usr/bin/perl -w

$/ = "</dublin_core>\n"; # record separator

$what = 10001; # dummy id for when there’s no file

while (<>) {

    # discard the top and bottom tags
    s/<collection>\n//;
    s/<\/collection>\n//;
    s/qualifier=\"dcmi type vocabulary\"//;
    s/<dcvalue element=\"coverage\".*?<\/dcvalue>//;

    # extract the file path from the identifier
    # use the file name as an id
    # note that identifier element is discarded!
    if (s!<dcvalue element="identifier" qualifier="uri" language="en">http://.*/theses/(.*?)/([^/]+).pdf<\/dcvalue>\n!!s) {
        $path = $1;
        $id = $2;
    } else {
        $path = '';
        $id = $what++;
    }

    # let the operator know where we’re up to
    print "$path/$id\n";

    # create the item directory
    mkdir "import/$id", 0755;

    # create the dublin_core.xml file
    open DC, ">import/$id/dublin_core.xml"
      or die "Cannot open dublin core for $id, $!\n";
    print DC $_;
    close DC;

    # assuming we have a file ...
    

        # ... create the contents file ...
        open OUT, ">import/$id/contents"
          or die "Cannot open contents for $id, $!\n";
          open OUT, ">import/$id/handle"
          or die "Cannot open contents for $id, $!\n";
   if ($path) {  
      print OUT "$id.pdf";
        close OUT;

        # ... and create a symbolic link to the actual file
        symlink "/scratch/dspace/import/theses/$path/$id.pdf",
          "import/$id/$id.pdf";

    }

}

__END__

