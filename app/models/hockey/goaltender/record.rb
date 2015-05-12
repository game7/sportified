class Hockey::Goaltender::Record < Hockey::Goaltender
  has_one :team, through: :player
end
