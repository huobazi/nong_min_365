# -*- encoding : utf-8 -*-
module Admincp::AdmincpHelper

  def add_errors_to_flash_now  
    model_name = controller_name.singularize 
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

end
