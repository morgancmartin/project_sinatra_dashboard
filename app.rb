require 'sinatra'
require './dice_scraper.rb'
require 'httparty'
require 'pry-byebug'
require './glassdoor'

enable :sessions

helpers do
  def make_free_geo_url(ip)
    "http://freegeoip.net/json/#{ip}"
  end

  def get_loc_data(ip)
    unless session['loc_data']
      url = make_free_geo_url(ip)
      result = HTTParty.get(url)
      result = result['city'].capitalize + ", " + result['region_name'].capitalize
      session['loc_data'] = result
    end
    session['loc_data']
  end

  def add_company_rating(result_array)
    gd = GlassDoor.new
    result_array.each do |company_array|
      employer_obj = gd.get_employer(company_array[1])
      company_array << gd.overall_rating(employer_obj)
    end
  end
end

get '/' do
  erb :index
end

post '/' do
  job_title = params[:job_title]
  location = params[:location].capitalize
  location = get_loc_data('40.138.174.92') if location.empty?
  scraper = DiceScraper.new(job_title, location)
  result_array = scraper.create_listings_array.compact

  erb :results, locals: {:result_array => result_array, :location => location}
end
