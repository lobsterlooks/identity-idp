module TwoFactorAuthCode
  class GenericDeliveryPresenter
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::TranslationHelper
    include Rails.application.routes.url_helpers

    attr_reader :phone_number, :code_value, :delivery_method, :reenter_phone_number_path,
                :totp_enabled, :unconfirmed_phone, :recovery_code_unavailable, :user_email, :view

    def initialize(data_model, view = nil)
      data_model.each do |key, value|
        instance_variable_set("@#{key}", value)
      end

      @view = view
    end

    def header
      raise NotImplementedError
    end

    def help_text
      raise NotImplementedError
    end

    def fallback_links
      raise NotImplementedError
    end

    def recovery_code_link
      return if recovery_code_unavailable

      t("#{recovery_code_key}.text_html",
        link: recovery_code_tag)
    end

    private

    def recovery_code_tag
      link_to(t("#{recovery_code_key}.link"), login_two_factor_recovery_code_path)
    end

    def link_to(text, url, options = {})
      href = { href: url }
      content_tag(:a, text, options.merge(href))
    end

    def recovery_code_key
      'devise.two_factor_authentication.recovery_code_fallback'
    end
  end
end
