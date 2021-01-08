# ref: https://github.com/ALiangLiang/pchome-api
require 'bundler'
Bundler.require

class Client
  attr_reader :url, :cookies, :headers

  def initialize
    @url = 'https://24h.pchome.com.tw/prod/'
    @cookies = {
      domain: 'pchome.com.tw',
      cookie: 'https://24h.pchome.com.tw/'
    }
    @headers = {
      'content_type': 'application/x-www-form-urlencoded',
      'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36'
    }
  end

  def post_snapup(product_id)
    target = url + "cart/v1/prod/#{product_id}/snapup?_callback=jsonp_cartsnapup&_=#{Time.now.to_i * 1000}"
    resp = RestClient.get(target)
    p resp
    p resp.body
    if resp.code == 200
      json = JSON.parse(resp.body.match(/jsonp_cartsnapup\((.*?)\)/)[1])
      #   if (data.Status !== 'OK' || !data.MACExpire || !data.MAC) {
      p json
      meta = { mac_expire: json["MACExpire"], mac: json["MAC"] }
      p meta
      return  meta
    else
      p "fail"
      return {}
    end
  end

  def post_add_to_cart
  end
end

# puts "請到瀏覽器進行結帳..."
# Launchy.open("https://ecssl.pchome.com.tw/sys/cflow/fsindex/BigCar/BIGCAR/ItemList")

# https://24h.pchome.com.tw/prod/?fq=/S/DBAC23

# Client.new.post_snapup("DBAC23-A900B0SKB-000")

"""
client = Client.new

success = []
fail = []

items = GoogleSheet.load("")
items.each do |item|
  begin
    client.add2cart(item.product_id, item.amount)
    success << item
  rescue
    fail << item
  end
end

p success.count
p fail.count

p fail
"""
