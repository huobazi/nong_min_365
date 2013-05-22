# -*- encoding : utf-8 -*-
require 'typhoeus'
begin 
  require 'iconv'
rescue ::LoadError
end

namespace :spider do
  desc 'Crawl nx28 items' 
  task :nx28 => [:environment] do

    $nx28_host = 'nx28.com'
    $user_id = -1

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

    def crawl_get(url)
      result = ''
      cookie_text = 'bdshare_firstime=1356352719136; pgv_pvi=423747584; CNZZDATA3114370=cnzz_eid=51588337-1358960656-http%253A%252F%252Fnx28.com%252Fpublish.php&ntime=1358960656&cnzz_a=0&retime=1358960660923&sin=none&ltime=1358960660923&rtime=0; PHPSESSID=a3043151dd2b3f41c1d88686128db085; pgv_si=s4281730048; jiathis_rdc=%7B%22http%3A//nx28.com/show_info/201206/0625_093405986222.html%22%3A2050894098%2C%22http%3A//nx28.com/show_info/201203/0328_071231507671.html%22%3A2056380285%2C%22http%3A//nx28.com/show_info/201203/0326_191554564885.html%22%3A2056432554%2C%22http%3A//nx28.com/show_info/201205/0526_081336710598.html%22%3A2056501855%2C%22http%3A//nx28.com/show_info/201112/1207_142237325986.html%22%3A2056624753%2C%22http%3A//nx28.com/show_info/201202/0210_100700598924.html%22%3A2056680311%2C%22http%3A//nx28.com/show_info/201109/0901_222739146675.html%22%3A2056728248%2C%22http%3A//nx28.com/show_info/201206/0617_113813364647.html%22%3A2056779709%2C%22http%3A//nx28.com/show_info/201112/1222_124514136579.html%22%3A2076151246%2C%22http%3A//nx28.com/show_info/201112/1222_124514136579.html%23%22%3A0%7C1359285907939%2C%22http%3A//nx28.com/show_info/201108/0830_221220734472.html%22%3A%220%7C1359285976794%22%7D; __utma=266646609.1896206118.1357617206.1359266281.1359285741.10; __utmc=266646609; __utmz=266646609.1357617206.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); Hm_lvt_78a188c0c24fb2a2a9d799a6e43f2e9d=1356952583,1358168420,1358960640,1359260274; Hm_lpvt_78a188c0c24fb2a2a9d799a6e43f2e9d=1359285985'

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

    def populate_categories
      dest_categories = []
      begin
        local_categories = Category.all
        html = crawl_get($nx28_host)
        doc = Nokogiri::HTML(html)
        doc.css('div.link_quanzi_index').css('a').each do |link|
          name =  link.content.gsub(/[\r\n\t\s\b\B]*/,'')
          link  =  link[:href].split('=')[1]
          category = local_categories.find{|x| x.name == name }
          if category
            dest_categories.push({:short_name => link, :name => name,  :local_id => category.id })
          end
        end
      rescue Exception => e
        # exception
      else
        # other exception
      ensure
        # always executed
      end

      puts "Get #{dest_categories.size} categories OK."
      
      dest_categories
    end

    def populate_items_link_by_category(short_name, category_id, xtype)
      items_link_list = []

      begin
        url = "http://#{$nx28_host}/info_list_gongxu.php?s_r=#{xtype}&info_classes=#{short_name}"
        puts url
        html = crawl_get(url)
        doc = Nokogiri::HTML(html)
        doc.css('div.middle_mian_l_content table tr>td:nth-child(2)>a').each do |link|
          name =  link.content.gsub(/[\r\n\t\s\b\B]*/,'')
          link  =  link[:href].gsub('../','http://nx28.com/')
          puts "Push #{link}.....populate_items_link_by_category"
          items_link_list.push({:link => link, :category_id => category_id, :xtype => xtype })
        end
      rescue Exception => e
        # exception
      else
        # other exception
      ensure
        # always executed
      end

      items_link_list.slice 0,22
    end

    def populate_item(url, category_id, xtype)
      item = {}
      begin
        url = url.gsub(/[\r\n\t\s\b\B]*/,'') 
        puts "Begin crawl #{url}....populate_item"

        item[:exists] = 0
        tmp = Item.find_by_source(url)
        if tmp and tmp.id > 0 and tmp.user_id == $user_id
          item[:exists] = 1
          return item
        end

        html = crawl_get(url)
        doc = Nokogiri::HTML(html,nil,'gbk')

        title = doc.css('title')[0].content.gsub('-农享网','')
        amount = doc.css('font[color="#FF0000"]')[0].content
        el_phone = doc.css('span[class="middle_r_main_publishtime_source_scan_check_phone"]')[0]
        if el_phone
          contact_phone = el_phone.content
        else
          contact_phone = doc.css('div#2')[0].content.split(':')[1]
        end

        body = doc.css('div.middle_r_main_title').css('p')[0].content
        options = doc.css('div#content')[0].content
        zone = doc.css('div[class="middle_r_main_publishtime_source_scan_check_diqu"]')[0].content.split('IP')[0].split('|')

        item[:src]           = url
        item[:category_id]   = category_id
        item[:title]         = title.gsub(/[\r\n\t\s\b\B]*/,'')
        item[:amount]        = amount.gsub(/[\r\n\t\s\b\B]*/,'')
        item[:contact_phone] = contact_phone.gsub(/[\r\n\t\s\b\B]*/,'')
        item[:body]          = body

        item[:xtype]         = (xtype == 0 ? 1 : 2)
        item[:contact_name]  = options.split('发布人：')[1].split('联系')[0].gsub(/\n/,'').gsub(/[\r\n\t\s\b\B]*/,'')

        item[:sheng]         = zone[0].split('：')[1].gsub('省','').gsub(/[\r\n\t\s\b\B]*/,'')
        item[:shi]           = zone[1].gsub(/[\r\n\t\s\b\B]*/,'')
        item[:xian]          = zone[2].gsub(/[\r\n\t\s\b\B]*/,'')
        item[:xiang]         = zone[3].gsub(/[\r\n\t\s\b\B]*/,'')
        item[:cun]           = zone[4].gsub(/[\r\n\t\s\b\B]*/,'')

        item[:province_code] = (ChineseRegion.find_by_name item[:sheng]).code
        item[:city_code]     = (ChineseRegion.find_by_name item[:shi]).code
        item[:county_code]   = (ChineseRegion.find_by_name item[:xian]).code
        item[:town_code]     = (ChineseRegion.find_by_name item[:xiang]).code
        item[:village_code]  = (ChineseRegion.find_by_name item[:cun]).code

      rescue Exception => e
        # exception
      else
        # other exception
      ensure
        # always executed
      end

      item
    end

    def save_item(hash)
      begin
        if hash[:exists] == 1
          puts '===  #{item[:title]} was already exists.'
          return
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

      rescue Exception => e
        #exception
        puts e.message
      else
        #other exception
      ensure
        #always executed
      end

    end

    items_link_list = []
    categories_list = populate_categories
    categories_list.each do |category|
      items_link_list.concat populate_items_link_by_category(category[:short_name], category[:local_id],0)
      items_link_list.concat populate_items_link_by_category(category[:short_name], category[:local_id],1)
    end

    items_size = items_link_list.size

    items_link_list.each_with_index do |item_link, index|
      item = populate_item(item_link[:link], item_link[:category_id],item_link[:xtype])
      if item[:exists] == 0
        save_item(item)
        puts "All:-#{items_size}-Now:-#{index + 1}-- save the item #{item[:title]}"
        sleep(0.1)
      end
    end

  end
end

