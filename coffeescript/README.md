Compile CoffeeScript
=====================

Install the compiler with

	npm install coffee-script -g

And compile with

	coffee game.coffee

The generated game.js is used to execute the program in the browser.

Test with node.js
=====================

Install the jasmine-node plugin from https://github.com/mhevery/jasmine-node

	npm install jasmine-node -g

And execute:

	jasmine-node --coffee .

Any test source matching the pattern \*.spec.coffee will be executed. There is no need to compile the CoffeeScript files with this method.
