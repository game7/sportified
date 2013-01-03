class SectionObserver < Mongoid::Observer
  
  def after_destroy(section)
    section.page.blocks.destroy_all(conditions: { section_id: section.id })
  end
  
end
