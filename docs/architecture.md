---
layout: docs
title: Architecture
prev_section: installation
next_section: structure
---

batman.js is a stateful MVC framework based on Rails conventions used for building client-side single-page applications. That's a lot of buzzwords; let's break it down.

## 1. Model-View-Controller Architecture

Model-View-Controller (MVC) is a common way of dividing the responsibilities of your application. There are three main parts:

- Model: Represents the data of the system, possibly coming from a database or web API.
- View: Displays the data and layout to the user, and handles user interaction events.
- Controller: A fuzzily-defined piece of glue code that requests specific pieces of data from the model and renders specific views with that data.

Different frameworks and systems and languages will all implement MVC in slightly different ways, but the overall concepts are similar. When we're talking about batman.js, it borrows its MVC implementation heavily from both Rails and Cocoa.

Here's how the key components work specifically in batman.js:

#### 1.1 Models

Models are still responsible for getting all your data, but since we're a client side app, they'll load it via JSON from your API. It's worth noting that batman.js is more or less backend-agnostic. It doesn't really care what type of server you're using, as long as it responds to common REST API's with JSON (but you should still use Rails for maximum easiness).

[More About Models](/docs/models.html)

#### 1.2 Controllers

Like in Rails, a controller action gets called whenever a specific route gets triggered. For example, if a user accesses `/products/new`, the `new` method of your `ProductsController` will automatically be invoked. All you have to do is implement the correctly named method, wrangle the data that the view will need, and then tell batman.js which HTML file to render. Most of this is handled implicitly for you, as long as you're following the batman.js naming conventions.

[More About Controllers](/docs/controllers.html)

#### 1.3 HTML

Unlike in Rails, batman.js makes a distinction between HTML files and views. HTML files are the main way to get anything on screen. Developers and designers can both build vanilla HTML files and add extra `data-*` attributes to tell batman.js to bind a particular node to a particular piece of data. There's no extra templating language to learn, just a set of attributes.

[More About Bindings](/docs/bindings.html)

#### 1.4 Views

Views in batman.js are CoffeeScript subclasses of `Batman.View` that render a specific HTML file, prepare presentation data for that HTML file, and listen for user interaction from that HTML file. Most of the time, a view object will be automatically instantiated for you based on the controller action that is being rendered, but you can also create your own view classes to encapsulate pieces of view logic, e.g. a `MapView` for displaying a map. The view subsystem of batman.js is actually very similar to that of Cocoa's, so you get many of the same great API's that are available to Cocoa developers.

[More About Views](/docs/views.html)

## 2. Stateful Single-Page Application

One thing to keep in mind is that while a number of the API's may look very similar to Rails, your batman.js application is operating in an inherently different environment. When Rails receives a request, it starts the application, spawns a controller, calls the action, hits the database, returns the HTML, and then shuts the application back down. We say Rails is stateless because the only state persisted through requests is in the database.

batman.js has no concept of requests. The app is loaded once when the page is loaded, and then starts listening to events such as the URL changing or the user clicking around the application. The framework maps a number of these events to their Rails equivalent (such as a URL change event causes a controller action to be dispatched), but you do need to keep in mind that you are operating in a perpetual and non-ephemeral enviroment. Every variable that you assign to your controller is going to stay on that controller until it gets reassigned. Similarly, every view is going to stick around until you remove it from the view hierarchy.

We say batman.js is stateful because the entire app is constantly persisted in RAM until the user navigates away from the page. Keep this in mind when building your client-side application!
