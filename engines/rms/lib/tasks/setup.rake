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

      terms = <<-TERMS
      WAIVER AND RELEASE OF LIABILITY AND ASSUMPTION OF RISK AGREEMENT

      I/We the parents of the STYFL Football player hereby give my/our approval to his/her participation in any and all activities associated with STYFL. I/We assume all risks and hazards incidental to such participation including transportation to and from the activities; and I/we hereby waive, release, absolve, indemnify and agree to hold harmless STYFL Football, the organizers, sponsors, supervisors, participants, coaches and any persons transporting my/our son/daughter. I acknowledge that I understand that participation in this program involves risk of serious injury and that while rules and protective equipment may reduce that risk, there is no way to eliminate the risk of serious injury. I acknowledge that if my child participates in a division consisting of older and/or heavier players; it is done by my sole direction and I assume any and all additional risks that such participation involves. Be it known that I/we, the parent or guardian of the player, do hereby give and grant unto any medical assistant, medical doctor or hospital my consent and authorization to render such aid, treatment or care to said player as in judgment of said medical assistant, doctor or hospital that may be required on an emergency basis in the event said player should be injured or stricken ill while participating in STYFL Football activities. I/We do hereby grant my/our permission to have said player photographed at league games and/or functions and release all rights to said photographs and authorize their use by STYFL Football and it’s affiliates for promotional purposes. I further accept full responsibility for all obligations, financial or other, which may result from injuries to my son/daughter while participating in the STYFL Football program. I also understand that STYFL Football does not provide accident insurance for my son/daughter. This waiver applies to myself, as well my heirs, devisees, assigns, personal representatives, guardians, conservators, administrators, agents, next of kin, and successors-in-interest.
      TERMS
      
      agreement = Rms::FormElements::Agreement.new(template: parent, name: 'terms_and_conditions', position: 2, required: true, terms: terms)
      agreement.save
    end

  end

end
