require 'pry'
require 'open-uri'
require 'nokogiri'

class Scraper

    GENRE_NAMES_URL = "https://www.imdb.com/chart/top/?ref_=nv_mv_250"

    def self.scrape_genre_names
        uri_html = open(GENRE_NAMES_URL)
        doc = Nokogiri::HTML(uri_html)
        genre_names_data = doc.css("li.subnav_item_main a").children
        genre_names = genre_names_data.collect {|data| data.text.strip}
    end

end