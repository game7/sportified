class DivisionsController < BaseDivisionController

  def show
    @seasons = @division.seasons

    respond_to do |format|
      format.html
    end
  end

end
