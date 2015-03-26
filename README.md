**Fairy - Generate distribution packages, as if by magic!**

Note Fairy is currently just a set of ideas.

Watch the code slowly creep in.


What this will be about
-----------------------

Initially I wanted an easily maintainable replacement for the aging
cpanspec, which is a tool for generating SPEC files (the core of every
RPM package) from CPAN distributions.  However, over time I realised
this could easily be a generic tool, generating arbitary packages for
nearly any packaging system from nearly any source.

So, the long-term plan is:

* Support multiple pluggable source modules (e.g. CPAN, CTAN, GitHub)
* Utilize templates to support various output formats (e.g. SPEC, ebuild)
* Be smart about metadata; attempt to figure out the required dependencies (e.g. using Tangerine for perl, possibly adapt other generators for other languages)
* Given the above, unlike cpanspec, don't bother with support for updating; this tool should only be used for generating new packages
* Invent and support our own "hints" format to assist fully automatic packaging

We'll see how it will work out.
