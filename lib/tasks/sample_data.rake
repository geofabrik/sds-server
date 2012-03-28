namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:firstname => "nnn",
                 :lastname => "Name",
                 :email => "nnn@geofabrik.de")
    11.times do |n|
      firstname  = Faker::Name.name
      lastname  = Faker::Name.name
      email = "example-#{n+1}@geofabrik.de"
      User.create!(:firstname => firstname,
                   :lastname => lastname,
                   :email => email)
    end
    admin = User.create!(:firstname => "Christine",
                         :lastname => "Karch",
                         :email => "ccc@geofabrik.de")
    admin.password = "ccc"
    admin.save!
    admin.toggle!(:admin)
    admin2 = User.create!(:firstname => "Frederik",
                         :lastname => "Ramm",
                         :email => "ddd@geofabrik.de")
    admin2.password = "ddd"
    admin2.save!
    admin2.toggle!(:admin)

    # Project.create!(:name => "Generic", :partial => "generic")
    Project.create!(:name => "BBB Home Owner", :partial => "bbb_home_owner")
    Project.create!(:name => "BBB Door To Door", :partial => "bbb_door_door")
    Project.create!(:name => "ACCESS Poverty Mapping", :partial => "access_poverty_mapping")
    Project.create!(:name => "PNPM Poverty Mapping", :partial => "pnpm_poverty_mapping")

  end
end

