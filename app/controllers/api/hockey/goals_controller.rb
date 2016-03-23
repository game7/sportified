class Api::Hockey::GoalsController < ApplicationController
  include Sportified::ErrorSerializer
  respond_to :json

  def create
    goal = ::Hockey::Goal.create(goal_params)
    if goal.valid?
      render json: goal, status: :ok
    else
      render json: Sportified::ErrorSerializer.serialize(goal.errors), status: :unprocessable_entity
    end
  end

  def update
    goal = ::Hockey::Goal.find(params[:id])
    if goal.update_attributes(goal_params)
      render json: goal, status: :ok
    else
      render json: Sportified::ErrorSerializer.serialize(goal.errors), status: :unprocessable_entity
    end
  end

  private

  def goal_params
    ActiveModel::Serializer::Adapter::JsonApi::Deserialization.parse!(params.to_unsafe_h)
  end

end
