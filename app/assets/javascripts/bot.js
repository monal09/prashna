$(document).ready(function(){
  $('#search').on('click', function(event) {
    $.ajax({
      url: '/bot_response',
      type: 'json',
      method: 'get',
      data: { query: $("[data-behavior=query]").val() },
      success: function(data) {
        $('.bot-response').removeClass('hide');
        $('#display-response').html(data['response']);
        $("[data-behavior=query]").val('');
      }
    });
  });
});
