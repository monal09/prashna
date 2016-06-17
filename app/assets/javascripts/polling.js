$(function() {
  setTimeout(updateQuestions, 10000);
});

function updateQuestions() {
  var $questionsContainer = $("[data-behavior=questionsContainer]");
  var lastUploadTime = $questionsContainer.data("time");
  var target = $questionsContainer.data("target");
  var filterQuestionParams = $questionsContainer.data("filterquestionparams");
  var filterTopicParams = $questionsContainer.data("filtertopicparams");

  $.ajax({
    url: target,
    type: "POST",
    data: {
      time: lastUploadTime,
      questionparams: filterQuestionParams,
      topicparams: filterTopicParams
    },
    success: function(data) {
      if (data.newQuestions > 0) {
        var $newQuestionsNotification = $("[data-behavior=questionsNotification]");
        var $notification = $newQuestionsNotification.find("[data-behavior=newQuestionCount]")
        var questionText = data.newQuestions > 1 ? "questions have" : "question has";
        $notification.text(data.newQuestions + " new " + questionText + " been posted.");
        $newQuestionsNotification.removeClass("hidden");
      }
    }
  });

  setTimeout(updateQuestions, 10000);
}