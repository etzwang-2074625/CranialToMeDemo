class UserMailer < ApplicationMailer
  include ApplicationHelper
	default from: 'deput-no-reply@uth.tmc.edu'
 
  def test_email
    @content = "This is a test email."
    mailing_list = ["xiaojin.li@uth.tmc.edu", "Christopher.Evert@uth.tmc.edu", "Bao-Jhih.Shao@uth.tmc.edu"]
    mail(to: mailing_list, subject: 'DEPUT Email Testing', bcc: 'shiqiang.tao@uth.tmc.edu')
  end

end

