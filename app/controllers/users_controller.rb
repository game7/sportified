# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  mongo_id               :string
#  created_at             :datetime
#  updated_at             :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  first_name             :string
#  last_name              :string
#

class UsersController < ApplicationController

  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    team_ids = Player.where(email: @user.email).collect{|p| p.team_id}
    @games = League::Game.in_the_future
                        .where('home_team_id IN (?) OR away_team_id IN (?)', team_ids, team_ids)
                        .order(:starts_on)
                        .includes(:location, :home_team, :away_team)
  end

end
