function Comment(container) {
  this.$container = container;
  this.$comments = container.find("[data-behavior=new_comment_link]");
  this.$commentModal = $('#comment-modal');
  this.$commentForm = this.$commentModal.find("#new_comment");
  this.$userCommentBox = $("#comment_comment");
  this.$errorBox = this.$commentForm.find("#errors_div");

}

Comment.prototype.submitCommentForm = function(event, data) {
  
  if( data.status == "success"){
    var $comment = $("<blockquote>");
    var $contentBox = $("<p>");
    var $commentorsDetailBox = $("<small>");
    var $commentModal = $("#comment-modal");
  
    $contentBox.text(data.comment);
    $commentorsDetailBox.text("by " + data.user_name);
    $comment.append($contentBox, $commentorsDetailBox);
  
    $commentModal.modal("toggle");
  
    var resourceType = "[data-resourcetype=" + data.commentable_type + "]";
    var resourceId = "[data-resourceid=" + data.commentable_id + "]";
  
    $answer = $(resourceType + resourceId);
    $commentBox = $answer.parent().siblings("[data-behavior=comments]");
    $commentBox.append($comment);
  }else{
     this.$errorBox.html(data.errors);
  }

}

Comment.prototype.showCommentForm = function(event, data) {

  var $target = $(event.target);
  var type = $target.data("resourcetype");
  var type_id = $target.data("resourceid");
  this.$userCommentBox.val("");
  var $commentableType = this.$commentModal.find("#comment_commentable_type");
  var $commentableId = this.$commentModal.find("#comment_commentable_id");
  
  $commentableType.val(type);
  $commentableId.val(type_id);
  this.$commentModal.modal();

}

Comment.prototype.init = function() {
  var _this = this;

  this.$commentForm.on("ajax:success", function(event, data) {
    _this.submitCommentForm(event, data);
  });

  this.$comments.on("ajax:success", function(event, data) {
    _this.showCommentForm(event, data);
  });
}

$(document.ready = function() {
  var questionContainer = new Comment($("[data-behavior=question]"));
  questionContainer.init();
});