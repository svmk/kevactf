class Registration < ActionMailer::Base
  default :from => "svmk-tmsk@yandex.ru" #"ctf@keva.su"
  def activated_mail(user,hostname)
    if user then
      @hostname = hostname
      @user = user
      mail(:to=>user.email,:subject=>'KEVA CTF Account is successfully activated')
    end
  end
  def registration_mail(user,hostname)
    if user then
      @hostname = hostname
      @user = user
      mail(:to=>user.email,:subject=>'KEVA CTF Registration')
    end
  end
  def password_mail(user,hostname)
    if user then
      @hostname = hostname
      @user = user
      mail(:to=>user.email,:subject=>'KEVA CTF Password')
    end
  end
end
