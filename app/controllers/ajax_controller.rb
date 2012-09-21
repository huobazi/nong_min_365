# -*- encoding : utf-8 -*-
class AjaxController < ApplicationController
  def regions

    #begin
    #rescue Exception => e
      #puts e.message
      #puts e.backtrace.inspect
    #else
       #other exception
    #ensure
       #always executed
    #end

    ary = ['nil', '0000000000', '00000000', '000000', '000']
    code = params[:code]
    @parent_id = params[:parent_id]
    @parent_css = params[:css]
    if code.end_with? ary[1] 
      level = 1
      code_prefix = code.chomp(ary[1])
      @children_level = level + 1
    elsif code.end_with? ary[2] 
      level = 2 
      code_prefix = code.chomp(ary[2])
      @children_level = level + 1
    elsif code.end_with? ary[3] 
      level = 3
      code_prefix = code.chomp(ary[3])
      @children_level = level + 1
    elsif code.end_with? ary[4]
      level = 4
      code_prefix = code.chomp(ary[4])
      @children_level = level + 1
    else
      level = 5
      code_prefix = code.chomp(ary[5])
      @children_level = level + 1
    end
    code_like = "#{code_prefix}%"

    if level <= 5
      @regions = ChineseRegion.select('code, name').where("level = :level and code like :code_like", {:level => @children_level, :code_like => code_like} )
    end

    respond_to do |format|
      format.js { render :layout => false }
    end

  end  
end
