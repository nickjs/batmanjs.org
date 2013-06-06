---
title: "Batman.js 0.9.0: The biggest thing since Killer Croc"
key: community
subkey: blog &mdash; 0.9.0 released
layout: default
author: Nick Small
use_wrapper: true
---

batman.js 0.9.0 is available on github and npm now, and packing some serious utility belt upgrades.

I don't want to be a milestone tease, but over the last several months we've started looking ahead to batman.js 1.0. The framework comes out of the work we're doing at Shopify on a major app, and this release comes from an extended period of us keeping our heads down to really start getting batman.js shaped up to ship with this application. We spent a lot of time focusing and polishing several key areas.

### Serious New Features

Another huge swath of bugs has been squashed and some great features added, so batman.js should be even extra easier to build awesome apps with. Here's a quick overview:

- brand new routing system using named routes
- polymorphic associations that act just like you'd expect in Rails
- much more thorough HTML5 support
- starting to make the view system more robust with things like appearance callbacks and auto-instantiation from bindings
- autoremoved event handlers through the `once` keyword (among other things, this helps to make view callbacks easier to implement)
- observable `SetUnion` and `SetIntersection` for easier binding to sets

As always, You can see the complete list in the [changelog](https://github.com/Shopify/batman/blob/master/CHANGELOG.md).

### Mythical Documentation

One of the biggest (and most requested) missing features of the framework is the not-unreasonable desire for real documentation. It's been a long time coming, but it's finally happening. The beautiful new documentation browser can be found at [http://batmanjs.org/docs/batman.html](http://batmanjs.org/docs/batman.html). While the docs are still incomplete, they currently cover about 50% of the framework, including the runtime and view components. They're certainly getting better every day as we touch more parts of the code, but it's now super simple to help out and contribute to the docs. Look, it's almost like it's a real framework!

![look at my docs, my docs are amazing](http://f.cl.ly/items/2F2f33241X3o2L3j0w3h/Screen%20Shot%202012-04-02%20at%202.42.58%20PM.png)

The mechanism with which the docs are generated is a new tool called [Percolate](https://github.com/Shopify/batman/blob/master/docs/percolate.coffee). We wanted to keep documentation separate from source code so that the barrier for entry for potential contributors is substantially lower, while still allowing the docs to have a close relationship with the code and always be up to date. Percolate is thus designed to essentially generate a docset with inline code examples by running the actual code like a unit test. You can setup Percolate templates and files with your natural language documentation and code blocks that contain small unit tests. When Percolate percolates your docs (ideally as part of your normal test runner), it will run these self-contained unit tests. If anything fails, you'll immediately know your docs are out of date. If everything goes better than expected, you'll have some pretty damned fancy looking docs.

### Performance

Another area batman.js has been lagging behind in since the days it existed in only my mind is all-around performance. Runtime performance, page load performance, and even test suite performance have all been lacking. For batman.js 0.9, we spent a LOT of time looking at these things and finding bountiful low hanging fruit to optimize. First, in order to help spot problem hotspots, we repurposed another Shopify internal tool as a benchmarking tool. The framework now includes a [benchmarking suite](https://github.com/Shopify/batman/tree/master/tests/prof/tests), the results of which get dumped into the Tiller reporting tool.

Using Tiller, we've been able to start cutting down on a number of bloated areas within the codebase. Things like custom Sets and Hashes were a serious drain on resources. I could start listing numbers, but I'll let the graph speak for itself:

![our super scientific batman.js performance graph](http://f.cl.ly/items/0d1Y3E0P361R1N3R2R2K/IMG_2097.JPG)

In any reasonable sized application, the results should be immediately noticeable. Actions should dispatch much faster, things should be more intelligently cached, and memory usage should be drastically lower. Of course, there's still and forever more work to be done in these aspects, and we look forward to doing a more in-depth writeup of the performance work as it continues.

### Compatibility

**TL;DR**

  - node 0.6.x compatibility
  - compatible with most **AMD module systems**
  - now works with closure compiler
  - numerous Rails and REST compatibility fixes, like datestamps and timezones and a better inflector

For batman.js to power the greatest applications, it needs to run on the latest tools. After figuring out some nasty dependency issues, I'm pleased to say that **batman.js is now compatible with node 0.6.x**. This comes mostly thanks to some intense work Harry has been doing on [qqunit](http://github.com/hornairs/qqunit), a new test runner library for node. It is similar to node-qunit in that it's designed to run your QUnit test suite in node, but it's a drastically simpler library without the multi-process shenanigans that make node-qunit so hard to debug.

![one happy test suite, running on node 0.6](http://f.cl.ly/items/0f0H1O3Z000C1D2Q0d36/qqunitresults.png)

## Thanks

Once again we'd like to thank the growing list of over 30 contributors who have put a lot of work into this release to make it fight as much crime as possible. batman.js is finally starting to shape up to something really worthy of being used in production applications. We know we'll be working hard to Make It So as we get ready to show off our own application. Aww, honey, the kids are really starting to grow up!

You can see the full diff for 0.9.0 on [Github](https://github.com/Shopify/batman/compare/v0.8.0...0.9.0). If you have any questions or run into any problems, feel free to post on the [mailing list](http://groups.google.com/group/batmanjs) or come hang out in IRC in #batmanjs on Freenode.

It takes about 10 seconds to get a bare app generated and running on localhost, so it's easy to [start exploring](/download.html). Take a look at the shiny new [documentation](/docs/batman.html) and [examples](/examples.html), build some cool stuff, and [tell us all about it](http://groups.google.com/group/batmanjs)! And of course, if you want to be a good soldier and kill some bugs yourself, you can help [solve some issues](http://github.com/Shopify/batman/issues).

#### &mdash; Love [Nick](http://twitter.com/nciagra), [James](http://twitter.com/jamesmacaulay), and [Harry](http://twitter.com/harrybrundage)
