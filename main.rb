#!/usr/bin/ruby
require 'rubygems'
require 'bundler/setup'
# require your gems as usual
require 'open-uri'
require 'httparty'
require 'json'
require 'deep_merge'
require 'pinboard'
require 'markio'

# vars
builder = Markio::Builder.new
cacheLength = 900 # How long in seconds to use old data, Prevents API hammering. (15 minutes)

# read in Pinboard API key and lastUpdate
file = File.read('config.json')
fileHash = JSON.parse(file)
PinboardApiToken = fileHash['PinboardApiToken']
lastUpdate = fileHash['lastUpdate']
tags = fileHash['Tags']

# pinboard
pinboard = Pinboard::Client.new(:token => PinboardApiToken)

# check if pinboard data update is needed, if so save pinboards bookmarks to file
if (Time.now.to_i - lastUpdate.to_i) >= 900
	puts "Getting live copy"
	pinboardPosts = pinboard.posts(:tag => tags)
	File.open("pinboard-data.json","w") do |f|
  		f.write(JSON.pretty_generate(JSON.parse(pinboardPosts.to_json)))
	end
	lastUpdate = Time.now.to_i
	configHash = {
    "PinboardApiToken" => PinboardApiToken,
    "lastUpdate" => lastUpdate,
		"Tags" => tags
	}
	File.open("config.json","w") do |f|
  		f.write(JSON.pretty_generate(JSON.parse(configHash.to_json)))
	end
end

# open bookmarks.json
bookmarks = JSON.parse(File.read('pinboard-data.json'))

# create bookmarks file
bookmarks.each_with_index do |singleBookmark,index|
	dateString = singleBookmark['time']
	date = Time.parse(dateString)
	builder.bookmarks << Markio::Bookmark.create({
  		:title => singleBookmark["description"],
  		:href => singleBookmark['href'],
			:folder => singleBookmark['tag'].drop(1),
  		:add_date => date
	})
end

# write pinboard bookmarks to html file
file_contents = builder.build_string
File.open('bookmarks.html', 'w') { |f| f.write file_contents }
