class SandboxEmailInterceptor
  def self.delivering_email(message)
    message.to = ['Bao-Jhih.Shao@uth.tmc.edu']
  end
end

Rails.application.configure do
  if !Rails.env.production?
    config.action_mailer.interceptors = %w[SandboxEmailInterceptor]
  end
end
