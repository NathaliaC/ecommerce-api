# frozen_string_literal: true

module Devise
  class MailerPreview < ActionMailer::Preview
    def reset_password_instructions
      Devise::Mailer.reset_password_instructions(User.first, {})
    end
  end
end
