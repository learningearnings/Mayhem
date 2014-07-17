describe Food do
  it "should give its name when to_s is called" do
    food = Food.create(name: "Test Food")
    expect(food.to_s).to eq("Test Food")
  end
end
