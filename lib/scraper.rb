class Scraper

    GENRE_NAMES_URL = "https://www.imdb.com/chart/top/?ref_=nv_mv_250"

    GENRE_MOVIES_URL = "https://www.imdb.com/search/title/?title_type=feature&num_votes=25000,&genres="


    def self.scrape_genre_names
        uri_html = open(GENRE_NAMES_URL)
        doc = Nokogiri::HTML(uri_html)
        genre_names_data = doc.css("li.subnav_item_main a").children
        genre_names = genre_names_data.collect {|data| data.text.strip}
    end

    def self.scrape_movie_ids(genre)
        url = GENRE_MOVIES_URL + genre.name.downcase + "&sort=user_rating,desc"
        uri_html = open(url)
        doc = Nokogiri::HTML(uri_html)
        movie_id_data = doc.css(".lister-item-header a")
        movie_id_array = movie_id_data.collect {|data| data.attributes["href"].value.split("/")[2]}
        binding.pry
    end

end