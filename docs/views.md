---
layout: docs
title: Views
prev_section: bindings
next_section:
---

`Batman.View`s are the bridge between application state and user interaction.
They're responsible for rendering templates, handling bindings, and general
manipulation of the DOM. Most of the time, they'll be automatically created by
bindings within templates, but they can be manually manipulated as well.


## The View Hierarchy

Views are organized as a rooted tree structure, similar to that of Cocoa. Each
view keeps track of its parent (`superview`) and its direct children
(`subviews`). The root of the tree is referred to as the *layout view*, which
is responsible for the document's `<html>` node. There is one layout view per
`App`.


### Views as data contexts

The view tree is also used to organize data in a hierarchical way, similar to
variable scoping works in a language like JavaScript. Properties of a view are
accessible to its entire subtree, making it an ideal way to store data relevant to part of the DOM.

Whenever you create a binding with `data-bind` or similar, the tree is traversed to locate the specified
keypath (via `[View::lookupKeypath]`). The lookup follows this chain:

current view → chain of superviews → layout view → active controller → app →
window

[View::lookupKeypath]: /docs/api/12_Batman.View.html#something


## Custom Views

Views are useful for creating reusable, configurable components which can be
instantiated from within templates.

`<examples go here>`

## Lifecycle

As a view is manipulated by the application, it progresses through states. As
it does this, it fires events that you can hook into:

- `viewWillAppear`: Fired when the view is about to be attached to the DOM. It
  will always have a superview.
- `viewDidAppear`: Fired when the view has just been attached to the DOM. Its
  node is on the page, and could be selected with `document.querySelector`.
- `viewWillDisappear`: Fired when the view is about to be detached from the
  DOM. It will still have a superview set.
- `viewDidDisappear`: Fired when the view has just been detached from the DOM.
  Its node is no longer part of the page, and may not be selected from the
document. If it was removed directly it will not have a superview, and if an
ancestor was removed it will still have a superview.
- `viewDidMoveToSuperview`: Fired when the superview property is changed to a
  valid view, regardless of whether that superview is in the DOM or not.
- `viewWillRemoveFromSuperview`: Fired when the subview is going to be removed
  from its superview, regardless of whether that superview is in the DOM or
not.
- `viewDidLoad`: After `loadView` has been successfully called, the div has
  been created and populated with HTML from the `HTMLStore`.
- `ready`: All bindings have been initialized (one shot).


## Backing Views

Some of the more complex bindings will create a new `View` (or many) to allow
them to manage the DOM. Such views are called *backing views*. For example,
using `data-foreach` will create a backing view for each item being iterated
over, containing a reference to the item for that iteration.


## Loading Views

Views are not parsed or added to the DOM when they're first constructed.
Instead, they're lazily loaded when you perform certain operations on them.

- If a view is in the DOM, adding to its subview set will cause the subview and
  its entire subtree to be added to the DOM. Removing a subview will
automatically remove it from the DOM.

