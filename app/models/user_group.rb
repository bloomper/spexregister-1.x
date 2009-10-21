class UserGroup < ActiveRecord::Base
  has_and_belongs_to_many :permissions
  has_and_belongs_to_many :users
  acts_as_dropdown :value => 'id', :text => 'name', :order => 'name ASC'

  validates_presence_of :name
  
	def all_users
		User.find_by_sql <<-SQL
			select users.* 
			from users, user_groups_users
			where users.id = user_groups_users.user_id 
			and user_groups_users.user_group_id = #{self.id}
    SQL
	end
end

# Override in order to achieve I18N
#module DeLynnBerry
#  module Dropdown
#    def to_options_for_select_with_i18n(text = :name, value = :id, include_blank = false)
#      items = self.collect { |x| [I18n.t("user_group.name.#{x.send(text.to_sym).downcase}"), x.send(value.to_sym)] }
#
#      if include_blank
#        items.insert(0, include_blank.kind_of?(String) ? [include_blank, ""] : ["", ""])
#      end
#
#      items
#    end
#    alias :to_dropdown :to_options_for_select_with_i18n
#  end
#end
