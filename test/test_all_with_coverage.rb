# Run 'rcov -o tmp/coverage test/test_all_with_coverage.rb' from the command line in the root directory.
# Open tmp/coverage/index.html in a browser 

# Note that integration tests may not be included as they mess up the functional tests of some reason

# Functional tests
require 'test/functional/admin/function_item_controller_test'
require 'test/functional/admin/home_controller_test'
require 'test/functional/admin/news_item_controller_test'
require 'test/functional/admin/spex_item_controller_test'
require 'test/functional/admin/spexare_item_controller_test'
require 'test/functional/admin/user_item_controller_test'
require 'test/functional/browse_controller_test'
require 'test/functional/export_controller_test'
require 'test/functional/home_controller_test'
require 'test/functional/search_controller_test'

# Unit tests
require 'test/unit/actor_item_test'
require 'test/unit/configuration_item_test'
require 'test/unit/function_category_item_test'
require 'test/unit/function_item_test'
require 'test/unit/link_item_test'
require 'test/unit/mailer_test'
require 'test/unit/news_item_test'
require 'test/unit/role_item_test'
require 'test/unit/spex_category_item_test'
require 'test/unit/spex_item_test'
require 'test/unit/spex_poster_item_test'
require 'test/unit/spexare_item_test'
require 'test/unit/spexare_picture_item_test'
require 'test/unit/user_item_test'

