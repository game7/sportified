Autotest.add_hook(:initialize) do |at|
  
  at.add_mapping(%r%^vendor/engines/.*/spec/(models|controllers|routing|views|helpers|mailers|lib)/.*rb$%) { |filename, _|
    filename
  }
  at.add_mapping(%r%^vendor/engines/(.*)/app/models/(.*)\.rb$%) { |_, m|
    ["vendor/engines/#{m[1]}/spec/models/#{m[2]}_spec.rb"]
  }

end
