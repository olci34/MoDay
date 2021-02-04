require 'pry'
require 'httparty'
require 'open-uri'
require 'nokogiri'
require 'colorize'
require 'tty-screen'
require 'tty-prompt'

require_relative '../lib/cli.rb'
require_relative '../lib/scraper.rb'
require_relative '../lib/genre.rb'
require_relative '../lib/movie.rb'
require_relative '../lib/api.rb'
require_relative '../lib/person.rb' #Person class requirement should be above Star and Director classes because it is the superclass
require_relative '../lib/star.rb'
require_relative '../lib/director.rb'

