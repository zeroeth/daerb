![preview](https://raw.github.com/zeroeth/daerb/master/preview.png)

daerb
=====

Y'know, that stuff from heaven.

daerb is a scraper for various magic card sites to create visualizations of how cards have progressed over time.

Instructions
------------

The magiccardinfo scraper has 3 segments so far.

* download_all_pages.rb: Downloads all the sets from the US section. Run this just once, and you get a local copy to work with.
* image_downloader.rb: Parse through local set pages to retrieve images
* gather_all_cards.rb: Parse through local set pages for all cards and turn them into an array


The gatherer scraper worked off a large html file that there's no way to download anymore.

Todo
----

* Track cards that were removed and then added back in a large timeline graph
* Graph power and numbers of various types and subtypes over each release
