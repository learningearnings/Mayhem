#TODO Remove once we are receiving the data over the STI API
namespace :update_city_state_after_sync do
  desc 'Update the City, ST of a few synced schools outside of AL since these fields are not coming over in the sync'
  task :run => :environment do
    Rails.logger.warn "**!@{$%^&*()}************************************"
    Rails.logger.warn "BEGINNING Update the City, ST of a few synced schools outside of AL"
    Rails.logger.warn "**!@{$%^&*()}************************************"
    # Kings, Il
    update_state(1712, 1714, 14, 61068)
    # Wewoka, OK
    update_state(1670, 1670, 31, 74884)
    # Columbus, MS
    update_state(1804, 1810, 37, 39702)
    # Salem, IL
    update_state(1812, 1813, 14, 62881)
    # Wright City, OK
    update_state(2512, 2514, 31, 74766)
    # Colcord, OK
    update_state(2629, 2629, 31, 74338)
    # Arcadia, CA
    update_state(2136, 2136, 5, 91006)
    # New York, NY
    update_state(2266, 2266, 27, 10034)
    # Afton, OK
    update_state(2617, 2617, 31, 74331)
    # Broken Bow, OK
    update_state(2545, 2548, 31, 74728)
    # Perkins, Ok
    update_state(2630, 2633, 31, 74049)
    # Elk City, OK
    update_state(2647, 2648, 31, 73644)
    # Belleville, IL
    update_state(2211, 2215, 14, 62221)
    # Alva, OK
    update_state(2790, 2790, 31, 73717)
    # Smithville, OK
    update_state(2533, 2535, 31, 74997)
    # Rose, OK
    update_state(2628, 2628, 31, 74364)
    # Lumberton, MS
    update_state(1605, 1605, 37, 39455)
    # Sumter, TN
    update_state(2337, 2383, 43, 37075)
    # Chalkable OK Demo Schools
    update_state(1843, 1845, 31, 73104)
    # Chalkable TN Demo Schools
    update_state(2701, 2706, 43, 37201)
    # Newton, MS
    update_state(3050, 3052, 37, 39345)
    # LaFayette Municipal
    update_state(3190, 3193, 37, 38655)
    
    Rails.logger.warn "**!@{$%^&*()}************************************"
    Rails.logger.warn "ENDING Update the City, ST of a few synced schools outside of AL"
    Rails.logger.warn "**!@{$%^&*()}************************************"
  end
  
  def update_state(first_id, last_id, state_id, zip)
    $i = first_id
    $num = last_id

    until $i > $num  do
      s = School.find($i)
      s.state_id = state_id
      s.zip = zip
      s.save
      $i +=1;
    end
  end
end
