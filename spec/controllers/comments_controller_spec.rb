require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let(:user) { build(:user) }
  let(:question) { create(:question) }
  let(:comment) {build(:comment) }

  describe 'get#new' do
    def send_request
      get "new"
    end

    context "if user is not logged in" do

      before do
        send_request
      end

      it "redirects to root path" do
        expect(response).to redirect_to root_path
      end

      it "displays flash message" do
        expect(flash[:notice]).to eq "Please login to continue"
      end

      it "has redirect http status" do
        expect(response).to have_http_status 302
      end

    end

    context "if user is logged in" do

      before do
        user.save!
        login_user(user)
        send_request
      end

      it "build an instance variable new" do
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it "renders new template" do
        expect(response).to render_template("new")
      end

      it "has success http status" do
        expect(response).to have_http_status(200)
      end

    end

  end

    def send_request
      xhr :post, :create, comment: build_attributes(:comment)
    end

    context "user is logged in and question exists" do
      it "creates new comment" do
        user.save!
        login_user(user)
        expect{
          send_request
        }.to change(Comment,:count).by(1)
      end
    end

  end

  describe "get#upvote" do
    
  end



end
