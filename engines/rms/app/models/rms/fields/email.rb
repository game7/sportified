module Rms
  class Fields::Email < Field

    def validate(record)
      super(record)
      record.errors.add(name, "is not an email address") unless
        record.data[name] =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    end
  end
end
