# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }" =>  { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel'" =>  city: cities.first)
State.create([{ :name => "Alabama", :abbr => "AL"},
              { :name => "Alaska", :abbr => "AK"},
              { :name => "Arizona", :abbr => "AZ"},
              { :name => "Arkansas", :abbr => "AR"},
              { :name => "California", :abbr => "CA"},
              { :name => "Colorado", :abbr => "CO"},
              { :name => "Connecticut", :abbr => "CT"},
              { :name => "Delaware", :abbr => "DE"},
              { :name => "District of Columbia", :abbr => "DC"},
              { :name => "Florida", :abbr => "FL"},
              { :name => "Georgia", :abbr => "GA"},
              { :name => "Hawaii", :abbr => "HI"},
              { :name => "Idaho", :abbr => "ID"},
              { :name => "Illinois", :abbr => "IL"},
              { :name => "Indiana", :abbr => "IN"},
              { :name => "Iowa", :abbr => "IA"},
              { :name => "Kansas", :abbr => "KS"},
              { :name => "Kentucky", :abbr => "KY"},
              { :name => "Louisiana", :abbr => "LA"},
              { :name => "Maine", :abbr => "ME"},
              { :name => "Montana", :abbr => "MT"},
              { :name => "Nebraska", :abbr => "NE"},
              { :name => "Nevada", :abbr => "NV"},
              { :name => "New Hampshire", :abbr => "NH"},
              { :name => "New Jersey", :abbr => "NJ"},
              { :name => "New Mexico", :abbr => "NM"},
              { :name => "New York", :abbr => "NY"},
              { :name => "North Carolina", :abbr => "NC"},
              { :name => "North Dakota", :abbr => "ND"},
              { :name => "Ohio", :abbr => "OH"},
              { :name => "Oklahoma", :abbr => "OK"},
              { :name => "Oregon", :abbr => "OR"},
              { :name => "Maryland", :abbr => "MD"},
              { :name => "Massachusetts", :abbr => "MA"},
              { :name => "Michigan", :abbr => "MI"},
              { :name => "Minnesota", :abbr => "MN"},
              { :name => "Mississippi", :abbr => "MS"},
              { :name => "Missouri", :abbr => "MO"},
              { :name => "Pennsylvania", :abbr => "PA"},
              { :name => "Rhode Island", :abbr => "RI"},
              { :name => "South Carolina", :abbr => "SC"},
              { :name => "South Dakota", :abbr => "SD"},
              { :name => "Tennessee", :abbr => "TN"},
              { :name => "Texas", :abbr => "TX"},
              { :name => "Utah", :abbr => "UT"},
              { :name => "Vermont", :abbr => "VT"},
              { :name => "Virginia", :abbr => "VA"},
              { :name => "Washington", :abbr => "WA"},
              { :name => "West Virginia", :abbr => "WV"},
              { :name => "Wisconsin", :abbr => "WI"},
              { :name => "Wyoming", :abbr => "WY"}
             ])

begin
  f = Filter.find(1)
rescue
  if Filter.all.count < 1
    f = Filter.new(:minimum_grade => 0, :maximum_grade => 12)
    #  f.id = 0
    f.school_filter_links << SchoolFilterLink.create(:school_id => nil)
    f.classroom_filter_links << ClassroomFilterLink.create(:classroom_id => nil)
    f.state_filter_links << StateFilterLink.create(:state_id => nil)
    f.person_class_filter_links << PersonClassFilterLink.create(:person_class => nil)
    f.save
  end
end


