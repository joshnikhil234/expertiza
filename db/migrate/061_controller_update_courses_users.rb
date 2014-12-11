class ControllerUpdateCoursesUsers < ActiveRecord::Migration
  def self.up
     permission1 = Permission.find_or_create_by(name: 'administer courses')
     site_controller = SiteController.find_or_create_by(name: 'courses_users')
     site_controller.permission_id = permission1.id     
     site_controller.save
     Role.rebuild_cache     
  end

  def self.down
    site_controller = SiteController.find_by_name('courses_users')
    if site_controller != nil
      actions = ControllerAction.where(['site_controller_id = ?',site_controller.id])
      actions.each {|action| 
        menuItems = MenuItem.where(['controller_action_id = ?',action.id])
        menuItems.each{ |item| item.destroy}
        action.destroy
      }
      site_controller.destroy
    end
    Role.rebuild_cache     
  end
end
