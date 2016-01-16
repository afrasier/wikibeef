class GroceryStore
  require 'uri'
  require 'open-uri'
  require 'openssl'
  require 'json'

  def get(page)
    url = URI.parse("https://en.wikipedia.org/w/api.php?action=parse&page=#{fdaApproval(page)}&prop=links&redirects&format=json&callback=?")
    grocerylist = open(url, { ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE }).read
    grocerylist = grocerylist.strip
    grocerylist = grocerylist[5 ,grocerylist.length-6]
    (JSON.parse grocerylist)['parse']['links']
  end

  def fdaApproval(page)
    URI.escape(page, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end
end