# -*- encoding : utf-8 -*-
require 'typhoeus'
begin
  require 'iconv'
rescue ::LoadError
end
begin
  require 'qiniu-rs'
rescue LoadError
  raise "You dot't have the 'qiniu-rs' gem installed"
end

require 'fileutils'


# Converts string encoding
def encode_string(str, src, dst)
  if str.respond_to?(:encode)
    str.encode(dst, { :invalid => :replace, :undef => :replace, :replace => '' })
  else
    begin
      Iconv.conv(dst, src, str)
    rescue
      raise ::RuntimeError, "Your installation does not support iconv (needed for utf8 conversion)"
    end
  end
end

def encode_text(input)
  #Iconv.iconv("UTF-8",  "GBK",input)
  encode_string(input,'GBK','UTF-8')
end

$nx28_host = 'nx28.com'
$user_id = -1
$cookie_text = ''
$dest_local_categories = [
  {:local_id => 1  , :name => '水产渔业' , :dest_id => 5 },
  {:local_id => 2  , :name => '特种养殖' , :dest_id => 6 },
  {:local_id => 3  , :name => '地方特产' , :dest_id => 7 },
  {:local_id => 4  , :name => '茶叶副食' , :dest_id => 8 },
  {:local_id => 5  , :name => '花卉药材' , :dest_id => 9 },
  {:local_id => 6  , :name => '农机物资' , :dest_id => 10},
  {:local_id => 7  , :name => '纤维作物' , :dest_id => 11},
  {:local_id => 8  , :name => '化肥农药' , :dest_id => 12},
  {:local_id => 9  , :name => '物流运输' , :dest_id => 13},
  {:local_id => 10 , :name => '民间工艺' , :dest_id => 14},
  {:local_id => 11 , :name => '有机食品' , :dest_id => 15},
  {:local_id => 12 , :name => '生产加工' , :dest_id => 16},
  {:local_id => 13 , :name => '水果蔬菜' , :dest_id => 2 },
  {:local_id => 14 , :name => '种子苗木' , :dest_id => 4 },
  {:local_id => 15 , :name => '肉禽蛋奶' , :dest_id => 3 },
  {:local_id => 16 , :name => '五谷粮油' , :dest_id => 1 },
  {:local_id => 17 , :name => '土地租赁' , :dest_id => 17},
  {:local_id => 18 , :name => '其它类别' , :dest_id => 18}
]

def crawl_get(url)
  result = ''
  cookie_text = $cookie_text
  begin
    response = Typhoeus::Request.get(
      url,
      :headers => {
        "Host"            => "nx28.com",
        "User-Agent"      => "Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20100101 Firefox/6.0",
        "Referer"         => "http://#{$nx28_host}",
        "Accept"          => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Charset"  => "utf-8;q=0.7,*;q=0.7",
        "Connection"      => "keep-alive",
        "Accept-Language" => "zh-cn,zh;q=0.5",
        "Pragma "         => "no-cache",
        "Cache-Control  " => "no-cache",
        "Cookie"          => cookie_text
      },
      :timeout => 20000, # milliseconds
      #:params => {:field1 => "a field"}
    )

    result = response.body
  rescue Exception
    # exception
  else
    # other exception
  ensure
    # always executed
  end

  result
end


def get_dest_categories_url_list
  dest_list = []
  $dest_local_categories.each do |category|
    dest_list << {:xtype => 1, :local_id => category[:local_id], :url => "http://www.nx28.com/category/0-0-0-0-0-#{category[:dest_id]}-0-1-0-0.html"}
    dest_list << {:xtype => 2, :local_id => category[:local_id], :url => "http://www.nx28.com/category/0-0-0-0-0-#{category[:dest_id]}-0-2-0-0.html"}
  end
  dest_list
end

def get_dest_items_url_list(category_list)
  dest_list = []
  category_list.each do |category|
    items_in_the_category = get_dest_items_url_list_by_category(category[:url])
    items_in_the_category.each do |item|
      dest_list << {:xtype => category[:xtype], :category_id => category[:local_id], :url => item[:url]}
    end
  end
  dest_list
end

def get_dest_items_url_list_by_category(category_url)
  dest_list = []
  dest_list << { item_id => 123, :url => '' }
  dest_list
end

def populate_item(item_url_info)

  item = {}
  item[:exists] = 0
  tmp = Item.find_by_source(item_url_info[:url])
  if tmp and tmp.id > 0 and tmp.user_id == $user_id
    item[:exists] = 1
    return item
  end

  item
end


def save_item(hash)
  begin
    if hash[:exists] == 1
      puts '===  #{item[:title]} was already exists.'
      return
    end

    if(hash[:image] and hash[:image].gsub(' ','').length == 0)
      puts "木有图片....."
    end

    item               = Item.new
    item.user_id       = $user_id
    item.title         = hash[:title]
    item.category_id   = hash[:category_id]
    item.amount        = hash[:amount]
    item.contact_phone = hash[:contact_phone]
    item.body          = hash[:body]
    item.xtype         = hash[:xtype]
    item.contact_name  = hash[:contact_name]
    item.province_code = hash[:province_code]
    item.city_code     = hash[:city_code]
    item.county_code   = hash[:county_code]
    item.town_code     = hash[:town_code]
    item.village_code  = hash[:village_code]
    item.source        = hash[:src]
    item.contact_qq    = '000000'
    item.tag_list      = hash[:sheng]

    item.save!

    if(hash[:image] and hash[:image].gsub(' ','').length > 0 and item.id > 0)
      image_src = hash[:image].gsub("'", "").gsub(' ','')
      image_url = "http://#{$nx28_host}#{image_src}"
      pic = Picture.new
      pic.remote_image_url = image_url
      pic.imageable_id = item.id
      pic.imageable_type = 'Item'
      pic.save!
    end

  rescue Exception => e
    #exception
    puts e.message
  else
    #other exception
  ensure
    #always executed
  end

end


namespace :spider do
  desc 'Crawl nx28 items'
  task :nx29 => [:environment] do
    category_list = get_dest_categories_url_list
    puts "====> Get #{ category_list.size } categorie's url"

    items_url_list = get_dest_items_url_list(category_list)
    puts "====> Get #{ items_list.size } items' url"

    items_url_list.each do |item_url|
      item = populate_item(item_url)
      save_item item
    end

  end
end

