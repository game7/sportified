#https://gist.github.com/824652
Autotest.add_hook(:initialize) do |at|
  
  # models
  at.add_mapping(%r%^vendor/engines/.*/spec/(models|controllers|routing|views|helpers|mailers|lib)/.*rb$%) { |filename, _|
    filename
  }
  # views
  at.add_mapping(%r%^vendor/engines/(.*)/app/models/(.*)\.rb$%) { |_, m|
    ["vendor/engines/#{m[1]}/spec/models/#{m[2]}_spec.rb"]
  }
  at.add_mapping(%r%^vendor/engines/(.*)/app/views/(.*)$%) { |_, m|
    at.files_matching %r%^vendor/engines/#{m[1]}/spec/models/#{m[2]}_spec\.rb$%
  }
  # controllers
  at.add_mapping(%r%^vendor/engines/(.*)/app/controllers/(.*)\.rb$%) { |_, m|
    if m[2] == "application"
      at.files_matching %r%^vendor/engines/#{m[1]}/spec/controllers/.*_spec\.rb$%
    else
      ["vendor/engines/#{m[1]}/spec/controllers/#{m[2]}_spec.rb"]
    end
  }
  # helpers
  at.add_mapping(%r%^vendor/engines/(.*)/app/helpers/(.*)_helper\.rb$%) { |_, m|
    if m[2] == "application"
      at.files_matching %r%^vendor/engines/#{m[1]}/spec/(views|helpers)/.*_spec\.rb$%
    else
      ["vendor/engines/#{m[1]}/spec/helpers/#{m[2]}_helpers_spec.rb"]
    end
  }
  # routes
  at.add_mapping(%r%^vendor/engines/(.*)/config/routes\.rb$%) { |_, m|
    at.files_matching %r%^vendor/engines/#{m[1]}/spec/(conrollers|routing|views|helpers)/.*_spec\.rb$%
  }
  # lib
  at.add_mapping(%r%^vendor/engines/(.*)/lib/(.*)\.rb$%) { |_, m|
    ["vendor/engines/#{m[1]}/spec/lib/#{m[2]}_spec.rb"]
  }

end
