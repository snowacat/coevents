class Admin < ActiveRecord::Base
  has_secure_password
  validates :password, presence: true
  validates :login, presence: true
  before_create { generate_remember_token(:auth_token) }

  def send_password_reset
    generate_remember_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(validate: false)
    AdminMailer.password_reset(self).deliver
  end


  private
    def generate_remember_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while Admin.exists?(column => self[column])
    end
end