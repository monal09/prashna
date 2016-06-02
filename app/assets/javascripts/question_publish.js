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

  $publish_button.on("ajax:success", function(event, data){
    updatePublishStatus(event, data, "publish");
  });

  $unpublish_button.on("ajax:success", function(event, data){
    updatePublishStatus(event, data, "unpublish");
  });

  function updatePublishStatus( event, data, event_name ){
    if(data.status === "failure"){
      var $all_errors = $('<div>');
      $("#modal-body").empty();
      $(data.errors).each(function(){
       var $error = $("<p>").text(this);
       $all_errors.append($error);
     });
     $all_errors.addClass("error-txt");
     $("#modal-body").append($all_errors);
     var error_message = getErrorMessage(event_name);
     $("h4.modal-title").html(error_message);
     $('#modal').modal();
    }else{
      var $target = $(event.target);
      showAndHide( $target, $target.siblings("a:first") );
      var $status_container = findStatusContainer( $(event.target) );
      if(event_name === "publish"){
        showAndHide(findPublishedStatusContainer($status_container), findUnpublishedStatusContainer($status_container) );
      }else{
        showAndHide( findUnpublishedStatusContainer($status_container), findPublishedStatusContainer($status_container) );
      }

    }
  }

  function getErrorMessage(event_name){
    if(event_name === "publish"){
      return "Can not publish question due to following reasons"
    }else{
      return "Can not unpublish question due to following reasons:"
    }
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
