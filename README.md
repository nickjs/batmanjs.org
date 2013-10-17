batmanjs.github.io
==================

http://batmanjs.org


## Running locally

batmanjs.org is run on GitHub pages, and uses Jekyll.
To test your changes locally, `gem install jekyll` and `jekyll serve`, then check out http://localhost:4000.

## Generating the API documentation

The API docs are generated from a set of literate CoffeeScript files in the main batman.js repository.
To generate them yourself, make sure you've cloned the main repo, and execute the following command from within your copy of the `batmanjs.github.io` repo.

```bash
cd batmanjs.github.io # or wherever you keep it
npm install # if you haven't installed the dependencies before
bin/generate_docs --dir <path to the main batman.js repo>/docs
```
