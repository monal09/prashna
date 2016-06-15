$(function() {
  setTimeout(updateQuestions, 10000);
});

function updateQuestions() {
  var $questionsContainer = $("[data-behavior=questionsContainer]");
  var lastUploadTime = $questionsContainer.data("time");
  var filter = $questionsContainer.data("filter");
  var target = $questionsContainer.data("target");

  $.ajax({
    url: target,
    type: "POST",
    data: {
      time: lastUploadTime,
      filter: filter
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