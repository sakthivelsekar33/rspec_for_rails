FactoryGirl.define do
	factory :phone do
		association :contact
		phone_type 'mobile'
		phone { Faker::PhoneNumber.phone_number }

		factory :home_phone do
			phone_type 'home'
		end

		factory :mobile_phone do
			phone_type 'mobile'
		end

		factory :work_phone do
			phone_type :work
		end
		
	end
end 