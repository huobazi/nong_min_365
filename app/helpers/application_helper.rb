# -*- encoding : utf-8 -*-
module ApplicationHelper

  def add_errors_to_flash_now  
    model_name = controller_name[0...-1]  
    model = nil  
    eval("model = @#{model_name}")  
    if model.class.method_defined? :errors  
      if model.errors.any?  
        flash.now[:error] = []  
        model.errors.full_messages.each { |msg|  
          flash.now[:error] << msg  
        }  
      end  
    end  
  end 

  # Helper to display conditional html tags for IE
  # http://paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither
  def html_tag(attrs={})
    attrs.symbolize_keys!
    html = ""
    html << "<!--[if lt IE 7]> #{ tag(:html, add_class('lt-ie9 lt-ie8 lt-ie7', attrs), true) } <![endif]-->\n"
    html << "<!--[if IE 7]>    #{ tag(:html, add_class('lt-ie9 lt-ie8', attrs), true) } <![endif]-->\n"
    html << "<!--[if IE 8]>    #{ tag(:html, add_class('lt-ie9', attrs), true) } <![endif]-->\n"
    html << "<!--[if gt IE 8]><!--> "

    if block_given? && defined? Haml
      haml_concat(html.html_safe)
      haml_tag :html, attrs do
        haml_concat("<!--<![endif]-->".html_safe)
        yield
      end
    else
      html = html.html_safe
      html << tag(:html, attrs, true)
      html << " <!--<![endif]-->\n".html_safe
      html
    end
  end

  def render_body_tag
    class_attribute = ["#{action_name}-action"].join(" ")
    id_attribute = (@body_id)? " id=\"#{@body_id}\"" : " id=\"#{controller_name}-controller-#{action_name}-action\"" 

    raw(%Q|<!--[if lt IE 7 ]>
<body class="#{class_attribute} ie6"><![endif]-->
<!--[if gte IE 7 ]>
<body class="#{class_attribute} ie"><![endif]-->
<!--[if !IE]>-->
<body#{id_attribute} class="#{class_attribute}">
<!--<![endif]-->|)

  end

  def google_account_id
    ENV['GOOGLE_ACCOUNT_ID'] || html5_rails_config(:google_account_id)
  end

  def google_api_key
    ENV['GOOGLE_API_KEY'] || html5_rails_config(:google_api_key)
end

  def google_search_uniq_id
    ENV['GOOGLE_SEARCH_UNIQ_ID'] || html5_rails_config(:google_search_uniq_id)
  end

  private

def add_class(name, attrs)
  classes = attrs[:class] || ""
  classes.strip!
  classes = classes + " " if !classes.blank?
  classes = classes + name
  attrs.merge(:class => classes)
end

def html5_rails_config(key)
  configs = YAML.load_file(File.join(::Rails.root, 'config', 'html5_rails.yml'))[::Rails.env.to_sym] rescue {}
  configs[key]
end

end
