john = User.create!(
  email: "john.doe@example.com",
  first_name: "John",
  last_name: "Doe",
  password: '123456'
)

jane = User.create!(
  email: "jane.doe@example.com",
  first_name: "Jane",
  last_name: "Doe",
  password: '123456'
)

Property.create!(
  [
    {
      name: 'Apartment #1',
      address: 'str. Great, 24',
      city: 'London',
      notes: 'Great apartment on a beautiful street',
      user:  john
    },
    {
      name: 'Apartment #2',
      address: 'str. Great, 25',
      city: 'New York',
      notes: 'Great apartment on a beautiful street',
      user:  jane
    }
  ]
)