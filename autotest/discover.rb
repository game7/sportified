Autotest.add_hook(:initialize) do |at|
  
  at.add_mapping(%r%^pages/spec/(models|controllers|routing|views|helpers|mailers|lib)/.*rb$%) { |filename, _|
    filename
  }
  at.add_mapping(%r%^pages/app/models/(.*)\.rb$%) { |_, m|
    ["pages/spec/models/#{m[1]}_spec.rb"]
  }

end
