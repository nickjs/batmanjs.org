$(function() {
  var isLoading = false;

  $(".code-editor").click(function(){
    if (!isLoading) {
      isLoading = true;
      $('.try-it-live').html('Loading...');

      setTimeout(function(){
        $.getScript('lib/dist/batman.jquery.js')
        $.getScript('lib/extras/batman.rails.js')
        $.getScript('lib/codemirror.js')
        $.getScript('lib/modes/coffeescript.js')
        $.getScript('lib/modes/ruby.js')
        $('<link rel="stylesheet" href="css/codemirror.css" />').appendTo('head')
        $('<link rel="stylesheet" href="css/solarized.css" />').appendTo('head')

        $.getScript('js/try.js', function() {
          $(".intro").addClass('expanded').css({height:920});
        });
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
