c 'gemfile', ->
  @title "Welcome to batman.js!"
  @say "Let's say you have a Rails app that talks to Rdio that you want to batman-ize."
  @say "First, add `gem 'batman-rails'` to your Gemfile and press Cmd/Ctrl+S to save."
  @say "Note: this tutorial uses some features specific to batman-rails, but you can use batman.js with any backend."

  @focus '/Gemfile'

  @after "Great! Now we can use the batman.js generators."

$ 'appgen', ['/app/controllers/batman_controller.rb', '/app/views/layouts/batman.html.erb', '/app/assets/batman'], ->
  @title "App Generator"
  @say "batman-rails includes a number of Rails generators to make batman.js development easy."
  @say "Run `rails generate batman:app` to generate an empty batman.js app."

  @expect /rails\s+(g|generate)\s+batman:app/, """
  create  app/controllers/batman_controller.rb
  create  app/views/layouts/batman.html.erb
  insert  config/routes.rb
  create  app/assets/batman/rdio.js.coffee
  create  app/assets/batman/models
  create  app/assets/batman/models/.gitkeep
  create  app/assets/batman/views
  create  app/assets/batman/views/.gitkeep
  create  app/assets/batman/controllers
  create  app/assets/batman/controllers/.gitkeep
  create  app/assets/batman/html
  create  app/assets/batman/html/.gitkeep
  create  app/assets/batman/lib
  create  app/assets/batman/lib/.gitkeep
  create  app/assets/batman/html/main
  create  app/assets/batman/controllers/application_controller.js.coffee
  create  app/assets/batman/controllers/main_controller.js.coffee
  create  app/assets/batman/html/main/index.html
 prepend  app/assets/batman/rdio.js.coffee
 prepend  app/assets/batman/rdio.js.coffee
 prepend  app/assets/batman/rdio.js.coffee
 prepend  app/assets/batman/rdio.js.coffee
  """

  @after "There's our app! The generator puts all of our app files in `app/assets/batman`."

c 'look_around_app', ->
  @title "App Generator"
  @enableLaunchAppButton()

  @say "Take a look around the generated app in `app/assets/batman`."
  @say "Press the Launch App button to preview your app as you write code."
  @say "It's pretty empty now, just some text fields that automatically update"
  @say "data and other UI within the app. The preview will automatically reload"
  @say "whenever you save changes to a file with Ctrl/Cmd+S."

  @focus '/app/assets/batman/html/main/index.html'

  @complete()

$ 'playlist', ['/app/assets/batman/controllers/playlists_controller.js.coffee', '/app/assets/batman/models/playlist.js.coffee', '/app/assets/batman/views/playlists', '/app/assets/batman/html/playlists'], ->
  @title "Scaffold Generator"
  @say "Our Rails app already has a JSON API for managing a Playlist resource."
  @say "Let's generate a corresponding resource for the batman.js side."
  @say "Run `rails generate batman:scaffold Playlist` to make a new scaffold."

  @expect /rails\s+(g|generate)\s+batman:scaffold\s+[Pp]laylist/, """
  generate  batman:model Playlist
    create  app/assets/batman/models/playlist.js.coffee
  generate  batman:controller playlists index show edit new create update destroy
    create  app/assets/batman/controllers/playlists_controller.js.coffee
  generate  batman:html playlists index show edit new
    create  app/assets/batman/html/playlists
    create  app/assets/batman/html/playlists/index.html
    create  app/assets/batman/html/playlists/show.html
    create  app/assets/batman/html/playlists/edit.html
    create  app/assets/batman/html/playlists/new.html
  generate  batman:view  playlists index show edit new
    create  app/assets/batman/views/playlists
    create  app/assets/batman/views/playlists/playlists_index_view.js.coffee
    create  app/assets/batman/views/playlists/playlists_show_view.js.coffee
    create  app/assets/batman/views/playlists/playlists_edit_view.js.coffee
    create  app/assets/batman/views/playlists/playlists_new_view.js.coffee
    insert  app/assets/batman/rdio.js.coffee
  """

  @after "The scaffold generator sets up a controller, model, and empty views for a playlist resource."

c 'look_around_playlist', ->
  @title "Scaffold Generator"
  @say "Look around the generated Playlist scaffold. You'll find files in"
  @say "`controllers`, `models`, and `html`. It won't do much yet, but we've added"
  @say "some basic HTML. Try clicking the `Playlists` link in the preview window."

  @focus '/app/assets/batman/html/playlists/index.html'
  @reloadPreview()

  @complete()

c 'routing', ->
  @title "Routing"
  @say "Notice that clicking on that link took you to a new URL and a new controller within your app."
  @say "Every action in your controller needs to be mapped to by at least one URL, called a route."
  @say "batman.js uses a very similar routing syntax to Rails. Declare your routes in `rdio.js.coffee`."
  @say "For a simple first task, try changing the `root` route (what will be matched by `/`) to point to"
  @say "`playlists#index` instead of `main#index`. This represents the index action of playlists controller."

  @focus '/app/assets/batman/rdio.js.coffee'

  @after "Note that the scaffold generator automatically adds an `@resource` route, which is a"
  @after "macro that automatically adds four routes for all of the default CRUD actions (index,"
  @after "show, edit, new) and maps them to a corresponding action in your `PlaylistsController`."

c 'playlist_index', ->
  @title "List All Playlists"
  @say "First, let's grab all the playlists resources from the API and store them in"
  @say "an instance variable on our controller that we can access from the view."
  @say "Add `@set('playlists', Rdio.Playlist.get('all'))` to the `index` action."

  @focus '/app/assets/batman/controllers/playlists_controller.js.coffee'

  @after "All properties in batman.js are accessed with `get` and `set`. It's magic."
  @after "`Playlist.get('all')` will automatically send a GET request to /playlists.json."
  @after "Now let's show the user how many playlists are stored on the server."

