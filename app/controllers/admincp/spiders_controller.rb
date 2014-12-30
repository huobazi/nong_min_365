# -*- encoding : utf-8 -*-
class Admincp::SpidersController < Admincp::ApplicationController

  def nx28
    Nx28SpiderWorker.perform_async
    redirect_to admincp_root_url, notice: "Nx28Spider running..."
  end

end
