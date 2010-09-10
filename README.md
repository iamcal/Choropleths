Perl Choropleth
===============

Choropleth maps are those geographical maps where different regions/counties are colored differently, like election results, etc.

The super easy way to generate them is to take SVG and transform it. This little script does exactly that, in perl.

It requires XML::Parser, which you might be able to install by doing <code>yum install perl-XML-Parser</code>. If that works, you win.


The script <code>trans.pl</code> parses an SVG source file and modifies colors.
It's currently set up to use <a href="http://commons.wikimedia.org/wiki/File:USA_Counties_with_FIPS_and_names.svg">this awesome public domain map of the USA</a>.
I made a few modifications to the source map to fix some bugs:

* Worth, NO -> Worth, MO
* Polk, WIO -> Polk, WI
* Yukon-Koyukuk, AL -> Yukon-Koyukuk, AK

There are some example outputs along with the code to generate them.

Colors come from <a href="http://colorbrewer2.org/">ColorBrewer</a>, which you should use too.
