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
