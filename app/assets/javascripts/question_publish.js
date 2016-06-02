// FIXME_AB: remove duplicacy
$(document).ready(function() {

  $(".spinner").hide();

  var $publish_button = $("[data-behavior=publish]");
  var $unpublish_button = $("[data-behavior=unpublish]");

  $("[data-behavior=publish], [data-behavior=unpublish]").on("ajax:before", function(){
    $(this).siblings("div:last").show();
  });

  $("[data-behavior=publish], [data-behavior=unpublish]").on("ajax:complete", function(){
    $(this).siblings("div:last").hide();
  });

  $publish_button.on("ajax:success", function(event, data, status, xhr) {

   if(failureDataStatus(data)){
     
     var $all_errors = $('<div>');
     $("#modal-body").empty();
     $(data.errors).each(function(){
       var $error = $("<p>").text(this);
       $all_errors.append($error);
     });
     $all_errors.addClass("error-txt");
     $("#modal-body").append($all_errors);
     $("h4.modal-title").html("Can not publish question due to following reasons:");

     $('#modal').modal();

   }
   else{
     var $target = $(event.target);
     showAndHide( $target, $target.siblings("a:first") );
     var $status_container = findStatusContainer( $(event.target) );
     showAndHide(findPublishedStatusContainer($status_container), findUnpublishedStatusContainer($status_container) );
   }
  });

  $unpublish_button.on("ajax:success", function(event, data, status, xhr) {
   if(failureDataStatus()){
     var $message = $("<div>")
     var $error = $("<p>").text("Failed to unpublish. Please retry.");
     $message.append($error);
     $("#modal-body").append($message);
     $('#modal').modal();


   }else{
     var $target = $(event.target);
     showAndHide( $target, $target.prev("a") );
     var $status_container = findStatusContainer( $(event.target) );
     showAndHide( findUnpublishedStatusContainer($status_container), findPublishedStatusContainer($status_container) );

     }
  });

  function failureDataStatus(data){
    if(data.status === "failure"){
      return true;
    }
    return false;

  }

  function showAndHide($first, $second){
    $first.addClass("hidden");
    $second.removeClass("hidden");
  }

  function findStatusContainer($container){
    return $container.parents("td:first").prev("td");
  }

  function findPublishedStatusContainer($container){
    return $container.children().first("a");
  }

  function findUnpublishedStatusContainer($container){
    return $container.children().last("a");
  }

 });
