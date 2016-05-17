class Encode
  # Salt prevents two different users with the same password from having the same encrypted string
  def initialize(salt)
    @salt= salt
  end

  def encrypt(text)
     Digest::SHA1.hexdigest("#{@salt}#{text}")
  end
end
