class EncryptionWrapper
  def initialize(attribute1, attribute2)
    @attribute1 = attribute1
    @attribute2 = attribute2
  end

  def before_save(record)
    if record.send("#{@attribute2}").size > 4 
      # Encrypt the new password
      record.send("#{@attribute2}=", encrypt(record.send("#{@attribute1}"), record.send("#{@attribute2}")))
    else
      # Keep the old password
      record.send("#{@attribute2}=", record.send("#{@attribute2}_was"))
    end
  end

  def encrypted_string
    encrypt(@attribute1, @attribute2)
  end

  private

  def encrypt(salt, value)
    e = Encode.new(salt)
    e.encrypt value
  end

end
