require 'redmine'

Redmine::Plugin.register :redmine_contacts do
  name 'Redmine Contacts plugin'
  author 'Yen-Liang Chen'
  description 'List contact information for all users'
  version '0.0.1'

  menu :top_menu, :contacts, { :controller => 'contacts', :action => 'show' }, :caption => 'Contacts'
end
