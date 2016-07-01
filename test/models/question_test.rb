require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  test "should not save the question without title" do
    question = Question.new(content: "Testing question that should not be save without a title.")
    assert_not question.save, "Saved question without a title."
  end

  test "should not save the question without content" do
    question = Question.new(title: "Testing question without tilte")
    assert_not question.save, "Saved question without a content."
  end

  test "should not save question with content size less than 20" do
    question = Question.new(content: "c1")
    assert_not question.save, "Saved question with a small content."
  end

  test "should not save question when user balance is less then minimum    required" do
    question = users(:insufficient_balance_user).questions.new(title: "jfioerf refierkjf ", content: "ferjfioef rfire kferfkj f erkfjerfjkerf rej", published: true)
    assert_not question.save, "Saved question of user with insuuficient balance."
  end

  test "published at is assigned before saving a published question" do
    question = questions(:unpublished_question)
    question.published_at = "2016-06-24 09:50:57"
    question.save
    assert_equal( question.published_at, "2016-06-24 09:50:57" , "Published at was not set successfully")
  end

  test "credit was successfully deducted for asking question" do
    question = questions(:unpublished_question)
    assert_difference("question.user.credit_balance", difference = -1 * CONSTANTS["credit_required_for_asking_question"]) do
      question.published = true
      question.save
    end
  end

  test "topics added when topics added to question" do
    question = questions(:published_question_0)
    question.associated_topics = "ruby,rails,java"
    question.title = "dsfdsfdsf"
    assert_difference("question.topics.size", difference = 3) do
      question.save
    end
    assert question.topics.find_by(name: "ruby").persisted?
    assert question.topics.find_by(name: "rails").persisted?
    assert question.topics.find_by(name: "java").persisted?
  end

  test "notification created when question is published" do
    question = questions(:unpublished_question)
    question.published = true
    question.save
    assert_not_nil question.notifications.first, "Notification for this question is not created."
  end

  test "published question scope returns published questions" do
    questions = Question.published.all
    assert_equal( questions.size , 10, "published not giving correct results")
    assert questions.all?{ |question| question.published = true}, "Some questions are not published"
  end

  test "search question with title" do
    questions = Question.search_question("xyxy")
    assert_equal( questions.size, 10, "incorrect search result")
    assert questions.all?{ |question| question.title.match('xyxy') }
  end

  test "find questions published after given time" do
    questions = Question.published_after(Time.current - 2.days)
    assert_equal( questions.size, 10, "incorrect no of questions after given time.")
    assert questions.all?{ |question| ((Time.current - 2.days).to_i..Time.current.to_i).include?(question.published_at.to_i)}
  end

  test "find questions which are unoffensive" do
    questions = Question.unoffensive
    assert_equal( questions.size, 5, "incorrect no offensive questions.")
    assert questions.all?{ |question| question.not_offensive? }, "Some questions are not offensive"
  end

  test "find admin unpublished questions" do
    questions = Question.admin_unpublished
    assert_equal( questions.size, 5, "incorrect no of admin unpublished questions")
    assert questions.all?{ |question| question.admin_unpublished = true}, "Some questions are published"
  end

  test "find visible questions" do
    questions = Question.visible
    assert_equal( questions.size, 1, "incorrect no visible questions")
    assert questions.all?{ |question| question.published? && question.not_offensive? && !question.admin_unpublished?}
  end

  test "submitted_by" do
    questions = Question.submitted_by(1)
    assert_equal( questions.size, 10, "incorrect no of follower questions")
    assert questions.all?{ |question| question.user_id = 1}, "Soe of the questions are not of follower."
  end

  test "check has_many topics association" do
    topics = questions(:published_question_1).topics
    assert_equal( topics.size, 2, "incorrect no of associated topics")
    assert topics.all?{ |topic| topic.questions.exists?(questions(:published_question_1).id)}, "Nott all topics have this question."
  end

  test "check has_many answers assocaiation" do
    answers = questions(:published_question_1).answers
    assert_equal(  answers.size, 2, "incorrect no of associated answers")
    assert answers.all?{ |answer| answer.question == questions(:published_question_1)}
  end

  test "check has many comments association" do
    comments = questions(:published_question_1).comments
    assert_equal( comments.size, 2, "incorrect no of associated comments")
    assert comments.all?{ |comment| comment.commentable == questions(:published_question_1)}
  end

  test "check notificatons association" do
    notifications = questions(:published_question_1).notifications
    assert_equal( notifications.size, 1, "incorrect no of notifications")
    assert notifications.all?{ |notification| notification.notifiable == questions(:published_question_1)}
  end

  test "credit transaction association test" do
    credit_transactions = questions(:published_question_1).credit_transactions
    assert_equal( credit_transactions.size, 2, "incorrect no of credit transactions")
    assert credit_transactions.all?{ |credit_transaction| credit_transaction.resource == questions(:published_question_1)}
  end

  test "check question belongs to user" do
    user = questions(:published_question_1).user
    assert_equal user, users(:insufficient_balance_user), "incorrect user"
  end

  test "check is to be published" do
    unpublished_question = questions(:unpublished_question)
    unpublished_question.published = true
    assert unpublished_question.is_to_be_published?, "is to unnpublished is returning  incorrect results."
  end

  test "check to_param for correct result" do
    question = questions(:published_question_1)
    assert_equal question.to_param , question.id.to_s + "-search-question-with-xyxy"
  end

  test "check for draft? method" do
    question  = questions(:unpublished_question)
    assert question.draft?
  end

  test "check get_topics_list method" do
    question = questions(:published_question_1)
    assert_equal question.get_topics_list, question.topics.map(&:name).join(',')
  end

  test "check question publish method" do
    question = questions(:unpublished_question)
    question.publish
    assert question.published?, "QUestion successfully published"
  end

  test "check question unppublish method" do
    question = questions(:published_question_1)
    question.unpublish
    assert question.draft?, "Question was not unpublished"
  end

  test "check not offensive" do
    question = questions(:published_question_1)
    assert question.not_offensive?
  end

  test "check offensive" do
    question = questions(:published_question_1)
    assert_not question.offensive?
  end

  test "check search for topic" do
    questions = Question.search_by_topic(1, Time.current - 2.days)
    assert_equal questions.size, 2, "Questions of different type or time have come"
    assert questions.all? { |question| question.topics.exists?(topics(:correct_topic_1).id)}
  end

  test "check search for question" do
    questions = Question.search_by_question(Time.current - 2.days, "xyxy")
    assert_equal questions.size, 3, "Questions of different search query or time have come"
    assert questions.all? { |question| question.title.match('xyxy')}
  end

  test "check for question and topic search" do
    questions = Question.search_by_topic_and_title(Time.current - 2.days, 1, "xyxy")
    assert_equal questions.size, 2, "Questions of different topic and size"
    assert questions.all? { |question| question.title.match('xyxy') && question.topics.exists?(topics(:correct_topic_1).id)}
  end

end
