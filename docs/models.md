---
layout: docs
title: Models
prev_section: controllers
next_section: bindings
---

`Batman.Model` is responsible for representing data in your application and
providing a fluid interface for communicating with your backend app.

_Note_: This documentation uses the term _model_ to refer to the class `Model`
or a `Model` subclass, and the term _record_ to refer to one instance of a
model.


## Defining a Model

Models are defined by creating subclasses of `Batman.Model`. Things like
encoders, validations, and storage adapters will be inherited by deep
subclasses, so you can subclass your own models to extend their functionality.

{% highlight coffeescript %}
class MyApp.Product extends Batman.Model
  @encode 'title', 'description', 'price'

class MyApp.Subscription extends MyApp.Product
  # Subscription inherits the encoders from Product.
  @encode 'period'
{% endhighlight %}


### Defining Data

Model attributes are defined with _encoders_. These are directives that tell
batman.js to load certain keys, and parse them in a certain way.


## Talking to the Backend


### Storage Adapters

`Batman.Model` alone only defines the logic surrounding loading and saving, but
not the actual mechanism for doing so. This is left to a
`Batman.StorageAdapter` subclass, and batman.js comes with a few common ones:

 1. `Batman.LocalStorage` for storing data in [local storage][], if available.
 2. `Batman.SessionStorage` for storing data in [session storage][], if available.
 3. `Batman.RestStorage` for using RESTful HTTP (GET, POST, PUT, and DELETE) to store data in a backend app.
 4. `Batman.RailsStorage` which extends `Batman.RestStorage` with some handy Rails-specific functionality like parsing out validation errors.

[local storage]: https://developer.mozilla.org/en-US/docs/Web/Guide/API/DOM/Storage#localStorage
[session storage]: https://developer.mozilla.org/en-US/docs/Web/Guide/API/DOM/Storage#sessionStorage


### The Asynchronous Nature of the World

`Batman.Model`'s operations on both the class and instance level are
asynchronous. Functions that load or save data all accept callbacks as the last
argument, and will only call them once the operation has completed. Completion
occurs only when the data has been processed, for example with `RestStorage`
this will happen when the entire HTTP response has been received from the
server.

These callbacks follow the Node.js convention for their signatures. The first
argument is a possible error: if it is truthy, an error has occurred, and if it
is falsy, the operation was successful. Successive arguments represent the
result of the operation, such as the set of records fetched.


### The Identity Map

batman.js uses an identity map for fetching and storing records, which is
essentially an in-memory cache of model instances. If you use `Model.find`
twice to fetch a record with the same ID, you'll get back the same (`===`)
instance both times, which means a backend record is only ever represented by a
single client-side record. This is useful for ensuring any state the instance
might have is preserved for every piece of code asking for it, and bindings to
the instance are kept synchronized when any piece of code updates the model.

Practically, the identity map is an implementation detail on the framework's
side that developers shouldn't need to interact with directly, but knowing you
have "one true instance" is helpful when reasoning about an application.

