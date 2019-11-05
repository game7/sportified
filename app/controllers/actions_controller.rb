class ActionsController < ApplicationController

  def create
    action = params[:type].classify.constantize
    payload = params[:payload]
    begin
      # render json: camelize(action.call(payload).as_json), adapter: :json
      render json: action.call(payload), adapter: :json
    rescue ActiveRecord::RecordInvalid => invalid
      render json: invalid.record.errors, status: :bad_request
    end
  end

  protected

  def camelize(result)
    case result
    when Array
      result.map{|item| camelize(item) }
    when Hash
      result.deep_transform_keys!{|k| k.to_s.camelize(:lower)}
    else
      result.respond_to?(:attributes) ? camelize(result.attributes) : result
    end
  end

end
