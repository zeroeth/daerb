daerb
=====

Y'know, that stuff from heaven.

daerb is a scraper for various magic card sites to create visualizations of how cards have progressed over time.

Instructions
------------

The magiccardinfo scraper has 3 segments so far.

* download_all_pages.rb: downloads all the sets from the US section.
* image_downloader.rb: parses through those set pages to retrieve images
* set_page.rb: parse a set page for all its cards.


The gatherer scraper worked off a large html file that there's no way to download anymore.

Todo
----

* Track cards that were removed and then added back in a large timeline graph
* Graph power and numbers of various types and subtypes over each release
