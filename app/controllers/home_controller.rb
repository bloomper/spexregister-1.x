class HomeController < BaseController
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper

  skip_before_filter :require_login, :only => [:login, :signup, :show_signup, :hide_signup]
  skip_before_filter :update_activity_time, :only => [:login, :signup, :show_signup, :hide_signup, :session_expiry]

  def index
    if get_user_from_session.temporary_password?
      flash[:message] = 'Eftersom detta är första gången du loggar in så måste du byta ditt tillfälliga lösenord.'
      redirect_to :action => :change_my_password
    end
    @news_items = NewsItem.find(:all, :page => {:size => get_configuration_item(ConfigurationItem::DEFAULT_LISTING_PAGE_SIZE).to_i, :current => params[:page]}, :order => 'publication_date', :select => 'news_items.id, news_items.publication_date, news_items.subject, news_items.body')
  end

  def login
    if request.post?
      if user_item = UserItem.authenticate(params[:user_name], params[:user_password])
        if user_item.disabled?
          flash[:error] = "Användaren är deaktiverad och kan inte logga in. Kontakta #{auto_link(get_configuration_item(ConfigurationItem::ADMIN_MAIL_ADDRESS))} för mer information."
        else
          session[:user_item_id] = user_item.id
          redirect_to :action => :index
        end
      else
        flash[:error] = 'Felaktigt användarnamn och/eller lösenord.'
      end
    end
  end

  def logout
    session[:user_item_id] = nil
    flash[:message] = 'Du har blivit utloggad.'
    redirect_to :action => :login
  end

  def show_signup
    if request.xhr?
      render :update do |page|
        page.replace_html 'signupDialog', :partial => 'signup'
        page << "Form.disable('loginForm')";
        page.visual_effect :appear, 'signupDialog'
      end
    end
  end

  def hide_signup
    if request.xhr?
      render :update do |page|
        page << "Form.enable('loginForm')";
        page.visual_effect :fade, 'signupDialog'
      end
    end
  end

  def signup
    begin
      Mailer.deliver_signup(params[:new_account_email_address], params[:new_account_name], params[:new_account_user_name], params[:new_account_description], get_configuration_item(ConfigurationItem::ADMIN_MAIL_ADDRESS))
    rescue Exception
      logger.error("Could not deliver mail due to #{$!.to_s}")
      render :partial => 'shared/ajax_error', :locals => { :error => "Kunde inte skicka meddelandet. Var god försök senare eller skicka ett mail till #{auto_link(get_configuration_item(ConfigurationItem::ADMIN_MAIL_ADDRESS))} med motsvarande information." }
    else
      render :partial => 'shared/ajax_message', :locals => { :message => 'Meddelandet har skickats.' }
    end 
  end

  def show_news_item
    begin
      @news_item = NewsItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempted to access invalid news item #{params[:id]}")
      render :partial => 'shared/ajax_error', :locals => { :error => 'Ogiltlig nyhet.' }
    else
      render :update do |page|
        page.visual_effect :fade,  'newsItemListDialog'
        page.replace_html 'latestNewsDialog', :partial => 'show_news_item'
        page.visual_effect :appear, 'latestNewsDialog'
      end
    end
  end

  def change_my_password
    if request.post?
      begin
        @user_item = UserItem.find(get_user_id_from_session)
      rescue ActiveRecord::RecordNotFound
        # Impossible to get here though as the login filter catches it first
        logger.error("Attempted to access invalid user item #{get_user_id_from_session}")
        redirect_to_index('Ogiltlig användare.', true)
      else
        if @user_item.update_attributes(params[:user_item])
          @user_item.update_attribute(:temporary_password, false)
          redirect_to_index('Lösenordet är uppdaterat.')
        else
          @user_item.user_password = nil
          @user_item.user_password_confirmation = nil
          @item = @user_item
          render :action => :change_my_password
        end
      end
    end
  end

  def change_my_profile
    if !get_user_from_session.spexare_item.nil?
      redirect_to :controller => '/browse', :action => :edit, :id => get_user_from_session.spexare_item.id
    else
      redirect_to_index('Du är ej associerad med någon spexare.', true)
    end
  end

end
