class Layout
  include Mongoid::Document

  before_create :generate_panels

  FORMATS = %w[100 
              25|75 40|60 50|50 60|40 75|25
              25|50|25 33|34|33 
              25|25|25|25
              60:100-50-50|40 40|60:100-50-50]

  field :format
  field :position, :type => Integer

  embedded_in :page
  embeds_many :panels

  class << self
    def formats
      FORMATS
    end
    def prototypes
      proto = []
      formats.each do |f|
        layout = Layout.new(:format => f)
        layout.generate_panels
        proto << layout
      end
      proto
    end
    def default
      Layout.new(:format => '100')
    end
  end

  def panel_ids
    panels.collect{|p| [p.id] << p.children.collect{ |c| c.id } }.flatten
  end

  def generate_panels
    self.format.split("|").each do |p|
      inner = p.split(":")
      parent = self.panels.build(:width => inner[0], :depth => 1)
      if inner.count > 1
        inner[1].split("-").each do |sub|
          parent.children.build(:width => sub, :depth => 2)
        end
      end
    end    
  end

end
