class SignupsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new :username => params[:username], :password => params[:password], :password_confirmation => params[:password_confirmation], :user_groups => [ UserGroup.find_by_name('Users') ]
    if @user.save && !params[:full_name].blank? && !params[:description].blank?
      AdminMailer.deliver_new_account_instructions(params[:full_name], params[:username], params[:description])
      flash[:notice] = I18n.t('flash.signup.create.notice')
      redirect_to login_path
    else
      @user.errors.add_to_base I18n.t('activerecord.attributes.other.full_name') + I18n.t('activerecord.errors.format.separator', :default => ' ') + I18n.t('activerecord.errors.messages.empty') if params[:full_name].blank?
      @user.errors.add_to_base I18n.t('activerecord.attributes.other.description') + I18n.t('activerecord.errors.format.separator', :default => ' ') + I18n.t('activerecord.errors.messages.empty') if params[:description].blank?
      render :action => :new
    end
  end

end
