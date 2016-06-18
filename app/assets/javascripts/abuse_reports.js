function AbuseReport(container) {
  this.$container = container;
  this.$report_abuse_link = container.find("[data-behavior=abuse_report]");
}

AbuseReport.prototype.init = function() {
  this.$container.on("ajax:success", "[data-behavior=abuse_report]", function(event, data) {
    if (data.status == "success") {
      var $parentContainer = $(event.target).parents("[data-behavior=report_abuse_container]");
      $(event.target).remove();
      var $reportedText = $("<p>").text("Marked Abuse").addClass("text-danger");
      $parentContainer.append($reportedText);
    }else{
      window.alert("Could not be marked offensive. Try later");
    }
  });
}

$(document.ready = function() {
  var questionContainer = new AbuseReport($("[data-behavior=question]"));
  questionContainer.init();
});