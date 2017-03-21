![preview](https://raw.github.com/zeroeth/daerb/master/preview.png)

daerb
=====

Y'know, that stuff from heaven.

daerb is a parser for various card checklist/spoiler sites to create visualizations of how cards have progressed over time as well as their breakdown by various attributes.

Disclaimer <3
-------------

Please be friendly to any source websites and don't hammer them, this is a tool used for my own bemusement and curiosity in how different card games are structured.

Instructions
------------

The `magiccardinfo` parser has 3 segments.

* `download_all_pages.rb`: Downloads all the sets from the US language section. Run this just once, and you get a local copy to work with.
* `gather_all_cards.rb`: Parse through local set pages for all cards and turn them into an array

And not required:

* `image_downloader.rb`: Parse through local set pages to retrieve images (Will download a LOT of images so be warned)


Todo
----

* Track cards that were removed and then added back in a large timeline graph
* Graph power and numbers of various types and subtypes over each release
* TUI based interface or simple choice launcher
* Idempotent downloader using cache date values if possible
* Export/Load from external JSON/DB source after parsing
* Add sources for years and starter decks (MTG)
* Add sources for other card games (TNG, BattleTech, Netrunner)