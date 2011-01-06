class SeasonsController < ApplicationController
  # GET /seasons
  # GET /seasons.xml
  def index
    @division = Division.find(params[:division_id])
    @seasons = @division.seasons

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @seasons }
    end
  end

  # GET /seasons/1
  # GET /seasons/1.xml
  def show
    @season = Season.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @season }
    end
  end

  # GET /seasons/new
  # GET /seasons/new.xml
  def new
    @division = Division.find(params[:division_id])
    @season = @division.seasons.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @season }
    end
  end

  # GET /seasons/1/edit
  def edit
    @season = Season.find(params[:id])
  end

  # POST /seasons
  # POST /seasons.xml
  def create
    @division = Division.find(params[:division_id])
    @season = @division.seasons.build(params[:season])

    respond_to do |format|
      if @season.save
        format.html { redirect_to(@division, :notice => 'Season was successfully created.') }
        format.xml  { render :xml => @season, :status => :created, :location => @season }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @season.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /seasons/1
  # PUT /seasons/1.xml
  def update
    @season = Season.find(params[:id])

    respond_to do |format|
      if @season.update_attributes(params[:season])
        format.html { redirect_to(@season, :notice => 'Season was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @season.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /seasons/1
  # DELETE /seasons/1.xml
  def destroy
    @season = Season.find(params[:id])
    @division = @season.division
    @season.destroy

    respond_to do |format|
      format.html { redirect_to(@division) }
      format.xml  { head :ok }
    end
  end
end
