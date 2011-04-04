class UserRole
  include Mongoid::Document
 
  embedded_in :user
  field :name
  field :title
  field :site_id
  field :subject_id

  scope :find_by_name, lambda { |name| { :where => { :name => name.to_s } } }

  class << self
    def for_site(s)
      id = s.class == Site ? s.id : s
      where(:site_id => id)
    end      
    def super_admin
      UserRole.new(:name => "super_admin", :title => "Super Admin")
    end
    def site_admin(site)
      UserRole.new(:name => "site_admin", :title => "Site Admin", :site_id => site.id)
    end
  end

end
