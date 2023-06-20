class Next::Admin::Forms::FormPacketsController < Next::Admin::BaseController
  def show
    packet = FormPacket.find(params[:id])

    inertia props: {
      packet: packet,
      templates: packet.templates
    }
  end
end
