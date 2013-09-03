# Install batman-rails
c 'gemfile', ->
  @title "Welcome to Batman!"
  @say "Let's say you have a Rails app that talks to Rdio that you want to batman-ize."
  @say "First, add `gem batman-rails` to your Gemfile and press Cmd/Ctrl+S to save."
  @say "Note: this tutorial uses some features specific to batman-rails, but you can use batman.js with any backend."

  @focus '/Gemfile'

  @after "Great! Now we can use the batman.js generators."

# Generate batman app
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

  @after "There's our app! The generator puts all of our app files in app/assets/batman."


# Generate playlist scaffold
$ 'playlist', ->
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

# Encoders
c 'encoders', ->
  @title "Model Encoders"
  @say "First, we need to tell the batman.js model which properties to grab from the server."
  @say "Take a look in db/schema.rb to see which database columns a Playlist has."
  @say "Now add a corresponding `@encode` for each column to our playlist model."

  @focus '/app/assets/batman/models/playlist.js.coffee'

  @after "Next, let's set up some basic CRUD actions for a playlist."

c 'playlist_index', ->
  @title "List All Playlists"
  @say "First, let's grab all the playlists resources from the API."
  @say "Then we want to set them to an instance variable that we can access in the view."
  @say "Add `@set('playlists', Rdio.Playlist.get('all'))` to the `index` action."

  @focus '/app/assets/batman/controllers/playlists_controller.js.coffee'

  @after "All properties in batman.js are accessed with `get` and `set`. It's magic."
  @after "`Playlist.get('all')` will automatically send a GET request to /playlists.json."
  @after "But how does a user get to the index page in the first place?"

c 'routing', ->
  @title "Routing"
  @say "Every action in your controller needs to be mapped to by at least one URL, called a route."
  @say "batman.js uses a very similar routing syntax to Rails. Declare your routes in rdio.js.coffee."
  @say "The scaffold generator automatically adds an `@resource` route, a macro automatically adds four routes for all the default CRUD actions (index, show, edit, new) and maps them to your `PlaylistsController`."

  @focus '/app/assets/batman/rdio.js.coffee'

  @set('isComplete', true)

c 'first_binding', ->
  @title "Baby's First Binding"
  @say "A big chunk of the power of batman.js lies in its data bindings. You can use them"
  @say "to hook up your HTML to your model and app data, without writing glue code."
  @say "Add `data-bind=\"playlists.length\"` to the span in the h1 element."

  @focus '/app/assets/batman/html/playlists/index.html'

  @after "The span will automatically observe the length of the playlist array and update when it changes."
  @after "All data bindings start with `data-` and reference model or app data directly."
  @after "The most basic `data-bind` always updates the content or innerHTML of a node."

c 'showif_binding', ->
  @title "Show/Hide Bindings"
  @say "Oftentimes, you'll want to show or hide part of your page when data chances."
  @say "Let's add a blank slate for when there are 0 playlists."
  @say "Add `data-showif=\"playlists.empty\"` to the h3 element."

  @focus '/app/assets/batman/html/playlists/index.html'

  @after "The h3 will automatically observe the length of the playlist array and hide if there are more than 0 items."
  @after "`data-hideif` works exactly the same way, but with the condition in the opposite."
  @after "Ok, let's let the user add a new playlist."

###
# Storage adapter
c 'storage adapter', ->
  @title "Storage Adapters"
  @say "First, we need to tell batman.js how artists will communicate with our server."
  @say "batman.js ships with storage adapters for localStorage, REST servers, and more specifically, Rails."
  @say "Add `@persist Batman.RailsStorage` to `models/article.js.coffee`."

  @expect /@persist\s*Batman.RailsStorage/, in: 'models/article.js.coffee'

# Resource routes
title "Routing"
say "batman.js has a very similar syntax to Rails for defining your routes."
say "Because artists are a RESTful resource, we can use the `@resources` macro to automatically add all of the CRUD routes."
say "Add `@resources 'artists'` to `rdio.js.coffee`."

expect /@resources\s*'artists'/, in: 'rdio.js.coffee'

# Controller actions
title "Controller Actions"
say "Every URL in your routes file needs a corresponding action in a controller."
say "Just like with Rails, URL's are mapped to specific controller actions."
say "Actions are just functions on a controller object that take `params` as an argument."
say "Add `index`, `new`, and `show` to `controllers/artists_controller.js.coffee`."

expect /index:\s*\(params\)\s*->/, in: 'controllers/artists_controller.js.coffee'
expect /show:\s*\(params\)\s*->/, in: 'controllers/artists_controller.js.coffee'
expect /new:\s*\(params\)\s*->/, in: 'controllers/artists_controller.js.coffee'

# Index view
title "Data Bindings"
say "Take a moment to explore the batman directory, it's under `app/assets/batman`."
say "Now let's generate a resource for your batman.js application."
say "Run `rails generate batman:scaffold Artist` to make a new scaffold."

expect /rails\s*[g|generate]\s*batman:scaffold\s*Artist/

# Generate batman app
title "Great! Now let's generate our batman.js app."
say "batman-rails includes a number of Rails generators to make batman.js development easy."
say "Run `rails generate batman:app` to generate an empty batman.js app."

expect /rails\s*[g|generate]\s*batman:app/

# Generate artist scaffold
title "There's our app."
say "Take a moment to explore the batman directory, it's under `app/assets/batman`."
say "Now let's generate a resource for your batman.js application."
say "Run `rails generate batman:scaffold Artist` to make a new scaffold."

expect /rails\s*[g|generate]\s*batman:scaffold\s*Artist/
# Generate batman app
title "Great! Now let's generate our batman.js app."
say "batman-rails includes a number of Rails generators to make batman.js development easy."
say "Run `rails generate batman:app` to generate an empty batman.js app."

expect /rails\s*[g|generate]\s*batman:app/

# Generate artist scaffold
title "There's our app."
say "Take a moment to explore the batman directory, it's under `app/assets/batman`."
say "Now let's generate a resource for your batman.js application."
say "Run `rails generate batman:scaffold Artist` to make a new scaffold."

expect /rails\s*[g|generate]\s*batman:scaffold\s*Artist/
# Generate batman app
title "Great! Now let's generate our batman.js app."
say "batman-rails includes a number of Rails generators to make batman.js development easy."
say "Run `rails generate batman:app` to generate an empty batman.js app."

expect /rails\s*[g|generate]\s*batman:app/

# Generate artist scaffold
title "There's our app."
say "Take a moment to explore the batman directory, it's under `app/assets/batman`."
say "Now let's generate a resource for your batman.js application."
say "Run `rails generate batman:scaffold Artist` to make a new scaffold."

expect /rails\s*[g|generate]\s*batman:scaffold\s*Artist/
###
