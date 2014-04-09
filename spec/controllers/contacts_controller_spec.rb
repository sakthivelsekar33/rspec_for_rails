require 'spec_helper'

describe ContactsController do

	describe 'administrator access' do

		before :each do
			user = FactoryGirl.create(:admin)
			session[:user_id] = user.id
		end

		describe 'GET #index' do
			describe 'with params[:letter]' do
				it 'populates an array of contacts starting with the letter' do
					jack = FactoryGirl.create(:contact, lastname: 'jack')
					smith = FactoryGirl.create(:contact, lastname: 'smith')
					get :index, letter: 's'
					expect(assigns(:contacts)).to match_array([smith])  
				end

				it 'renders the :index template' do
					get :index, letter: 's'
					expect(response).to render_template :index 
				end
			end

			describe 'without params[:letter]' do
				it 'populates an array of all contacts' do
					jack = FactoryGirl.create(:contact, lastname: 'jack')
					smith = FactoryGirl.create(:contact, lastname: 'smith')
					get :index
					expect(assigns(:contacts)).to match_array([jack, smith])  
				end

				it 'renders the :index template' do
					get :index
					expect(response).to render_template :index 
				end
			end
		end
		
		describe 'GET #new' do
			it 'assigns a new Contact to @contact' do
				get :new
				expect(assigns(:contact)).to be_a_new(Contact)
			end

			it 'renders the :new template' do
				get :new
				expect(response).to render_template :new
			end
		end

		describe 'GET #edit' do
			it 'assigns the requested contact to @contact' do
				contact = FactoryGirl.create(:contact)
				get :show, id: contact
				expect(assigns(:contact)).to eq contact
			end

			it 'renders the :edit template' do
				contact = FactoryGirl.create(:contact)
				get :edit, id: contact
				expect(response).to render_template :edit
			end
		end

		describe 'GET #show' do
			it 'assigns the requested contact to @contact' do
				contact = FactoryGirl.create(:contact)
				get :show, id: contact
				expect(assigns(:contact)).to eq contact
			end

			it 'renders the :show template' do
				contact = FactoryGirl.create(:contact)
				get :show, id: contact
				expect(response).to render_template :show
			end
		end

		describe 'POST #create' do

			before :each do
				@phones = [
					FactoryGirl.attributes_for(:phone),
					FactoryGirl.attributes_for(:phone),
					FactoryGirl.attributes_for(:phone)
				]
			end

			context 'with valid attributes' do

				it 'saves the new contact in the database' do
					expect{
						post :create, contact: FactoryGirl.attributes_for(:contact, phones_attributes: @phones)
					}.to change(Contact, :count).by(1)
				end

				it 'redirects to contacts#show' do
					post :create, contact: FactoryGirl.attributes_for(:contact, phones_attributes: @phones)
					expect(response).to redirect_to contact_path(assigns[:contact]) 
				end

			end

			context 'with invalid attributes' do

				it 'does not saves the new contact in the database' do
					expect{
						post :create, contact: FactoryGirl.attributes_for(:invalid_contact, phones_attributes: @phones)
					}.to_not change(Contact, :count)
				end

				it 're-renders the new :template' do
					post :create, contact: FactoryGirl.attributes_for(:invalid_contact, phones_attributes: @phones)
					expect(response).to render_template :new
				end
			end
		end

		describe 'PATCH #update' do
			before :each do
				@contact = FactoryGirl.create(:contact, firstname: 'William', lastname: 'Smith')
			end

			context 'with valid attributes' do

				it 'locates the requested contact' do
					patch :update, id: @contact, contact: FactoryGirl.attributes_for(:contact)
					expect(assigns(:contact)).to eq @contact
				end

				it 'changes @contact\'s attributes' do
					patch :update, id: @contact, contact: FactoryGirl.attributes_for(:contact, firstname: 'Stephen', lastname: 'Robin')
					@contact.reload
					expect(@contact.firstname).to eq 'Stephen'
					expect(@contact.lastname).to eq 'Robin'
				end

				it 'redirects to the updated contact' do
					patch :update, id: @contact, contact: FactoryGirl.attributes_for(:contact)
					expect(response).to redirect_to @contact
				end

			end

			context 'with invalid attributes' do

				it 'does not changes the @contact\'s attributes' do
					patch :update, id: @contact, contact: FactoryGirl.attributes_for(:contact, firstname: 'Stephen', lastname: nil)
					@contact.reload
					expect(@contact.firstname).to_not eq 'Stephen'
					expect(@contact.lastname).to eq 'Smith'
				end

				it 're-renders the edit template' do
					patch :update, id: @contact, contact: FactoryGirl.attributes_for(:invalid_contact)
					expect(response).to render_template :edit  
				end
			end
		end

		describe 'DELETE #destroy' do
			before(:each) do
				@contact = FactoryGirl.create(:contact)
			end

			it 'deleted the contact' do
				expect{
					delete :destroy, id: @contact, format: :html
				}.to change(Contact, :count).by(-1)
			end

			it 'redirects to contacts#index' do
				delete :destroy, id: @contact
				expect(response).to redirect_to contacts_url
			end
		end

	end

end