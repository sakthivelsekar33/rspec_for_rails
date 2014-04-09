FactoryGirl.define do

	factory :contact do
		# firstname :sakthivel
		# lastname :sekar
		# sequence(:email) {|n| "sakthivelsekar#{n}@gmail.com"}

		firstname { Faker::Name.first_name }
		lastname { Faker::Name.last_name }
		email { Faker::Internet.email }

		after(:build) do |contact|
			[:home_phone, :work_phone, :mobile_phone].each do |phone_type|
				contact.phones << FactoryGirl.build(:phone, phone_type: phone_type, contact: contact)	
			end
		end

		factory :invalid_contact do
			firstname nil
		end

	end

end