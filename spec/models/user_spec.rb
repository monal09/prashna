require 'rails_helper'

RSpec.describe User, :type => :model do

  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  let(:factory_instance) { build(:user) }
  let(:factory_instance_created) { create(:user) }
  let(:factory_instance_with_topic) { create(:user_with_topic) }

  describe "ActiveModel validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should have_secure_password }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should allow_value("abc@gmail.com").for(:email) }
    it { should_not allow_value("ada").for(:email).with_message("Invalid") }
    it { should have_attached_file(:image) }
    it { should validate_attachment_content_type(:image).
         allowing("image/jpeg", "image/gif", "image/png").
         rejecting('text/plain', 'text/xml') }
  end

  describe "ActiveRecord associations" do
    it { should have_and_belong_to_many(:topics) }
    it { should have_many(:credit_transactions).dependent(:destroy) }
    it { should have_many(:questions).dependent(:nullify) }
    it { should have_many(:answers).dependent(:nullify).inverse_of(:user) }
    it { should have_many(:transactions).dependent(:restrict_with_error) }
    it { should have_many(:orders).dependent(:restrict_with_error) }
    it { should have_many(:comments).dependent(:nullify).inverse_of(:user) }
    it { should have_many(:abuse_reports).dependent(:destroy) }
    it { should have_many(:user_notifications).dependent(:destroy) }
    it { should have_many(:active_relationships).class_name(:Relationship).with_foreign_key(:follower_id).dependent(:destroy) }
    it { should have_many(:passive_relationships).class_name(:Relationship).with_foreign_key(:followed_id).dependent(:destroy) }
    it { should have_many(:follows).through(:active_relationships).source(:followed).dependent(:destroy) }
    it { should have_many(:followed_by).through(:passive_relationships).source(:follower).dependent(:destroy) }
  end

  describe "callbacks" do
    it { is_expected.to callback(:set_validate_password).before(:validation).on(:create) }
    it { is_expected.to callback(:generate_verification_token).before(:create).unless(:admin?) }
    it { is_expected.to callback(:auto_verify_email).before(:create).unless(:admin?) }
    it { is_expected.to callback(:send_verification_mail).after(:commit) }
    it { is_expected.to callback(:add_topics).after(:save) }
  end

  describe "public instance methods" do

    context "responds to its methods" do
      it { expect(factory_instance).to respond_to(:verify!) }
      it { expect(factory_instance).to respond_to(:change_password!) }
      it { expect(factory_instance).to respond_to(:valid_verification_token?) }
      it { expect(factory_instance).to respond_to(:valid_forgot_password_token?) }
      it { expect(factory_instance).to respond_to(:verified?) }
      it { expect(factory_instance).to respond_to(:send_forgot_password_instructions) }
      it { expect(factory_instance).to respond_to(:generate_remember_me_token) }
      it { expect(factory_instance).to respond_to(:generate_authorization_token) }
      it { expect(factory_instance).to respond_to(:reset_remember_me!) }
      it { expect(factory_instance).to respond_to(:following?) }
      it { expect(factory_instance).to respond_to(:get_topics_list) }
      it { expect(factory_instance).to respond_to(:enabled?) }
    end

    context "executes methods correctly" do
      context "#verify!" do
        it "verifies the user on successful signup" do
          factory_instance_created.verify!
          expect(factory_instance_created.verification_token_expiry_at).to be_nil
          expect(factory_instance_created.verification_token).to be_nil
          expect(factory_instance_created.credit_balance).to eq(5)
          expect(factory_instance_created.authorization_token).to_not be_nil
        end
      end

      context "#change_password!" do
        it "changes the password" do
          factory_instance.change_password!("abcdef", "abcdef")
          expect(factory_instance.validate_password).to be true
          expect(factory_instance.password).to eq("abcdef")
          expect(factory_instance.password_confirmation).to eq("abcdef")
          expect(factory_instance.forgot_password_token).to be_nil
          expect(factory_instance.forgot_password_token_expiry_at).to be_nil 
        end
      end

      context "#valid_verification_token?" do
        it "compares the verification token expiry with current time" do
          expect(factory_instance_created.valid_verification_token?).to be true
        end
      end

      context "#valid_forgot_password_token?" do
        it "compares the forgot password token expiry time with the current time" do
          user_with_forgot_password = build(:user, forgot_password_token_expiry_at: Time.current + 2.hours)
          expect(user_with_forgot_password.valid_forgot_password_token?).to be true
        end
      end

      context "#verified?" do
        it "tells wheter the user is verified or not" do
          verified_user = build(:user, verified_at: Time.current)
          expect(verified_user.verified?).to be true
        end
      end

      context "#reset_remember_me!" do
        it "resets the remember_me_token and sets it to nil" do
          factory_instance.generate_remember_me_token
          factory_instance.reset_remember_me!
          expect(factory_instance.remember_me_token).to be_nil
        end
      end

      context "#enabled?" do
        it "checks if user is not disbled" do
          disabled_user = build(:user, disabled: true)
          expect(disabled_user.enabled?).to be false
        end
      end

      context "#following?" do
        it "checks if one user is following another user" do
          new_user = create(:user, first_name: "new name", email: "a2@f.com")
          relationship = new_user.active_relationships.build(followed_id: factory_instance_created.id)
          relationship.save
          expect(new_user.following?(factory_instance_created)).to be true
        end
      end

      context "#send_forgot_password_instructions" do
        it "sends instruction to user if forgot password is clicked" do
          factory_instance_created.send_forgot_password_instructions
          expect(factory_instance_created.forgot_password_token).to_not be_nil
        end
      end

      context "#get_topics_list" do
        it "gets the topics list for current user" do
          expect(factory_instance_with_topic.get_topics_list).to eq("topic1")
        end
      end


    end


  end




end
