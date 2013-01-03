namespace :pages do
  desc "moves any orphaned page blocks into a new page section"
  task :place_orphan_blocks_into_sections => :environment do
    Tenant.all.each do |tenant|
      Tenant.current = tenant
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "TENANT = #{tenant.host}"
      Page.all.each do |page|
        puts ""
        puts "NEXT Page..."
        puts "- Path: "+page.path
        blocks = page.blocks
        puts "- Blocks: "+blocks.count.to_s
        puts "- Sections: "+page.sections.count.to_s
        blocks.each_with_index do |block, i|
          section = block.section_id ? page.sections.where(:id => block.section_id) : nil
          puts "-- block #{i}: OK" if section
          unless section
            puts "-- block #{i}: New Section"
            new_section ||= page.sections.new({:pattern => "100"})
            block.section_id = new_section.id
            block.column = 0
          end
        end
        page.save
        puts "- PAGE SAVED!"
        puts "- Sections: "+page.sections.count.to_s
        puts "DONE"
      end
    end
  end
  
end