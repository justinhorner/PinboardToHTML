# PinboardToHTML

This small script allows user's of [Pinboard](https://pinboard.in) to backup/export all their bookmarks to the [Netscape Bookmark File Format](http://msdn.microsoft.com/en-us/library/aa753582(VS.85).aspx) for easy import into browsers.

Yes I realize Pinboard already has a tool for exporting, however I wanted to get some programming practice and have some fun!

# Steps to install and run

1. clone project
2. run `bundle` to get dependencies
3. edit `config.json` with your own Pinboard API Token and your [Tags](#tags) for browser bookmarks in Pinboard
4. run `ruby main.rb`
5. see outputted bookmarks.html file

# Tags

The Tags parameter in the config.json file is a string with each value seperated by an empty space ' ' (just link in Pinboard)