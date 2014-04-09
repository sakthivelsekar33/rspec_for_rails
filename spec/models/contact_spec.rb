require 'spec_helper'

describe Contact do

	it 'has a valid factory' do
		expect(FactoryGirl.build(:contact)).to be_valid
	end

	it 'is valid with firstname, lastname and email' do
		contact = Contact.new(
			:firstname => 'contact_1',
			:lastname => 'lastname',
			:email => 'contact_1@email.com'
			)
		expect(contact).to be_valid
	end

	it 'is invalid without a firstname' do
		# expect(Contact.new(firstname: nil)).to have(1).errors_on(:firstname)
		contact = FactoryGirl.build(:contact, firstname: nil)
		expect(contact).to have(1).errors_on(:firstname)
	end

	it 'is invalid without a lastname' do
		# expect(Contact.new(lastname: nil)).to have(1).errors_on(:lastname)
		contact = FactoryGirl.build(:contact, lastname: nil)
		expect(contact).to have(1).errors_on(:lastname)
	end

	it 'is invalid without a email' do
		# expect(Contact.new(email: nil)).to have(1).errors_on(:email)
		contact = FactoryGirl.build(:contact, email: nil)
		expect(contact).to have(1).errors_on(:email)
	end

	it 'is invalid with a duplicate email address' do
		# Contact.create(firstname: :contact_1, lastname: :lastname, email: 'contact_1@email.com')
		# contact = Contact.new(firstname: :contact_2, lastname: :lastname, email: 'contact_1@email.com')
		FactoryGirl.create(:contact, email: 'sakthivelsekar1@gmail.com')
		contact = FactoryGirl.build(:contact, email: 'sakthivelsekar1@gmail.com')
		expect(contact).to have(1).errors_on(:email)
	end

	it 'returns a contact\'s full name as a string' do
		contact = FactoryGirl.create(:contact, firstname: :sakthivel, lastname: :sekar)
		expect(contact.name).to eq 'sakthivel sekar'
	end

	describe "filter last name by letter" do

		before :each do
			@john = Contact.create(firstname: :contact_2, lastname: :john, email: 'contact_2@email.com')
			@michel = Contact.create(firstname: :diff_contact, lastname: :michel, email: 'diff_contact@email.com')
			@joe = Contact.create(firstname: :contact_1, lastname: :joe, email: 'contact_1@email.com')
		end

		context 'matching letter' do
			it "returns a sorted array of results that match" do
				expect(Contact.by_letter('j')).to eq [@joe, @john]
			end
		end

		context 'non-matching letter' do
			it "returns a sorted array of results that match" do
				expect(Contact.by_letter('l')).to_not include @michel
			end
		end

	end

end