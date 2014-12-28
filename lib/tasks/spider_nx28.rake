# -*- encoding : utf-8 -*-
require 'typhoeus'
begin
  require 'iconv'
rescue ::LoadError
end
begin
  require 'qiniu'
rescue LoadError
  raise "You dot't have the 'qiniu' gem installed"
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

$already_save_items = []

$nx28_host = 'www.nx28.com'
$user_id = -1
$cookie_text = 'PHPSESSID=2e420997dd2d3091ced8229523026be3; bdshare_firstime=1374656542333; Hm_lvt_78a188c0c24fb2a2a9d799a6e43f2e9d=1374652221; Hm_lpvt_78a188c0c24fb2a2a9d799a6e43f2e9d=1375250174; __utma=266646609.213124975.1374655648.1375006184.1375246848.6; __utmb=266646609.15.10.1375246848; __utmc=266646609; __utmz=266646609.1374655648.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)'
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
        "Host"            => $nx28_host,
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
    dest_list << {:xtype => 1, :local_id => category[:local_id], :url => "http://#{$nx28_host}/category/0-0-0-0-0-#{category[:dest_id]}-0-1-0-0/1.html"}
    dest_list << {:xtype => 1, :local_id => category[:local_id], :url => "http://#{$nx28_host}/category/0-0-0-0-0-#{category[:dest_id]}-0-1-0-0/2.html"}
    dest_list << {:xtype => 2, :local_id => category[:local_id], :url => "http://#{$nx28_host}/category/0-0-0-0-0-#{category[:dest_id]}-0-2-0-0/1.html"}
    dest_list << {:xtype => 2, :local_id => category[:local_id], :url => "http://#{$nx28_host}/category/0-0-0-0-0-#{category[:dest_id]}-0-2-0-0/2.html"}
  end
  dest_list
end

def get_dest_items_url_list(category_list)
  dest_list = []
  category_list.each do |category|
    items_in_the_category = get_dest_items_url_list_by_category(category[:url])
    items_in_the_category.each do |item|
      dest_list << {:xtype => category[:xtype], :category_id => category[:local_id], :url => item[:url], :title => item[:title]}
    end
    #break # for local test
  end
  dest_list
end

def get_dest_items_url_list_by_category(category_url)

  puts "Get items link from #{category_url}"
  dest_list = []
  html = crawl_get(category_url)
  doc = Nokogiri::HTML(html,nil,'utf-8')
  index = 0;
  doc.css('div.listTable table tr td.td1').each do |td|
    index += 1
    next if index <= 10
    link = td.css('a.flink1')[0]
    item_link  =  "http://#{$nx28_host}" + link[:href].to_s
    item_title = link.content.to_s
    puts "Push #{link} --- populate_dest_items_link_by_category"
    dest_list << { :url => item_link, :title => item_title }
  end

  dest_list
end

def populate_item(item_url_info)

  item = {}
  item[:category_id] = item_url_info[:category_id]
  item[:xtype] = item_url_info[:xtype]
  item_url = item_url_info[:url]
  item_url = item_url.gsub(/[\s\b]*/,'')
  item[:src] = item_url
  item[:title] = item_url_info[:title].gsub(/[\s\b]*/,'')

  puts "Begin crawl ====> #{item_url}"

  item[:exists] = 0
  if $already_save_items.include?(item[:src]) or Item.exists?(:source => item[:src])
    item[:exists] = 1
    return item
  end

  html = crawl_get(item_url)
  doc = Nokogiri::HTML(html,nil,'utf-8')

  item[:body] = doc.css('div.detail div.detailBox.mt10 p.gray9')[0].content

  params_zone = doc.css('div.detail div.flashText.detailBox p')
  item[:name] = params_zone[0].content.gsub('产品：','')
  item[:amount] = params_zone[1].content.gsub('供应量：','').gsub('[','').gsub(']','')
  item[:contact_name] = params_zone[4].content.gsub('发布人：','')
  item[:contact_phone] = params_zone.css('span.contact-mobile')[0].content

  area_zone = doc.css('div.detail div.detailBox.mt10 p.fgreen1.b.mt10')
  item[:ip] = area_zone[1].content
  area_ary = area_zone.css('a')[4][:href].to_s.gsub('/category/','').gsub('-0-0-0-0-0-0.html','').split('-')
  item[:province_code] = area_ary[0]
  item[:city_code] = area_ary[1]
  item[:county_code] = area_ary[2]
  item[:town_code] = area_ary[3]
  item[:village_code] = area_ary[4]

  category2_zone = doc.css('body > div.daohang1 > a:nth-child(4)')
  category2_link_array = category2_zone[0][:href].to_s.gsub('/category/','').gsub('-0-0-0.html','').split('-')
  if(category2_link_array.size > 0)
    dest_category2_id = category2_link_array[6]
    local_category2 = ::Category.find_by_nid(dest_category2_id.to_i)
    item[:category2_id] = local_category2.id
    puts 'category2:----' + item[:category2_id].to_s
  end

  image_zone = doc.css('div.detail div.flashBox div.zoombox div.zoompic img')
  if image_zone and image_zone[0]
    item[:image] = image_zone[0][:src]
  end

  item
end


def save_item(hash)
  begin
    if hash[:exists] == 1
      puts "===>  #{hash[:title]} was already exists."
      return
    end

    if(hash[:image] and hash[:image].gsub(' ','').length == 0)
      puts "====> NO images ....."
    end

    item               = Item.new
    item.user_id       = $user_id
    item.title         = hash[:title]
    item.category_id   = hash[:category_id]
    item.category2_id  = hash[:category2_id]
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
    item.tag_list      = hash[:name]


    if $already_save_items.include?(item.source) or Item.exists?(:source => item.source)
      puts "===>  #{tmp_item.title} was already exists..."
      return
    else
      if(item.save!)
        $already_save_items.push item.source
        puts "===> #{item[:title]} save ok"

        if(hash[:image] and hash[:image].gsub(' ','').length > 0 and item.id > 0)
          image_url = hash[:image].gsub("'", "").gsub(' ','')
          if(!image_url.end_with?('images/imagesbg.png'))
            pic = Picture.new
            pic.remote_image_url = image_url
            pic.imageable_id = item.id
            pic.imageable_type = 'Item'

            if(pic.save!)
              puts "====> #{item[:title]} image save ok"
            end
          end
        end
      end
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

def run_spider
  category_list = get_dest_categories_url_list
  puts "====> Get #{ category_list.size } categorie's url"

  items_url_list = get_dest_items_url_list(category_list)
  puts "====> Get #{ items_url_list.size } items' url"

  index = 0
  size = items_url_list.size

  items_url_list.each do |item_url|
    index += 1
    item = populate_item(item_url)
    save_item item
    puts "====>Processed #{index}/#{size}"
  end
end

namespace :spider do
  desc 'Crawl nx28 items'
  task :nx28 => :environment do
    run_spider
  end
end
