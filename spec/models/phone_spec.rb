require 'spec_helper'

describe Phone do

	it 'has a valid factory' do
		phone = FactoryGirl.build(:phone)
		expect(phone).to be_valid
	end

	it 'does not allow duplicate phone number per contact' do
		# contact = Contact.create(firstname: :contact_1, lastname: :last_name, email: 'contact_1@email.com')
		# contact.phones.create(phone: '123456789', phone_type: :mobile)
		# mobile_phone = contact.phones.build(phone: '123456789', phone_type: :home)

		contact = FactoryGirl.create(:contact)
		FactoryGirl.create(:mobile_phone, contact: contact, phone: '123456789')
		mobile_phone = FactoryGirl.build(:mobile_phone, contact: contact, phone: '123456789')	
		expect(mobile_phone).to have(1).errors_on(:phone)
	end

	it 'allows two contacts to share a phone number' do
		# contact = Contact.create(firstname: :contact_1, lastname: :last_name, email: 'contact_1@email.com')
		# contact.phones.create(phone: '123456789', phone_type: :mobile)

		# contact_2 = Contact.new()
		# contact_2_phone = contact_2.phones.build(phone: '123456789', phone_type: :mobile)

		FactoryGirl.create(:mobile_phone, phone: '123456789')
		contact_2_phone = FactoryGirl.build(:mobile_phone, phone: '123456789')

		expect(contact_2_phone).to be_valid
	end

end