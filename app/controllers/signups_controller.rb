class SignupsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new :username => params[:username], :password => params[:password], :password_confirmation => params[:password_confirmation], :user_groups => [ UserGroup.find_by_name('Users') ]
    if @user.save && !params[:full_name].blank? && !params[:description].blank?
      AdminMailer.deliver_new_account_instructions(params[:full_name], params[:username], params[:description])
      flash[:notice] = I18n.t('views.signup.successful_creation')
      redirect_to login_path
    else
      @user.errors.add_to_base I18n.t('views.signup.missing_full_name') if params[:full_name].blank?
      @user.errors.add_to_base I18n.t('views.signup.missing_description') if params[:description].blank?
      render :action => :new
    end
  end

end
