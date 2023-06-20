class Next::Admin::FormsController < Next::Admin::BaseController
  def index
    inertia props: {
      packets: FormPacket.all
    }
  end
end
