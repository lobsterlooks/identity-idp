require 'rails_helper'

feature 'webauthn sign up' do
  include WebAuthnHelper

  let!(:user) { sign_up_and_set_password }

  def visit_webauthn_setup
    # webauthn option is hidden in browsers that don't support it
    select_2fa_option('webauthn', visible: :all)
  end

  def expect_webauthn_setup_success
    expect(page).to have_content(t('notices.webauthn_configured'))
    expect(page).to have_current_path(account_path)
  end

  def expect_webauthn_setup_error
    expect(page).to have_content t('errors.webauthn_setup.general_error')
    expect(page).to have_current_path(two_factor_options_path)
  end

  it_behaves_like 'webauthn setup'
end
