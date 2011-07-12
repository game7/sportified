class   TeamLogoManager
  extend MessageHandler

  on :team_crop_changed do |message|
    team = Team.find(message.data[:team_id])
    team.logo.recreate_versions!
  end

end
