require 'rails_helper'

feature 'webauthn sign up' do
  include WebAuthnHelper

  let!(:user) { sign_up_and_set_password }

  before do
    allow(FeatureManagement).to receive(:prefill_otp_codes?).and_return(true)
  end

  context 'as first MFA method' do
    def visit_webauthn_setup
      select_2fa_option('webauthn')
    end

    def expect_webauthn_setup_success
      expect(page).to have_current_path(two_factor_options_path)

      select_2fa_option('sms')
      fill_in :user_phone_form_phone, with: '2025551313'
      click_send_security_code
      click_submit_default

      expect(page).to have_current_path(account_path)
    end

    it_behaves_like 'webauthn setup'
  end

  context 'as second MFA method' do
    def visit_webauthn_setup
      select_2fa_option('sms')
      fill_in :user_phone_form_phone, with: '2025551313'
      click_send_security_code
      click_submit_default

      select_2fa_option('webauthn')
    end

    def expect_webauthn_setup_success
      expect(page).to have_current_path(account_path)
    end

    it_behaves_like 'webauthn setup'
  end

  def expect_webauthn_setup_error
    expect(page).to have_content t('errors.webauthn_setup.general_error')
    expect(page).to have_current_path(two_factor_options_path)
  end
end
