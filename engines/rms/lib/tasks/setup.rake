namespace :setup do
  desc "Setup Form for STYFL"
  task styfl: :environment do
    ActiveRecord::Base.transaction do
      Tenant.current = Tenant.where(slug: 'styfl').first
      packet = Rms::FormPacket.new
      packet.name = "STYFL Test (#{Date.today})";
      packet.save
      player = packet.templates.build(name: "Player Information", position: 0)
      player.save

      name = Rms::FormElements::Name.new(template: player, name: 'name', position: 0, required: true)
      name.save

      address = Rms::FormElements::Name.new(template: player, name: 'home_address', position: 1, required: true)
      address.save

      carrier = Rms::FormElements::Text.new(template: player, name: 'insurance_carrier', position: 2, required: true)
      carrier.save

      policy = Rms::FormElements::Text.new(template: player, name: 'insurance_policy', position: 3, required: true)
      policy.save

      comments = Rms::FormElements::Note.new(template: player, name: 'comments', position: 4)
      comments.save

      parent = packet.templates.build(name: "Parent Information", position: 1)
      parent.save

      primary = Rms::FormElements::Contact.new(template: parent, name: 'primary_contact', position: 0, required: true)
      primary.save

      secondary = Rms::FormElements::Contact.new(template: parent, name: 'secondary_contact', position: 1, required: true)
      secondary.save

    end

  end

end
