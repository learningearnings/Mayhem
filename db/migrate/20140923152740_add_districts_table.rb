class AddDistrictsTable < ActiveRecord::Migration
  def up
    create_table :districts do |t|
      t.string :guid
      t.string :name
      t.boolean :alsde_study
      t.timestamps
    end

    # Load up initial data
      districts = [
        ["85ac8b51-50ea-4af9-a63f-ee4d2ce42460","Wilcox County",true],
        ["f17daa50-f2bb-43c7-adea-1f62c6134330","Butler County",false],
        ["2488ece3-ac4d-4dce-bf6d-b163cac578ab","Justice",false],
        ["bacfe1df-c874-485d-b50b-408f2b924653","Marion County",true],
        ["bcdeddc9-603a-47fe-9e10-c90bea8ffa87","Kings Illinois",false],
        ["cb6096c9-8dd8-4aa3-8866-e52fab4b78fa","Alexander City",true],
        ["bb5b3f14-bb0f-4058-8678-16a10d0f9418","Jackson",false],
        ["69b1f18e-333e-4aa8-83d5-2647edea4a48","Morgan County",true],
        ["91d9e0f3-1c94-4500-9617-47b278661865","Houston County",false],
        ["9dc9e041-621f-442b-8da4-42962be7b53b","Midfield",false],
        ["53d7cbd7-cd3e-4a50-9258-8c1f6daedb61","Mobile County",false],
        ["ea357ed2-efba-40e3-989a-596fb1701d79","Verbena",false],
        ["9000d023-6e69-44b5-b91e-da9a4709c344","Tallassee",false],
        ["39cca5b3-d0b6-478a-a1e5-7ca20cfc87d8","Pell City",true],
        ["77067f0b-e0aa-445e-ae04-1c65869c9ba7","Alabaster City",true],
        ["519c9ac3-4a58-4e0d-85a4-bc78da2eedae","Belleville Area Special Services Cooperative",false],
        ["21f96193-3652-4d5b-b6b2-6c7b2764ef12","Anniston",true],
        ["4b439d3c-b059-49f2-b399-395de7827e06","Opdyke",false],
        ["e153b2ac-ce50-42d4-b81b-075120edb82f","Bass Memorial SDA",false],
        ["c53ffa87-670b-4542-8361-01b9743fdf21","Baldwin County",false],
        ["560800e2-dd2e-4eb0-b947-cf4c3fb1c92a","Tarrant City",true],
        ["9ba8bc88-4797-4ca4-b9ca-3a8a8bae7ce7","Clay County",false],
        ["840d8256-2e12-4edf-a5e4-f58ed7d71f63","Auburn City",false],
        ["54c44174-7ad5-4abd-9df5-eaa30745ded5","Andalusia",false],
        ["4671b134-91a4-4bad-b2cd-362f45277f9a","Birmingham City",false],
        ["e1189659-0c82-43c1-9d28-0f78f9b6e3d7","Demopolis",false]
    ]

    districts.each do |district|
      District.create(guid: district[0], name: district[1], alsde_study: district[2])
    end
  end

  def down
    drop_table :districts
  end
end
