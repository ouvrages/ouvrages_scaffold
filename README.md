# Ouvrages Scaffold

Rails generators that produce HAML views to be used with Bootstrap and Cancan.

## Installation

Add this line to your application's Gemfile:

    gem 'ouvrages_scaffold'

And then execute:

    bundle

Or install it yourself as:

    gem install ouvrages_scaffold

## Usage

First generate your model with Rails and migrate:

    rails g model Post title:string body:text
    rake db:migrate

Then generate the scaffold with:

    rails g ouvrages:scaffold Post

You can also run the generators individually:

    rails g ouvrages:controller Post
    rails g ouvrages:routes Post
    rails g ouvrages:views Post

If you want to change the model and regenerate the scaffold, you must update the database and call the generator again (you only need to update the views):

    rails g migration AddActiveToPost active:boolean
    rake db:migrate
    rails g ouvrages:views Post
    
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
