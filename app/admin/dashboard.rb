ActiveAdmin.register_page "LE Admin Dashboard" do
#ActiveAdmin::Dashboards.build do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

    controller do
      skip_before_filter :add_current_store_id_to_params
    end
    content do
      columns do
        column do
          panel "Today's Student/Teacher/SchoolAdmin Logins" do
            table do
              tr do
                th "School Admins"
                th "Teachers"
                th "Students"
              end
              tr do
                td $redis.get(Time.zone.now.strftime("schooladminlogincounter:%m%d%y")) || 0
                td $redis.get(Time.zone.now.strftime("teacherlogincounter:%m%d%y")) || 0
                td $redis.get(Time.zone.now.strftime("studentlogincounter:%m%d%y")) || 0
              end
            end
          end
        end
        column do
          panel "Today's Most Active Schools" do
            school_logins = $redis.hgetall(Time.zone.now.strftime("schoollogincounter:%m%d%y"))
            school_logins = school_logins.map {|key, value| [School.find(key), value] }.sort_by {|elm| elm[1] }
            table do
              tr do
                th "School Name"
                th "User Logins"
              end
              school_logins.each do |school_row|
                tr do
                  td school_row.first
                  td school_row.last
                end
              end
            end
          end
        end
      end
    end
  end
