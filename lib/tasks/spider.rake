# -*- encoding : utf-8 -*-
require 'typhoeus'
require "iconv"  
require "iconv"  

namespace :spider do
  desc 'Crawl nx28 items' 
  task :nx28 => [:environment] do

    $nx28_host = 'nx28.com'
    def encode_text(input)
      Iconv.iconv("UTF-8",  "GBK",input)  
    end

    def crawl_get(url)
      cookie_text = 'bdshare_firstime=1356352719136; pgv_pvi=423747584; CNZZDATA3114370=cnzz_eid=51588337-1358960656-http%253A%252F%252Fnx28.com%252Fpublish.php&ntime=1358960656&cnzz_a=0&retime=1358960660923&sin=none&ltime=1358960660923&rtime=0; PHPSESSID=a3043151dd2b3f41c1d88686128db085; pgv_si=s4281730048; jiathis_rdc=%7B%22http%3A//nx28.com/show_info/201206/0625_093405986222.html%22%3A2050894098%2C%22http%3A//nx28.com/show_info/201203/0328_071231507671.html%22%3A2056380285%2C%22http%3A//nx28.com/show_info/201203/0326_191554564885.html%22%3A2056432554%2C%22http%3A//nx28.com/show_info/201205/0526_081336710598.html%22%3A2056501855%2C%22http%3A//nx28.com/show_info/201112/1207_142237325986.html%22%3A2056624753%2C%22http%3A//nx28.com/show_info/201202/0210_100700598924.html%22%3A2056680311%2C%22http%3A//nx28.com/show_info/201109/0901_222739146675.html%22%3A2056728248%2C%22http%3A//nx28.com/show_info/201206/0617_113813364647.html%22%3A2056779709%2C%22http%3A//nx28.com/show_info/201112/1222_124514136579.html%22%3A2076151246%2C%22http%3A//nx28.com/show_info/201112/1222_124514136579.html%23%22%3A0%7C1359285907939%2C%22http%3A//nx28.com/show_info/201108/0830_221220734472.html%22%3A%220%7C1359285976794%22%7D; __utma=266646609.1896206118.1357617206.1359266281.1359285741.10; __utmc=266646609; __utmz=266646609.1357617206.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); Hm_lvt_78a188c0c24fb2a2a9d799a6e43f2e9d=1356952583,1358168420,1358960640,1359260274; Hm_lpvt_78a188c0c24fb2a2a9d799a6e43f2e9d=1359285985'

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

      response.body
    end

    def populate_categories
      local_categories = Category.all
      dest_categories = []
      html = crawl_get($nx28_host)
      doc = Nokogiri::HTML(html)
      doc.css('div.link_quanzi').css('a').each do |link|
        name =  link.content.gsub(/[\r\n\t\s\b\B]*/,'')
        link  =  link[:href].split('=')[1]
        category = local_categories.find{|x| x.name == name }
        if category
          dest_categories.push({:short_name => link, :name => name,  :local_id => category.id })
        end
      end
      dest_categories
    end

    def populate_items_link_by_category(short_name, category_id)
      items_link_list = []
      url = "http://#{$nx28_host}/info_list.php?info_classes=#{short_name}"
      html = crawl_get(url)
      doc = Nokogiri::HTML(html)
      doc.css('div.middle_mian_l_content table tr>td:nth-child(2)>a').each do |link|
        name =  link.content.gsub(/[\r\n\t\s\b\B]*/,'')
        link  =  link[:href].gsub('../','http://nx28.com/')
        items_link_list.push({:link => link, :category_id => category_id })
      end

      items_link_list
    end

    def populateL_item(url, category_id)
      item = {}

      # TODO 这里应该try catch 两种页面
      html = crawl_get(url)
      doc = Nokogiri::HTML(html)
      name = doc.css('div.middle_r_top > span')[0].content

      item[:name] = name 
      item
    end

    def save_item(item)

    end

    items_link_list = []
    categories_list = populate_categories
    categories_list.each do |category|
      items_link_list.concat populate_items_link_by_category(category[:short_name], category[:local_id])
    end

    items_size = items_link_list.size

    items_link_list.each_with_index do |item_link, index|
      item = populateL_item(item_link[:link], item_link[:category_id])
      save_item(item)
      puts "All:-#{items_size}-Now:-#{index + 1}-- save the item #{item[:name]}"
    end

  end
end

