class Spree::UserPasswordsController < Devise::PasswordsController
  include SslRequirement
  helper 'spree/users', 'spree/base'

  if defined?(Spree::Dash)
    helper 'spree/analytics'
  end

  include Spree::Core::ControllerHelpers

  ssl_required

  # Overridden due to bug in Devise.
  #   respond_with resource, :location => new_session_path(resource_name)
  # is generating bad url /session/new.user
  #
  # overridden to:
  #   respond_with resource, :location => spree.login_path
  #
  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])

    if resource.errors.empty?
      set_flash_message(:notice, :send_instructions) if is_navigational_format?
      respond_with resource, :location => spree.login_path
    else
      flash[:error] = 'Account not found.'
      respond_with_navigational(resource) { render :new }
    end
  end

  # Devise::PasswordsController allows for blank passwords.
  # Silly Devise::PasswordsController!
  # Fixes spree/spree#2190.
  def update
    if params[:user][:password].blank?
      set_flash_message(:error, :cannot_be_blank)
      render :edit
    else
      user = Spree::User.find_by_reset_password_token(params[:user][:reset_password_token])
      user.password = params[:user][:password]
      user.password_confirmation = params[:user][:password_confirmation]
      user.save
      redirect_to main_app.root_path
    end
  end

end
