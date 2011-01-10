require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe DivisionsController do

  def mock_division(stubs={})
    @mock_division ||= mock_model(Division, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all divisions as @divisions" do
      Division.stub(:all) { [mock_division] }
      get :index
      assigns(:divisions).should eq([mock_division])
    end
  end

  describe "GET show" do
    it "assigns the requested division as @division" do
      Division.stub(:find).with("37") { mock_division }
      get :show, :id => "37"
      assigns(:division).should be(mock_division)
    end
  end

  describe "GET new" do
    it "assigns a new division as @division" do
      Division.stub(:new) { mock_division }
      get :new
      assigns(:division).should be(mock_division)
    end
  end

  describe "GET edit" do
    it "assigns the requested division as @division" do
      Division.stub(:find).with("37") { mock_division }
      get :edit, :id => "37"
      assigns(:division).should be(mock_division)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created division as @division" do
        Division.stub(:new).with({'these' => 'params'}) { mock_division(:save => true) }
        post :create, :division => {'these' => 'params'}
        assigns(:division).should be(mock_division)
      end

      it "redirects to the created division" do
        Division.stub(:new) { mock_division(:save => true) }
        post :create, :division => {}
        response.should redirect_to(division_url(mock_division))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved division as @division" do
        Division.stub(:new).with({'these' => 'params'}) { mock_division(:save => false) }
        post :create, :division => {'these' => 'params'}
        assigns(:division).should be(mock_division)
      end

      it "re-renders the 'new' template" do
        Division.stub(:new) { mock_division(:save => false) }
        post :create, :division => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested division" do
        Division.stub(:find).with("37") { mock_division }
        mock_division.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :division => {'these' => 'params'}
      end

      it "assigns the requested division as @division" do
        Division.stub(:find) { mock_division(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:division).should be(mock_division)
      end

      it "redirects to the division" do
        Division.stub(:find) { mock_division(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(division_url(mock_division))
      end
    end

    describe "with invalid params" do
      it "assigns the division as @division" do
        Division.stub(:find) { mock_division(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:division).should be(mock_division)
      end

      it "re-renders the 'edit' template" do
        Division.stub(:find) { mock_division(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested division" do
      Division.stub(:find).with("37") { mock_division }
      mock_division.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the divisions list" do
      Division.stub(:find) { mock_division }
      delete :destroy, :id => "1"
      response.should redirect_to(divisions_url)
    end
  end

end
