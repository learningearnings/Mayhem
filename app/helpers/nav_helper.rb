module NavHelper
  def students_path
    if current_person.synced?
      main_app.edit_teachers_bulk_students_path
    else
      main_app.teachers_bulk_students_path
    end
  end

  def menu_json
    home = Array.new
    main = Array.new
    user = Array.new
    routes = {
      "home" => "/",
      "school-admins-bank-link" => main_app.school_admins_bank_path,
      "inbox-link" => main_app.inbox_path,
      "teachers-inbox-link" => main_app.teachers_inbox_path,
      "students-edit-link" => '/teachers/bulk_students/edit',
      "students-link" =>  '/teachers/bulk_students',
      "teachers-link" =>  main_app.teachers_bulk_teachers_path,
      "classrooms-link" =>  main_app.classrooms_path,
      "shop-link" =>  "/store",
      "school-admin-reports-link" =>  main_app.school_admins_reports_path,
      "teachers-bank-link" =>  main_app.teachers_bank_path,
      "reports-link" =>  main_app.teachers_reports_path,
      "home-link" =>  main_app.home_path,
      "locker-link" =>  main_app.locker_path,
      "students-bank-link" =>  main_app.bank_path,
      "play-link" =>  main_app.games_path,
      "help-link" => main_app.help_path,
      "profile-link" => current_person.present? ? main_app.person_path(current_person) : '',
      "school-settings-link" =>  '/schools/settings',
      "logout-link" => spree.get_destroy_user_session_path
    }

    home <<  {
              id: 'home',
              name: 'Home'
          }

    if current_person
      if current_person.is_a?(SchoolAdmin)
        main =    [
          {
              id: 'school-admins-bank-link',
              name: 'Bank',
              activeAt: '^/school-admins-bank',
              iconName: 'bank'
          },
          {
              id: 'teachers-inbox-link',
              name: inbox_label_with_message_count("Inbox", current_person.received_messages),
              activeAt: '^/inbox',
              iconName: 'message-bubbles-f'
          },
          {
              id: current_person.synced? ? 'students-edit-link' : 'students-link',
              name: 'Students',
              activeAt: '^/students',
              iconName: 'student-f'
          },
          {
              id: 'teachers-link',
              name: 'Teachers',
              activeAt: '^/teachers',
              iconName: 'teacher'
          },
          {
              id: 'classrooms-link',
              name: 'Classrooms',
              activeAt: '/classrooms/',
              iconName: 'group'
          },
          {
              id: 'play-link',
              name: 'Play',
              activeAt: '^/play',
              iconName: 'play'
          },
          {
              id: 'shop-link',
              name: 'Shop',
              activeAt: '^/shop',
              iconName: 'shop'
          },
          {
              id: 'school-admin-reports-link',
              name: 'Reports',
              activeAt: '^/reports',
              iconName: 'bar-graph-f'
          }
        ]
      elsif current_person.is_a?(Teacher)
        main =    [
          {
              id: 'teachers-bank-link',
              name: 'Bank',
              activeAt: '^/teachers-bank',
              iconName: 'bank'
          },
          {
              id: 'teachers-inbox-link',
              name: inbox_label_with_message_count("Inbox", current_person.received_messages),
              activeAt: '^/inbox',
              iconName: 'message-bubbles-f'
          },
          {
              id: current_person.synced? ? 'students-edit-link' : 'students-link',
              name: 'Students',
              activeAt: '^/students',
              iconName: 'student-f'
          },
          {
              id: 'classrooms-link',
              name: 'Classrooms',
              activeAt: '^/classrooms',
              iconName: 'group'
          },
          {
              id: 'shop-link',
              name: 'Shop',
              activeAt: '^/shop',
              iconName: 'shop'
          },
          {
              id: 'reports-link',
              name: 'Reports',
              activeAt: '^/reports',
              iconName: 'bar-graph-f'
          }
        ]
      else
        main =    [
          {
              id: 'home-link',
              name: 'Home',
              activeAt: '^/home',
              iconName: 'home'
          }
         ]
         if current_person.grade < 9
            main << {
                id: 'locker-link',
                name: 'Locker',
                activeAt: '^/locker',
                iconName: 'locker'
            }
         end
         main.concat( [
          {
              id: 'inbox-link',
              name: inbox_label_with_message_count("Inbox", current_person.received_messages),
              activeAt: '^/inbox',
              iconName: 'message-bubbles-f'
          },
          {
              id: 'students-bank-link',
              name: 'Bank',
              activeAt: '^/students-bank',
              iconName: 'bank',
              isCurrentRoute?: true

          },
          {
              id: 'play-link',
              name: 'Play',
              activeAt: '^/play',
              iconName: 'play'
          },
          {
              id: 'shop-link',
              name: 'Shop',
              activeAt: '^/shop',
              iconName: 'shop'
          }
        ])
      end
    end

    if current_user and current_person
      user << {
            id: 'profile-link',
            name: 'Profile',
            activeAt: '^/profile',
            iconName: 'person-card-s'
      }
      if current_person.is_a?(SchoolAdmin)
        user << {
            id: 'school-settings-link',
            name: 'Settings',
            activeAt: '^/settings',
            iconName: 'settings-f'
        }
      end
      user << {
            id: 'help-link',
            name: 'Help',
            activeAt: '^/help',
            iconName: 'help-f'
      }
      user << {
            id: 'logout-link',
            name: 'Logout',
            activeAt: '^/logout',
            iconName: 'logout'
      }
    end

    if current_person
      username = {
        firstName: current_person.first_name,
        lastName: current_person.last_name
      }
    else
      username = {
        firstName: 'Guest',
        lastName: 'User'
      }
    end
    return raw("<script>var menu_json = " +  { home: home, main: main, user: user, username: username, routes: routes}.to_json + ";</script>")
  end
end
