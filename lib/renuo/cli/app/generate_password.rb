require 'securerandom'

class GeneratePassword
  def run
    say SecureRandom.base64(200).gsub(%r{[\+\/=]}, '')[0...100]
  end
end
