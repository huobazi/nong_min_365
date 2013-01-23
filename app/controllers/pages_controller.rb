# -*- encoding : utf-8 -*-
class PagesController < HighVoltage::PagesController

  caches_page :show
  layout :layout_for_page

  protected
  def layout_for_page
    case params[:id]
    when 'about'
      'static'
    else
      'static'
    end
  end
end
