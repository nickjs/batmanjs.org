# Install batman-rails
c 'gemfile', ->
  @title "Welcome to Batman!"
  @say "Let's say you have a Rails app that talks to Rdio that you want to batman-ize."
  @say "First, add `batman-rails` to your Gemfile and press Cmd/Ctrl+S to save."

  @focus '/Gemfile'

  @after "Great! Now we can use batman.js"

# Generate batman app
$ 'appgen', ->
  @title "App Generator"
  @say "batman-rails includes a number of Rails generators to make batman.js development easy."
  @say "Run `rails generate batman:app` to generate an empty batman.js app."

  @expect /rails\s+[g|generate]\s+batman:app/, """
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

  @after "There's our app! Take a moment to explore `app/assets/batman`."


# Generate playlist scaffold
$ 'playlist', ->
  @title "Scaffold Generator"
  @say "Now let's generate a resource for your batman.js application."
  @say "Run `rails generate batman:scaffold Playlist` to make a new scaffold."

  @expect /rails\s+[g|generate]\s+batman:scaffold\s+[Pp]laylist/

  @after "Great, check it out in `app/assets/batman/controllers/playlist`."

###
# Storage adapter
title "Storage Adapters"
say "First, we need to tell batman.js how artists will communicate with our server."
say "batman.js ships with storage adapters for localStorage, REST servers, and more specifically, Rails."
say "Add `@persist Batman.RailsStorage` to `models/article.js.coffee`."

expect /@persist\s*Batman.RailsStorage/, in: 'models/article.js.coffee'

# Encoders
title "Encoders"
say "Now, batman.js needs to know which properties to grab from the server."
say "We use `@encode` to specify which properties we care about."
say "Add `@encode 'name', "

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
