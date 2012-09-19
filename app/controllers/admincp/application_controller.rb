# -*- encoding : utf-8 -*-
class Admincp::ApplicationController < ApplicationController
  include Admincp::AdmincpHelper
  layout "admincp"
  before_filter :require_login
  before_filter :require_admin

end

