require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:questions)
  end

  test "should get new if logged in" do
    get :new, nil, { user_id: users(:sufficient_balance_user).id}
    assert_response :ok
    assert_template :new
    assert assigns(:question).new_record?, "New question object not made properly."
  end

  test "new should be redirected to root if not logged in" do
    get :new
    assert_redirected_to root_path, "not redirected if not logged in"
    assert_equal flash[:notice], "Please login to continue", "Flash messagenot displayed properly."
  end

  test "should create question" do
    assert_difference('Question.count') do
      post :create, {question: {title: 'Some title', content: "some content forquestion."}}, { user_id: 2}
    end
    assert_redirected_to question_path(assigns(:question))
  end

  test "should not create qestion whan question save fail" do
    assert_no_difference("Question.count") do
      post :create, {question: {title: 'Some title'}}, { user_id: users(:sufficient_balance_user)}
    end
    assert_template :new
  end

  test "should not create qestion when user not present" do
    assert_no_difference("Question.count") do
      post :create, {question: {title: 'Some title', content: "some content forquestion."}}
    end
    assert_redirected_to root_path
  end

  test "should show question when question is set and visible" do
    get :show, {id: questions(:published_question_1).id}
    assert_response :success
    assert_template :show
    question = assigns(:question)
    visible_status = (question.not_offensive? && question.published? && !question.admin_unpublished)
    assert visible_status
  end

  test "should show question to owner of question in any case" do
    get :show, {id: questions(:draft_question_1)}, {user_id: users(:sufficient_balance_user)}
    assert_response :success
    assert_template :show
    assert assigns(:question).persisted?, "This question does not exist."
  end

  test "should show question to admin unless in draft state" do
    get :show, {id: questions(:published_question_7)}, {user_id: users(:admin_user).id}
    assert_response :success
    assert_template :show
    assert assigns(:question).persisted?, "This question does not exist"
  end

  test "should not show abusive question to non owner or no adminn user" do
    get :show, {id: questions(:published_question_8)}, {user_id: users(:sufficient_balance_user).id}
    assert_response 302
    assert_redirected_to root_path, "not redirected for abusive question"
    assert_equal flash[:notice], "You are not allowed to access this question.", "Flash messagenot displayed properly."
  end

  test "should not show edit page to non logged in user" do
  	get :edit, { id: questions(:published_question_8)}
  	assert_response :302
  	assert_redirected_to root_path, ""
  end

end
