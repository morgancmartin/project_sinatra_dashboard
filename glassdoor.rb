require 'rubygems'
require 'HTTParty'
require 'json'

class GlassDoor
  def make_url(company_name, location, ip)
    base_url = 'http://api.glassdoor.com/api/api.htm?v=1&format=json'
    partner_id = "&t.p=#{ENV['GDPARTNER']}"
    partner_key = "&t.k=#{ENV['GLASSDOOR']}"
    action = '&action=employers'
    q = "&q=#{company_name}"
    ip = "&userip=#{ip}"
    user_agent = '&useragent=Mozilla/%2F4.0'
    l = "&l=#{location}"
    url = base_url + partner_id + partner_key + action + q + ip + user_agent + l
  end

  def get_employer(url)
    result = HTTParty.get(url)['response']['employers'][0]
  end

  def overall_rating(company)
    company['overallRating']
  end
end

g = GlassDoor.new
url = g.make_url('CyberCoders', 'Fresno,CA', '146.115.41.66')
p url
result = g.make_request(url)
p result['response']['employers'][0]['overallRating']
