FactoryGirl.define do 

  factory :jon, class: User do
    name 'Jon'
  end

  factory :sam, class: User do
    name 'Sam'
  end

  factory :bob, class: User do
    name 'Bob'
  end

  factory :angela, class: User do
    name 'Angela'
    private_followable true
  end

end
