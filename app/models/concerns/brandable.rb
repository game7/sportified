require 'active_support/concern'

module Concerns
  module Brandable
    extend ActiveSupport::Concern
    
    included do
      
      mount_uploader :logo, TeamLogoUploader
      
      before_save :get_color_palette, :if => :get_color_palette?
      before_save :resize_logo_images, :if => :crop_changed?
      before_save :clear_crop, :if => :logo_changed?
      
    end
    
    def branded?
      self.logo?
    end
    
    def cropping?
      crop_w > 0 && crop_h > 0
    end

    def crop_changed?
      crop_x_changed? || crop_y_changed? || crop_h_changed? || crop_w_changed?
    end

    def get_color_palette?
      self.logo? && (crop_changed? || logo_changed?)
    end
    
    def clear_crop
      self.crop_x = 0
      self.crop_y = 0
      self.crop_w = 0
      self.crop_h = 0
    end

    def resize_logo_images
      self.logo.recreate_versions! if self.logo.url
    end

    def get_color_palette
      p = self.logo.color_palette
      self.main_colors = p[:colors]
      unless self.custom_colors
        self.primary_color    = p[:primary]
        self.secondary_color  = p[:secondary]
        self.accent_color     = p[:accent]
      end
    end
    
    def replace_branding_from brand
      self.primary_color    = brand.primary_color
      self.secondary_color  = brand.secondary_color
      self.accent_color     = brand.accent_color
      self.main_colors      = brand.main_colors
      self.custom_colors    = brand.custom_colors      
      self.crop_x           = brand.crop_x   
      self.crop_y           = brand.crop_y   
      self.crop_w           = brand.crop_w   
      self.crop_h           = brand.crop_h   
      self.logo             = brand.logo.file
    end
    
  end
end