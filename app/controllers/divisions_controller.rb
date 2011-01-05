class DivisionsController < ApplicationController
  # GET /divisions
  # GET /divisions.xml
  def index
    @divisions = Division.asc(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @divisions }
    end
  end

  # GET /divisions/1
  # GET /divisions/1.xml
  def show
    @division = Division.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @division }
    end
  end

  # GET /divisions/new
  # GET /divisions/new.xml
  def new
    @division = Division.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @division }
    end
  end

  # GET /divisions/1/edit
  def edit
    @division = Division.find(params[:id])
  end

  # POST /divisions
  # POST /divisions.xml
  def create
    @division = Division.new(params[:division])

    respond_to do |format|
      if @division.save
        format.html { redirect_to(divisions_path, :notice => 'Division was successfully created.') }
        format.xml  { render :xml => @division, :status => :created, :location => @division }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @division.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /divisions/1
  # PUT /divisions/1.xml
  def update
    @division = Division.find(params[:id])

    respond_to do |format|
      if @division.update_attributes(params[:division])
        format.html { redirect_to(divisions_path, :notice => 'Division was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @division.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /divisions/1
  # DELETE /divisions/1.xml
  def destroy
    @division = Division.find(params[:id])
    @division.destroy

    respond_to do |format|
      format.html { redirect_to(divisions_url) }
      format.xml  { head :ok }
    end
  end
end
