# ProtoRails

## Summary

In a feat of metaprogramming I recreated the core functionality of ActiveRecord and ActionController, the base classes for Ruby on Rails Models and Controllers, respectively. With my lite version of Rails, you can create a basic website with associations, flash, and even user auth.

Not that I would recommend using my version over the real thing just yet.

## How to use

Start up the server by running bin/run.rb.

Some test models and controllers have been implemented. Try visiting /pants and adding a new pant or shoe or two.

Macros for creating your own models and controllers from the command line, just like 'rails g' do, are coming soon! For now, you just have to add to the routes.rb file, and inherit from SQLObject and ApplicationController (in place of ActiveRecord and ControllerBase, respectively). Most else should work as expected.

## Check out in particular

- sql_object.rb
- controller_base.rb
- route.rb
- router.rb
- db_connection.rb

These are the power files.
