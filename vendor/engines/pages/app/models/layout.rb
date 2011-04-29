class Layout
  include Mongoid::Document

  FORMATS = %w[100 
              25|75 40|60 50|50 60|40 75|25
              25|50|25 33|34|33 
              25|25|25|25
              60:100-50-50|40 40|60:100-50-50]

  field :format
  field :position, :type => Integer

  embedded_in :page

  class << self
    def formats
      FORMATS
    end
  end

  def get_columns
    cols = []
    self.format.split("|").each do |c|
      col = c.split(":")
      col_hash = {:width => col[0], :level => 1}
      if col.count > 1
        col_hash[:columns] = col[1].split("-").collect{|x| {:width => x, :level => 2} } if col.count > 1
      end
      cols << col_hash
    end
    cols    
  end

end
