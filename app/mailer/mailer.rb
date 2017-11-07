class Mailer < ActionMailer::Base
  add_template_helper(ActionMailer::MailHelper)
  append_view_path Rails.root.join('app', 'mailer')
  layout 'mailer'
  default from: 'noreply@volt.com'

  def send_file(email, file_name, file_path)
    attachments[file_name] = File.read(file_path)
    params = {
      to: email,
      subject: 'Report by author'
    }
    mail(params)
  end
end
