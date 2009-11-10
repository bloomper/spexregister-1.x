class AccountsController < ApplicationController
  before_filter :setup_negative_captcha, :only => [:new, :create]
  
  def new
    @user = User.new
  end
  
  def create
    if @captcha.valid?
      @user = User.new :username => @captcha.values[:username], :password => @captcha.values[:password], :password_confirmation => @captcha.values[:password_confirmation], :user_groups => [ UserGroup.find_by_name('Users') ]
      @user.save
      if @user.errors.size == 1 && !@user.errors.on(:spexare).nil? && !@captcha.values[:full_name].blank? && !@captcha.values[:description].blank?
        AdminMailer.deliver_new_account_instructions(@captcha.values[:full_name], @captcha.values[:username], @captcha.values[:description])
        flash[:notice] = I18n.t('flash.accounts.create.notice')
        redirect_to login_path
      else
        @user.errors.add_to_base I18n.t('activerecord.attributes.other.full_name') + I18n.t('activerecord.errors.format.separator', :default => ' ') + I18n.t('activerecord.errors.messages.empty') if @captcha.values[:full_name].blank?
        @user.errors.add_to_base I18n.t('activerecord.attributes.other.description') + I18n.t('activerecord.errors.format.separator', :default => ' ') + I18n.t('activerecord.errors.messages.empty') if @captcha.values[:description].blank?
        render :action => :new
      end
    else
      flash[:error] = I18n.t('flash.accounts.create.error') 
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      flash[:notice] = I18n.t('flash.accounts.update.error')
      render :action => :edit
    else
      @user.update_attributes(params[:user])
      if @user.errors.size == 1 && !@user.errors.on(:spexare).nil?
        @user.save(false)
        flash[:notice] = I18n.t('flash.accounts.update.notice')
        redirect_to home_path
      else
        flash[:notice] = I18n.t('flash.accounts.update.error')
        render :action => :edit
      end
    end
  end

  private
  def setup_negative_captcha
    @captcha = NegativeCaptcha.new(
          :secret => NEGATIVE_CAPTCHA_SECRET,
          :spinner => request.remote_ip, 
          :fields => [:full_name, :username, :password, :password_confirmation, :description], 
          :params => params)
  end
  
end