$(function() {
  var isLoading = false;

  var getScripts = function(urls, callback) {
    var contents = {};
    var i, url, count = urls.length, requestCount = count;

    var evalScripts = function() {
      for (var i = 0; i < count; i++) {
        url = urls[i];
        if (url.charAt(0) !== '!') eval(contents[url]);
      }

      if (callback) callback(contents);
    };

    var scriptCallback = function(url) {
      return function(content) {
        contents[url] = content;
        if (--requestCount === 0) evalScripts();
      };
    };

    for (i = 0; i < count; i++) {
      url = urls[i];
      if (url.charAt(0) === '!') url = url.substr(1);

      $.ajax({url: url, dataType: 'text', success: scriptCallback(url)});
    }
  };

  $(".code-editor").click(function(){
    if (!isLoading) {
      isLoading = true;
      $('.try-it-live').html('Loading...');

      // uses requre.js
      // jklawl that would be too smrt

      dependencies = [
        'lib/dist/batman.jquery.js', 'lib/extras/batman.rails.js',
        'lib/codemirror.js', 'lib/modes/coffeescript.js', 'lib/modes/ruby.js', 'lib/modes/javascript.js', 'lib/modes/css.js',
        'lib/modes/xml.js', 'lib/modes/htmlmixed.js', 'lib/modes/htmlembedded.js',
        'js/try.js', '!js/tutorial.js'
      ]

      getScripts(dependencies, function(contents) {
        Try.initializeTutorial(contents['js/tutorial.js'], function() {
          $(".intro").addClass('expanded').css({height:920});
        });
      });

      $('<link rel="stylesheet" href="css/codemirror.css" />').appendTo('head')
      $('<link rel="stylesheet" href="css/solarized.css" />').appendTo('head')
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
