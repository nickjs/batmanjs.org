---
layout: docs
title: Controllers
prev_section: configuration
next_section: models
---

`Batman.Controller` is the C in MVC. It works with the routing system to implicitly instantiate controller objects and dispatch their actions. After the router determines which action to dispatch based on the request parameters, it is your controller's job to make sense of the request, prepare the data to display, and finally render the view. batman.js includes a number of utilities to make all of these tasks straightforward. In this guide, we'll look at how the routing system works, followed by the most important API's that `Batman.Controller` provides.

## 1. Routing

The purpose of the router (a `Batman.Navigator` instance) is to listen to URL change events from the browser, parse them, and call the appropriate controller action. This is similar to

#### 1.1 Declaring routes with `@route`

#### 1.2 REST

#### 1.3 `@resources`

#### 1.4 `data-route`
