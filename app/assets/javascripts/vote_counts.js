function VoteCount(container) {
	this.$container = container;
	// this.$upvoteDownvoteSymbol = container.find("[data-behavior=upvoteSymbol], [data-behavior=downvoteSymbol]");
}

VoteCount.prototype.init = function() {
	var _this = this;
	this.$container.on("ajax:success", "[data-behavior=upvoteSymbol], [data-behavior=downvoteSymbol]",  function(event, data) {
		if (data.status === "failure") {
			_this.displayErrors($(data.errors))		
		} else {
			_this.updateVotes( $(event.target), data.upvote_count, data.downvote_count);
		}
	});
}

VoteCount.prototype.displayErrors = function($errors){
	var $all_errors = $('<div>');
			$("#modal-body").empty();
			$errors.each(function() {
				var $error = $("<p>").text(this);
				$all_errors.append($error);
			});
			$all_errors.addClass("error-txt");
			$("#modal-body").append($all_errors);
			var error_message = "Your vote could not be casted";
			$("h4.modal-title").html(error_message);
			$('#modal').modal();
}

VoteCount.prototype.updateVotes = function($target, upvotes, downvotes) {
	var $upvoteCountDisplay = $target.siblings("[data-behavior=voteCount]").find("[data-behavior=upvoteCount]");
	var $downvoteCountDisplay = $target.siblings("[data-behavior=voteCount]").find("[data-behavior=downvoteCount]");
	$upvoteCountDisplay.html("Upvotes: " + upvotes);
	$downvoteCountDisplay.html("Downvotes: " + downvotes);
}

$(document.ready = function() {
	var voteCount = new VoteCount($("[data-behavior=question]"));
	voteCount.init();
});