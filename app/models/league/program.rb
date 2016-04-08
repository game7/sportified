class League::Program < Program
  has_many :seasons, class_name: '::Season'
  has_many :divisions, class_name: '::Division'
end
