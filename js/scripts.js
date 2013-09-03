$(function() {
  var isLoading = false;

  $(".code-editor").click(function(){
    if (!isLoading) {
      isLoading = true;
      $('.try-it-live').html('Loading...');

      setTimeout(function(){
        // uses requre.js
        // jklawl that would be so smrt
        $.getScript('lib/dist/batman.jquery.js', function() {
          $.getScript('lib/extras/batman.rails.js', function() {
            $.getScript('js/try.js', function() {
              $(".intro").addClass('expanded').css({height:920});
            })
          })
        })

        $.getScript('lib/codemirror.js', function() {
          $.getScript('lib/modes/coffeescript.js')
          $.getScript('lib/modes/ruby.js')
          $.getScript('lib/modes/htmlmixed.js')
        })

        $('<link rel="stylesheet" href="css/codemirror.css" />').appendTo('head')
        $('<link rel="stylesheet" href="css/solarized.css" />').appendTo('head')
      }, 0);
    }
  });

  $(".code-editor").hover(function(){
    if(!$('.intro').hasClass('expanded')) {
      $(".intro").css({height:402});
    }
  },function(){
    if(!$('.intro').hasClass('expanded')) {
      $(".intro").css({height:382});
    }
  });
});
