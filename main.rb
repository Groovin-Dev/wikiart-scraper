# frozen_string_literal: true
require 'nokogiri'
require 'open-uri'
require 'fileutils'
require 'down'


puts 'WikiArt Scrapper'
puts '-----'
puts 'What artist would you like to scrape?'

BASE_URL = 'https://www.wikiart.org/'

artist = gets.chomp

if !artist || artist.empty?
  puts 'Please enter an artists name. Try again.'
  exit 1
end

puts "Scraping #{artist}..."

clean_artist = artist.strip.gsub(' ', '-').downcase

Dir.mkdir("#{Dir.pwd}/#{clean_artist}/") unless File.exist?("#{Dir.pwd}/#{clean_artist}/")

art_dir = "#{Dir.pwd}/#{clean_artist}/"

art_list_url = "https://www.wikiart.org/en/#{clean_artist}/all-works/text-list"

# doc = Nokogiri::HTML(URI.open(art_list_url))
doc = Nokogiri::HTML(URI.open(art_list_url))

links = []

doc.css('li.painting-list-text-row a').each do |link|
  links.append(BASE_URL + link['href'])
end

links.each do |link|
  curr_work = Nokogiri::HTML(URI.open(link))

  art_img = curr_work.at_css "img"
  art_src = art_img['src']
  art_name = art_img['alt']

  puts "Downloading #{art_name}"

  tempfile = Down.download(art_src)
  FileUtils.mv(tempfile.path, art_dir)
end


# Zdzislaw Beksinski
# zdzislaw-beksinski
# https://www.wikiart.org/en/zdzislaw-beksinski/all-works/text-list
