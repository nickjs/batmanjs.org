---
layout: docs
title: Testing
prev_section: architecture
---

## 1. Introduction to Testing

Testing is core to any great software product and `Batman.Testing` aims to make testing easy in Batman. `Batman.TestCase` and its subclasses are light-weight wrappers around [QUnit](http://qunitjs.com/) and [Sinon.JS](http://sinonjs.org) libraries with the goal of making testing your JS MVC application part of your day to day practices.

## 2. Testing with `Batman.TestCase`

`Batman.TestCase` is the base class all of your Batman App's tests will derive from. `TestCase` provides a simple API of common assertions you'll want to perform in your tests.  In most cases, these methods are simple wrappers around their QUnit equivalents but with a focus on making it easy for Rails developers to write these tests.  The testing assertions are modeled after Ruby's [Test::Unit](http://ruby-doc.org/stdlib-2.0/libdoc/test/unit/rdoc/Test/Unit.html), bringing in line expectations for expectation and actual assertion values as well as method signatures.

#### 2.1 Class setup

To create a basic Batman test, simple create a new class that extends from `Batman.TestCase`.

{% highlight coffeescript %}
class SimpleTest extends Batman.TestCase
  @test 'A simple test', ->
    @assert true
{% endhighlight %}

#### 2.2 Setup and Teardown

All Batman.TestCase tests are given `setup` and `teardown` methods that are called before each test is run. Use these methods for initializing test data or resetting values that may persist between tests.

{% highlight coffeescript %}
class SimpleTest extends Batman.TestCase
  setup: ->
    @foo = new Batman.Object(bar: 'Hello')

  teardown: ->
    window.badExample = false

  @test 'A simple assertion', ->
    @assertEqual true
    window.badExample = true

  @test 'No bad examples', ->
    @assert !window.badExample
{% endhighlight %}

#### 2.3 Assertions

`Batman.TestCase` comes with a set of basic assertions that Ruby `Test::Unit` users will be familiar with:

`assert(bool, [msg])`: Ensures the expression is `true`

`assertEqual(expected, actual, [msg])`: Ensures that `expected` is [deepEqual](http://api.qunitjs.com/deepEqual) to `actual`

`assetNotEqual(expected, actual, [msg])`: Ensures that `expected` is [notDeepEqual] (http://api.qunitjs.com/notDeepEqual) to `actual`

`assertMatch(expected, actual, [msg])`: Ensures that `expected:Regex` matches `actual:String`.

`assertNoMatch(expected, actual, [msg])`: Ensures that `expected:Regex` does not match `actual:String`.

`assertDifference(expressions, difference = 1, [message], callback)`: Ensures that the set of `expressions` (single, or `Array`) have a delta of `difference` after the `callback` is executed.

`assertNoDifference(expressions, difference = 1, [message], callback)`: Ensures that the set of `expressions` (single, or `Array`) have no delta after the `callback` is executed.

`assertRaises(exception, callback)`: Ensures that an exception of type `exception` is raised during the executing of the `callback`.

#### 2.4 Async tests

If your tests are asynchronous, you can control the flow of them with the `continue` and `wait` functions. These are simple wrappers over QUnit's `start` and `stop` methods.

{% highlight coffeescript %}
class SimpleTest extends Batman.TestCase
  @test 'something asynchronous', ->
    setTimeout =>
      @testCase.assert true
      @testCase.continue()

    @testCase.wait()
{% endhighlight %}

#### 2.5 Running your tests

Batman.TestCase `test` methods simply wrap `QUnit`'s existing `test` method. In order to run your tests, instantiate an instance of your `Batman.TestCase` and call `runTests`. This will add a new `QUnit.module` with your given test class name and queue all tests in the class into `QUnit`'s test runner.

{% highlight coffeescript %}
test = new SimpleTest
test.runTests()
{% endhighlight %}

## 3. Unit testing your Models

To create a unit test for a `Batman.Model` in your app, create a test class that extends `Batman.ModelTestCase`.

{% highlight coffeescript %}
class App.PostsTest extends Batman.ModelTestCase
{% endhighlight %}

Everything available to `Batman.TestCase` will be included in your `Batman.ModelTestCase` as well as additional, Model specific assertions and helper functions.

#### 3.1 Batman.ModelTestCase specific assertions

`assertValid: (model, [msg])`: Ensures the given model has no Batman validation errors

`assertNotValid: (model, [msg])`: Ensures the given model has Batman validation errors

`assertDecoders: (modelClass, keys...)`: Ensures the given model class has a set of decoders equal to the `keys` specified.

`assertEncoders: (modelClass, keys....)`: Ensures the given model class has a set of encoders equal to the `keys` specified.

`assertEncoded: (model, key, expected)`: Ensures the given `model` encodes the `key` property with a value equal to the `expected` value.

#### 3.2 Fixtures

There is currently no fixture framework included with `Batman.ModelTestCase` however a simple fixture approach can be achieved by defining simple POJOs in this manner:

{% highlight coffeescript %}
Fixtures.Posts =
  newPost:
    id: 1
    title: "Hello world!"
    handle: "new-post"
    body: "Hello to all those people."
{% endhighlight %}

and using them in your test classes.

{% highlight coffeescript %}
class App.PostsTest extends Batman.ModelTestCase
  setup: ->
    @post = App.Post.createFromJSON(Fixtures.Posts.newPost)

  @test: ->
    @assertEqual "Hello world!", @post.get('title')
{% endhighlight %}

#### 3.3 A few examples

{% highlight coffeescript %}
class App.Post extends Batman.Model
  @encode 'title', 'body'

  @encode 'handle',
    decode: (val) -> 'post-' + val
    encode: (val) -> val.slice(5)

  @validate 'title', presence: true

class App.PostTest extends Batman.ModelTestCase
  setup: ->
    @post = App.Post.createFromJSON(Fixtures.Posts.newPost)

  @test "has proper decoders", ->
    @assertDecoders App.Post, 'id', 'title', 'body', 'handle'

  @test "has proper encoders", ->
    @assertEncoders App.Post 'title', 'body', 'handle'

  @test "custom handle decoder adds 'post-' prefix", ->
    @assertEqual @post.get('post-new-post')

  @test "custom handle encoder removes 'post-' prefix", ->
    @assertEncoded @post, 'handle', 'new-post'

  @test "title can't be blank", ->
    @post.unset 'title'
    @assertNotValid @post
{% endhighlight %}

## 4. Functional tests for your Controllers
More to come. Currently you can use a combination of Sinon.JS and `Batman.TestCase` to add functional tests to your controllers. A `Batman.ControllerTestCase` is on the way.
