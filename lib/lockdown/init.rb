Lockdown::System.configure do

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Configuration Options
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Options with defaults:
  #
  #
  # Set User model:
  #      # make sure you use the string "User", not the constant
  #      options[:user_model] = "User"
  #
  # Set UserGroup model:
  #      # make sure you use the string "UserGroup", not the constant
  #      options[:user_group_model] = "UserGroup"
  #
  # Set who_did_it method:
  #   This method is used in setting the created_by/updated_by fields and
  #   should be accessible to the controller
  #      options[:who_did_it] = :current_user_id
  #
  # Set default_who_did_it:
  #   When current_user_id returns nil, this is the value to use
  #      options[:default_who_did_it] = 1
  #
  #   Lockdown version < 0.9.0 set this to:
  #       options[:default_who_did_it] = Profile::System
  #
  #   Should probably be something like:
  #      options[:default_who_did_it] = User::SystemId
  #
  # Set timeout to 1 hour:
  #       options[:session_timeout] = (60 * 60)
  #
  # Call method when timeout occurs (method must be callable by controller):
  #       options[:session_timeout_method] = :clear_session_values
  #
  # Set system to logout if unauthorized access is attempted:
  #       options[:logout_on_access_violation] = false
  #
  # Set redirect to path on unauthorized access attempt:
  #       options[:access_denied_path] = "/"
  #
  # Set redirect to path on successful login:
  #       options[:successful_login_path] = "/"
  #
  # Set separator on links call
  #       options[:links_separator] = "|"
  #
  # If deploying to a subdirectory, set that here. Defaults to nil
  #       options[:subdirectory] = "blog"
  #       *Notice: Do not add leading or trailing slashes,
  #                Lockdown will handle this
  #
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Define permissions
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #
  # set_permission(:product_management).
  #   with_controller(:products)
  #
  # :product_management is the name of the permission which is later
  # referenced by the set_user_group method
  #
  # .with_controller(:products) defaults to all action_methods available on that
  #  controller.  You can change this behaviour by chaining on except_methods or
  #  only_methods.  (see examples below)
  #
  #  ** To define a namespaced controller use two underscores:
  #     :admin__products
  #
  # if products is your standard RESTful resource you'll get:
  #   ["products/index , "products/show",
  #    "products/new", "products/edit",
  #    "products/create", "products/update",
  #    "products/destroy"]
  #
  # You can chain method calls to restrict the methods for one controller
  # or you can add multiple controllers to one permission.
  #      
  #   set_permission(:security_management).
  #     with_controller(:users).
  #     and_controller(:user_groups).
  #     and_controller(:permissions) 
  #
  # In addition to with_controller(:controller) there are:
  #
  #   set_permission(:some_nice_permission_name).
  #     with_controller(:some_controller_name).
  #       only_methods(:only_method_1, :only_method_2)
  #
  #   set_permission(:some_nice_permission_name).
  #     with_controller(:some_controller_name).
  #       except_methods(:except_method_1, :except_method_2)
  #
  #   set_permission(:some_nice_permission_name).
  #     with_controller(:some_controller_name).
  #       except_methods(:except_method_1, :except_method_2).
  #     and_controller(:another_controller_name).
  #     and_controller(:yet_another_controller_name)
  #
  # Define your permissions here:

set_permission(:login).with_controller(:user_sessions)
set_permission(:signups).with_controller(:signups)
set_permission(:password_resets).with_controller(:password_resets)
set_permission(:home).with_controller(:home)
set_permission(:search).with_controller(:search)
set_permission(:administration).with_controller(:administration)
set_permission(:help).with_controller(:help)
set_permission(:locale).with_controller(:locale)
set_permission(:spex_management).with_controller(:spex)
set_permission(:spex_view).with_controller(:spex).only_methods(:show)
set_permission(:function_management).with_controller(:functions)
set_permission(:function_view).with_controller(:functions).only_methods(:show)
set_permission(:news_management).with_controller(:news).except_methods(:show, :index)
set_permission(:news_view).with_controller(:news).only_methods(:show, :index)
set_permission(:user_management).with_controller(:users).and_controller(:user_groups).and_controller(:permissions).and_controller(:spexare)
set_permission(:user_management_owner).with_controller(:users).and_controller(:user_groups).and_controller(:permissions).and_controller(:spexare).to_model(:user).where(:editable_by).includes(:current_user_id)
set_permission(:spexare_management).with_controller(:spexare).and_controller(:cohabitants).and_controller(:memberships).and_controller(:activities).and_controller(:spex_activities).and_controller(:function_activities).and_controller(:actors).and_controller(:users).except_methods(:show, :index)
set_permission(:spexare_management_owner).with_controller(:spexare).and_controller(:cohabitants).and_controller(:memberships).and_controller(:activities).and_controller(:spex_activities).and_controller(:function_activities).and_controller(:actors).and_controller(:users).except_methods(:show, :index).to_model(:spexare).where(:editable_by).includes(:current_user_id)
set_permission(:spexare_view).with_controller(:spexare).and_controller(:cohabitants).and_controller(:memberships).and_controller(:activities).and_controller(:spex_activities).and_controller(:function_activities).and_controller(:actors).only_methods(:show, :index)

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Built-in user groups
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #  You can assign the above permission to one of the built-in user groups
  #  by using the following:
  # 
  #  To allow public access on the permissions :sessions and :home:
  #    set_public_access :sessions, :home
  #     
  #  Restrict :my_account access to only authenticated users:
  #    set_protected_access :my_account
  #
  # Define the built-in user groups here:

set_public_access :login, :locale, :signups, :password_resets
set_protected_access :home, :search, :help

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Define user groups
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #
  #  set_user_group(:catalog_management, :category_management, 
  #                                      :product_management) 
  #
  #  :catalog_management is the name of the user group
  #  :category_management and :product_management refer to permission names
  #
  # 
  # Define your user groups here:

set_user_group(:administrators, :administration, :spexare_management, :user_management, :spex_management, :function_management, :news_management)
set_user_group(:users, :spexare_management_owner, :spexare_view, :user_management_owner, :news_view, :spex_view, :function_view)

# Use Authlogic's session timeout mechanism instead
options[:session_timeout] = 7776000
options[:session_timeout_method] = :clear_authlogic_session
options[:access_denied_path] = "/login"

end 