c 'first_binding', ->
  @title "Baby's First Binding"
  @say "A big chunk of the power of batman.js lies in its data bindings. You can use them"
  @say "to hook up your HTML to your model and app data, without writing glue code."
  @say "Add `data-bind=\"playlists.length\"` to the `span` inside the `h1` element."

  @focus '/app/assets/batman/html/playlists/index.html'

  @after "The span will automatically observe the length of the playlist array and update when it changes."
  @after "All data bindings start with `data-*` and reference model or app data directly."
  @after "The most basic `data-bind` always updates the value or innerHTML of a node."

c 'showif_binding', ->
  @title "Show/Hide Bindings"
  @say "Oftentimes, you'll want to show or hide part of your page when data changes."
  @say "Let's add a blank slate for when there are 0 playlists."
  @say "Add `data-showif=\"playlists.isEmpty\"` to the `h3` element."

  @focus '/app/assets/batman/html/playlists/index.html'

  @after "The `h3` will automatically observe the length of the playlist array and hide if"
  @after "there are more than 0 items. `data-hideif` works exactly the same way, but hides"
  @after "the node instead of shows it. Ok, now let's actually show all the playlists."

c 'foreach_binding', ->
  @title "For Each Bindings"
  @say "Another common task is iterating over a set of data that may change. Try adding"
  @say "`data-foreach-list=\"playlists\"` to the `li` node and `data-bind=\"list.name\"` to its"
  @say "inner `span`. This says for each `list` in `playlists`, copy this `li` and assign `list` to it."

  @focus '/app/assets/batman/html/playlists/index.html'

  @after "This node will be cloned for every iteration of the set of playlists."
  @after "Every cloned node has access to the iteration property, which in this"
  @after "case, is what we called `list`. But hmm, still nothing shows up..."

c 'encoders', ->
  @title "Model Encoders"
  @say "We need to tell the batman.js model which properties to grab from the server."
  @say "Take a look in `db/schema.rb` to see which database columns a Playlist has."
  @say "Now add a corresponding `@encode` for each column to our playlist model."
  @say "Hint: You can use a single `@encode` for multiple properties on the same line."

  @focus '/app/assets/batman/models/playlist.js.coffee'

  @after "Awesome, the list works! Now, let's show the icon for the playlist."

c 'attribute_binding', ->
  @title "Attribute Bindings"
  @say "Another type of binding, similar to the original `data-bind` content binding is"
  @say "the attribute binding. Instead of just the node's content, you can bind any of"
  @say "the node's attributes. Add `data-bind-src=\"list.icon\"` to the `img` tag."

  @focus '/app/assets/batman/html/playlists/index.html'

  @after "Any valid HTML attribute can be bound and autoupdated simply by doing"
  @after "`data-bind-[attribute]`. Set `id`s, `class` names, `src`s, `disabled`s, etc."
  @after "Finally, let's set up some links to other routes in our app."

c 'route_bindings', ->
  @title "Route Bindings"
  @say "Let's look at one more type of binding to navigate around our app. `data-route`"
  @say "takes three types of arguments. A manual URL as a string, a named route, or a resource."
  @say "Add `data-route=\"routes.playlists.new\"` (named route) to the `a` tag for New Playlist."
  @say "Add `data-route=\"playlist\"` (resource route) to the `a` tag in the playlist `li`."

  @focus '/app/assets/batman/html/playlists/index.html'

  @after "`data-route` automatically handles all the interaction for links and buttons."
  @after "It will handle pushState if the user's browser supports it and manages URL's in"
  @after "exactly the way you'd expect. That means we don't break back or forward buttons,"
  @after "bookmarkable URL's, or anything else people like to complain about."

c 'fast_forward', ['/app/assets/batman/models/track.js.coffee', '/app/assets/batman/models/album.js.coffee'], ->
  @title "Intermission"
  @say "We've filled in some more of the app for you so we can look at more"
  @say "interesting things. Feel free to take a minute to click through the code."

  @focus '/app/assets/batman/controllers/playlists_controller.js.coffee'

  @complete()

$ 'generate_player_view', ['/app/assets/batman/html/player', '/app/assets/batman/views/player_view.js.coffee'], ->
  @title "Custom Views"
  @say "Let's generate a custom view for the Rdio player."
  @say "Run `rails generate batman:view player`."

  @expect /rails\s+(g|generate)\s+batman:view\s+player/, """
  create  app/assets/batman/views/player_view.js.coffee
  """

  @after "Great, we have a simple view file."

c 'view_source', ->
  @title "Custom View Sources"
  @say "First we have to tell our custom view where to find its HTML."
  @say "Specify the view's `source` property as `player/main`."

  @focus '/app/assets/batman/views/player_view.js.coffee'

  @after "Check it out, that's a nice looking player!"

c 'viewDidAppear', ->
  @title "Custom View Events"
  @say "You can define special events on a view class that will be called"
  @say "at various points in the view's lifecycle. Here, `viewDidAppear`"
  @say "will be called whenever the view appears in the DOM for the first time."
  @say "We use it to implement custom logic, jQuery, and event handlers."

  @complete()

c 'fin', ->
  @title "Looking Back"
  @say "Well shit amigo, that's a pretty slick looking Rdio playlist manager."
  @say "You should have a bit of a better idea of what it's like to develop with"
  @say "batman.js now, but feel free to poke around the <a href=\"http://github.com/batmanjs/batman-rdio\">Rdio app</a> on GitHub a bit more."
  @completeAllSteps()