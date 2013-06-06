---
layout: docs
title: Directory Structure
prev_section: usage
next_section: configuration
---

One of the conventions that batman.js shares with Rails is that of a consistent and organized directory structure. Whenever you sit down at any batman.js or Rails project, you should immediately know in which folder and file any given class will live. Here's what the directory structure looks like for a default batman.js app:

{% highlight bash %}
MyApp
├── index.html
├── my_app.coffee
├── controllers
|   ├── application_controller.coffee
|   └── products_controller.coffee
├── models
|   └── product.coffee
├── html
|   └── products
|       ├── index.html
|       ├── show.html
|       └── new.html
├── views
|   └── products
|       ├── products_index_view.coffee
|       ├── products_show_view.coffee
|       └── products_new_view.coffee
├── lib
|   └── my_helper.coffee
├── vendor
|   ├── jquery.js
|   └── batman.js
└── resources
{% endhighlight %}

An overview of what each of these does:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>File / Directory</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>index.html</code></p>
      </td>
      <td>
        <p>

          The browser's entry point for your application. Your index file should include everything in <code>vendor</code> (like batman.js), have enough of your layout HTML so that the browser can display something immediately, and then load <code>my_app.coffee</code>.

        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>my_app.coffee</code></p>
      </td>
      <td>
        <p>

          The main entry point for your application. It should include everything else in your app directory (like <code>controllers</code> and <code>models</code>), declare all the routes that your application will handle, do any other initial setup or preloading, and finally call <code>App.run()</code>.

        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>controllers</code></p>
      </td>
      <td>
        <p>

          Holds all of your controller classes. Every controller should represent exactly one resource or model or type of data in your system. Another way of looking at it is every page or piece of distinct functionality can have its own controller. Controller names should be the plural of their resource type followed by the word "Controller", i.e. <code>MyApp.ProductsController</code>. File names should be the snake-cased version of the class name, i.e. <code>products_controller.coffee</code>.

        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>models</code></p>
      </td>
      <td>
        <p>

          Holds all of your model classes. Every model should also represent exactly one resource. Model names should be the singular of their resource type, i.e. <code>MyApp.Product</code>. File names should be the snake-cased version of the class name, i.e. <code>product.coffee</code>.

        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>html</code></p>
      </td>
      <td>
        <p>

          Holds the individual blocks of HTML that will be rendered when a controller action is dispatched. The HTML directory is further subdivided into directories for every controller. Inside every controller directory is an HTML file with the name of the corresponding action, i.e. <code>products/index.html</code>.

        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>views</code></p>
      </td>
      <td>
        <p>

          Holds your custom CoffeeScript view classes that can either be rendered implicitly or explicitly by your app. Follows a similar naming convention to the HTML files, but the class names are ControllerName + ActionName + View, i.e. <code>MyApp.ProductsIndexView</code>.

        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>lib</code></p>
      </td>
      <td>
        <p>

          A dumping ground for all the other little snippets of code your app collects. Things like helpers, mixins, events, or plugins can all be safely left in lib.

        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>vendor</code></p>
      </td>
      <td>
        <p>

          All of the external dependencies that your app has, such as batman.js, jQuery, or jQuery plugins if you're using those.

        </p>
      </td>
    </tr>

    <tr>
      <td>
        <p><code>resources</code></p>
      </td>
      <td>
        <p>

          A convenient place to leave things like images and css files.

        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>
