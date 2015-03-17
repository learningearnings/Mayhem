#TODO Remove once we are receiving the data over the STI API
namespace :update_city_state_after_sync do
  desc 'Update the City, ST of a few synced schools outside of AL since these fields are not coming over in the sync'
  task :run => :environment do
    s = School.find(1712)
    s.city = "Kings"
    s.state_id = 14
    s.zip = 61068
    s.save
    s = School.find(1713)
    s.city = "Kings"
    s.state_id = 14
    s.zip = 61068
    s.save
    s = School.find(1714)
    s.city = "Kings"
    s.state_id = 14
    s.zip = 61068
    s.save
    s = School.find(1670)
    s.city = "Wewoka"
    s.state_id = 31
    s.zip = 74884
    s.save
    s = School.find(1804)
    s.city = "Columbus"
    s.state_id = 37
    s.zip = 39702
    s.save
    s = School.find(1805)
    s.city = "Columbus"
    s.state_id = 37
    s.zip = 39705
    s.save
    s = School.find(1806)
    s.city = "Columbus"
    s.state_id = 37
    s.zip = 39705
    s.save
    s = School.find(1807)
    s.city = "Columbus"
    s.state_id = 37
    s.zip = 39702
    s.save
    s = School.find(1808)
    s.city = "Columbus"
    s.state_id = 37
    s.zip = 39701
    s.save
    s = School.find(1809)
    s.city = "Columbus"
    s.state_id = 37
    s.zip = 39701
    s.save
    s = School.find(1810)
    s.city = "Columbus"
    s.state_id = 37
    s.zip = 39701
    s.save
    s = School.find(1812)
    s.city = "Salem"
    s.state_id = 37
    s.zip = 62881
    s.save
    s = School.find(1813)
    s.city = "Salem"
    s.state_id = 37
    s.zip = 62881
    s.save
  end
end
