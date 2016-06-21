function NotificationProcessor(container) {
  this.$container = container;
  this.$notification_count_display = container.find("[data-behavior=notification_count]");
}

NotificationProcessor.prototype.init = function() {
  var _this = this;
  this.$container.on("ajax:success", function(event, data) {
    if (data.status == "success") {
      _this.$notification_count_display.text("");  
    }else{
    }
  });
}

$(document.ready = function() {
  var notificationContainer = new NotificationProcessor($("[data-behavior=notification]"));
  notificationContainer.init();
});
