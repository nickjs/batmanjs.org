---
layout: docs
title: Installation
prev_section: structure
next_section: configuration
---

We've tried to make batman.js's installation process as simple as possible. There's two main ways to go about it: using the `batman-rails` gem or downloading the Starter Package.

## 1. batman-rails

`batman-rails` is a Ruby Gem which allows you to easily use batman.js inside a Rails 3.2 or 4.0 application. It takes care of a number of things for you:

- Vendoring the batman.js source into your app
- Generating your project structure within your Rails app
- Setting up JSON communication between your Rails and batman.js app

#### 1.1 Get the Gem

Getting the gem is simple. Simply add the following line to your `Gemfile`:

{% highlight ruby %}
gem 'batman-rails'
{% endhighlight %}

Then simply tell `bundler` to install it:

{% highlight bash %}
$ bundle install
{% endhighlight %}

#### 1.2 Create a batman.js application

Now that `batman-rails` is installed, we can use the normal Rails generator system to generate the skeleton for our batman.js application.

{% highlight bash %}
$ rails generate batman:app
{% endhighlight %}

The structure of this app will be exactly the same as described in [Directory Structure](/docs/structure.html), but it will live within our Rails app folder. You can find your newly created app in `MyApp/app/assets/batman`.

## 2. Starter Application

If you're not using Rails, you can [download](/download.html) either the Starter Application or simply a copy of batman.js itself. The Starter Application is simply a zip file which contains an empty batman.js project, very similar to what `batman-rails` would generate for you. It will contain all of the directories your project needs (described further in [Directory Structure](/docs/structure.html)), in addition to the actual batman.js source.


You can simply download the zip and start filling it with your own application code.

## 3. That's it!

Whichever way you choose, that's all there is to it!
