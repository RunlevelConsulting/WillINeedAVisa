$('#select-nationality').on('change', function(){
  if($('#select-nationality').val() != null) {
    var currentSelection=$('#select-nationality').val()
    $('#select-destination option').show();
    $("#select-destination option[value=" + currentSelection + "]").hide();
  } else {
    $('#select-destination option').show();
  }
});


$('#select-nationality, #select-destination').on('change', function(){
  if($('#select-nationality').val() != null && $('#select-destination').val() != null) {

    // Animation
    $('p.divider').addClass('hide').css('opacity','0');

    setTimeout(function(){
      $('.cloud').css({
        opacity: '1',
        transition: '2.0s',
      });
    }, 1000);

    setTimeout(function(){
      $('.animated-plane').css({
        opacity: '1',
        transition: '1.0s',
        'margin-left': '-25px'
      });
    }, 1500);

    // Change Document Title
    var fromCountryName=$('#select-nationality option:selected').text();
    var toCountryName=$('#select-destination option:selected').text();
    document.title = "Will I Need A Visa? | " + fromCountryName + " to " + toCountryName;

    // AJAX
    var fromId=$('#select-nationality').val();
    var toId=$('#select-destination').val();

    var ajax_getResult = $.ajax({url: "result.inc.php", type: "GET", data: {
      ajax_request: true,
      fromId: fromId,
      toId: toId
    }, dataType: "html"});

    ajax_getResult.fail(function(jqXHR, textStatus) {
      alert("Unable to submit! Are you still connected to the internet?");
    });

    ajax_getResult.done(function(ajaxResult) {
      $('#search-result').hide().html(ajaxResult).fadeIn(400);
    });
  }
});

