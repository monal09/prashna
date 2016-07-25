require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:user) { build(:user) }
  let(:invalid_user) { build(:invalid_user) }
  let(:created_user) { create(:user) }

  describe 'GET#new' do
    def send_request
      get :new
    end

    # it "expects before_action ensure_anynomous to be called" do
    #   controller.class.before_action(:ensure_anynomous)
    # end

    context "if user is logged in" do

      before do
        user.save!
        login_user(user)
        send_request
      end

      it "redirects to root" do
        expect(response).to redirect_to(root_path)
      end

      it "displays flash message" do
        expect(flash.now[:alert]).to eq "You are already logged in."
      end

      it "gives redirection response code" do
        expect(response).to have_http_status(302)
      end
    end

    context "if user is not logged in" do
      before do
        send_request
      end

      it "renders new template" do
        expect(response).to render_template("new")
      end

      it "gives success response code" do
        expect(response).to have_http_status(200)
      end

    end
  end

  describe 'POST#create' do

    def send_request_with_valid_attributes
      post :create, user: attributes_for(:user)
    end

    def send_request_with_invalid_attributes
      post :create, user: attributes_for(:invalid_user)
    end

    #   it "expects before_action ensure_anynomous to be called" do
    #     controller.class.before_action(:ensure_anynomous)
    #   end

    context 'if user is logged in' do

      before do
        user.save!
        login_user(user)
        send_request_with_valid_attributes
      end

      it "redirects to root" do
        expect(response).to redirect_to(root_path)
      end

      it "displays flash message" do
        expect(flash.now[:alert]).to eq "You are already logged in."
      end

      it "gives redirection response code" do
        expect(response).to have_http_status(302)
      end
    end

    context 'if user is not logged in' do

      context 'with valid attributes' do

        it "creates new contact" do
          expect{
            send_request_with_valid_attributes
          }.to change(User,:count).by(1)
        end

        it "redirects to root path" do
          send_request_with_valid_attributes
          expect(response).to redirect_to(root_path)
        end

        it "displays flash message" do
          send_request_with_valid_attributes
          expect(flash[:notice]).to eq "Signup successfull!!. A verification
          mail has been sent to your user id #{user.email}. Please verify your account to continue"
        end

        it "gives redirection response" do
          send_request_with_valid_attributes
          expect(response).to have_http_status(302)
        end
      end

      context 'with invalid attributes' do

        it "do not create a new contanct" do
          expect{
            send_request_with_invalid_attributes
          }.to change(User,:count).by(0)
        end

        it "renders new template" do
          send_request_with_invalid_attributes
          expect(response).to render_template("new")
        end

        it "gives success response" do
          send_request_with_invalid_attributes
          expect(response).to have_http_status(200)
        end

      end

    end
  end

  describe 'POST#edit' do

    def send_request
      get :edit, id: created_user.id
    end

    # it "expects before_action set_user to be called" do
    #   controller.class.before_action(:set_user)
    # end

    # it "expects before_action check_privelage_for_editing to be called" do
    #   controller.class.before_action(:check_privelage_for_editing)
    # end

    context "user is not allowed to edit/logged in" do

      before do
        send_request
      end

      it "redirects to root" do
        expect(response).to redirect_to(root_path)
      end

      it "displays flash message" do
        expect(flash[:notice]).to eq "You can't edit other user profile."
      end

      it "gives redirect response code" do
        expect(response).to have_http_status(302)
      end

    end

    context "user is logged in" do

      before do
        session[:user_id] = nil
        login_user(created_user)
      end

      it "renders edit" do
        send_request
        expect(response).to render_template(:edit)
      end

      it "gives success response code" do
        expect(response).to have_http_status(200)

      end

    end


  end

  context "patch#update" do

  end

end
