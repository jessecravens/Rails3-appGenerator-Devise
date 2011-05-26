# JSLib Application Generator Template
# Generates a Rails app; includes JavaScript Library of choice, Haml, RSpec, Cucumber, WebRat, Factory Girl ...

puts "Generating a new Rails app using a JavaScript Library of choice"

#----------------------------------------------------------------------------
# Create the database
#----------------------------------------------------------------------------
puts "creating the database..."
run 'rake db:create:all'

#----------------------------------------------------------------------------
# GIT
#----------------------------------------------------------------------------
puts "setting up 'git'"

append_file '.gitignore' do <<-FILE
'.DS_Store'
'.rvmrc'
FILE
end
git :init
git :add => '.'
git :commit => "-m 'Initial Commit of JSLib Rails App'"

#----------------------------------------------------------------------------
# Remove files
#----------------------------------------------------------------------------
puts "removing files..."
run 'rm public/index.html'
run 'rm public/favicon.ico'
run 'rm public/images/rails.png'
run 'rm README'
run 'touch README'

puts "banning spiders from your site by changing robots.txt..."
gsub_file 'public/robots.txt', /# User-Agent/, 'User-Agent'
gsub_file 'public/robots.txt', /# Disallow/, 'Disallow'

#----------------------------------------------------------------------------
# Haml 
#----------------------------------------------------------------------------
  puts "setting up Gemfile for Haml..."
  append_file 'Gemfile', "\n# Bundle gems needed for Haml\n"
  gem 'haml', '3.0.18'
  gem 'haml-rails', '0.2', :group => :development
  
  # the following gems are used to generate Devise views for Haml
  gem 'hpricot', '0.8.2', :group => :development
  gem 'ruby_parser', '2.0.5', :group => :development
  

#----------------------------------------------------------------------------
# Configure
#----------------------------------------------------------------------------

if yes?('Do you want to remove the Prototype/Scriptaculous javascript library? (yes/no)')
  proto_flag = true
else
  proto_flag = false
end

if yes?('Would you like to use the latest JQuery javascript library? (yes/no)')
  jquery_flag = true
  app_title = "JQuery App"
else
  jquery_flag = false
end

if yes?('What about JQuery UI tools? (yes/no)')
  jqueryuitools_flag = true
  app_title = "JQuery UI Tools App"
else
  jqueryuitools_flag = false
end

if yes?('Would you like to use the YUI3 javascript library ? (yes/no)')
  yui_flag = true
  app_title = "YUI3 App"
else
  yui_flag = false
end

if yes?('Include YUI3 CSS Framwework? (yes/no)')
  yuiCSS_flag = true
else
  yuiCSS_flag = false
end

if yes?('Include YUI3 Test? (yes/no)')
  yuiTest_flag = true
else
  yuiTest_flag = false
end

if yes?('Would you like to use the Raphael javascript library? (yes/no)')
  raphael_flag = true
  app_title = "Raphael App"
else
  raphael_flag = false
end

if yes?('Would you like to use the Cufon font replacement? (yes/no)')
  cufon_flag = true
else
  cufon_flag = false
end

if yes?('Would you like Devise authorization and a logon view generated? (yes/no)')
  devise_flag = true
else
  devise_flag = false
end


#----------------------------------------------------------------------------
# Set up a JavaScript Library of choice
#----------------------------------------------------------------------------

# Remove Prototype
if proto_flag
  puts "replacing Prototype witha JavaScript Library of your choice."
  run 'rm public/javascripts/controls.js'
  run 'rm public/javascripts/dragdrop.js'
  run 'rm public/javascripts/effects.js'
  run 'rm public/javascripts/prototype.js'
  run 'rm public/javascripts/rails.js'
end

# Add JQuery
if jquery_flag
  get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js",  "public/javascripts/latest-jquery.js"
end

# Add JQuery UI tools
if jqueryuitools_flag
  get "http://cdn.jquerytools.org/1.2.5/form/jquery.tools.min.js",  "public/javascripts/latest-jqueryuitools.js"
end

# Add YUI3
if yui_flag
  get "http://yui.yahooapis.com/combo?3.3.0/build/yui/yui-debug.js",  "public/javascripts/yui-debug.js"
end

if yuiCSS_flag
  get "http://yui.yahooapis.com/3.3.0/build/cssreset/reset.css",  "public/stylesheets/reset.css"
  get "http://yui.yahooapis.com/3.3.0/build/cssbase/base.css",  "public/stylesheets/base.css"
  get "http://yui.yahooapis.com/3.3.0/build/cssfonts/fonts.css",  "public/stylesheets/fonts.css"
  get "http://yui.yahooapis.com/3.3.0/build/cssgrids/grids.css",  "public/stylesheets/grids.css"
end

# Add Raphael
if raphael_flag
  get "http://jscdn.net/raphael.js",  "public/javascripts/raphael.js"
end

# Add Cufon
if cufon_flag
  get "http://jscdn.net/cufon.js",  "public/javascripts/cufon.js"
end


#----------------------------------------------------------------------------
# Create a home controller and an index view
#----------------------------------------------------------------------------
puts "create a home controller and view"
generate(:controller, "home index")
gsub_file 'config/routes.rb', /get \"home\/index\"/, 'root :to => "home#index"'

# remove the generated application file
run 'rm app/views/home/index.html.haml'

create_file 'app/views/home/index.html.haml'do <<-FILE
%div{:class => "container", :id => "container"}
FILE
end

if yuiTest_flag
append_file 'app/views/home/index.html.haml'do <<-FILE
%div{:id => "testLogger"}
FILE
end
end

# append_file 'app/views/home/index.html.haml' do <<-'FILE'
# - @users.each do |user|
# %p User: #{link_to user.email, user}
# FILE
# end

gsub_file 'config/routes.rb', /get \"home\/index\"/, 'root :to => "home#index"'

puts "set up Devise"
gsub_file 'app/controllers/home_controller.rb', /def index/ do
<<-RUBY
def index
    @users = User.all
RUBY
end 

#----------------------------------------------------------------------------
# Generate Application Layout
#----------------------------------------------------------------------------

run 'rm app/views/layouts/application.html.erb'
create_file 'app/views/layouts/application.html.haml' do <<-FILE
!!!
%html
  %head
FILE
end

  # if yui_flag
  #   append_file 'app/views/layouts/application.html.haml' do <<-FILE
  #     %title YUI3 App
  #   FILE
  #   end
  # elseif jquery_flag
  #   append_file 'app/views/layouts/application.html.haml' do <<-FILE
  #     %title JQuery App
  #   FILE
  #   end
  # elseif jqueryuitools_flag
  #     append_file 'app/views/layouts/application.html.haml' do <<-FILE
  #       %title JQuery UI Tools App
  #   FILE
  #   end
  # elseif raphael_flag
  #   append_file 'app/views/layouts/application.html.haml' do <<-FILE
  #     %title Raphael and JQuery App
  #   FILE
  #   end
  # else      
  #   append_file 'app/views/layouts/application.html.haml' do <<-FILE
  #     %title Default Rails App
  #   FILE
  #   end
  # end
    
append_file 'app/views/layouts/application.html.haml' do <<-FILE
    %title JSLib Devise app
    = stylesheet_link_tag "reset"
    = stylesheet_link_tag "base"
    = stylesheet_link_tag "fonts"
    = stylesheet_link_tag "grids"
    = stylesheet_link_tag "application"
    = javascript_include_tag :all
    = csrf_meta_tag
FILE
end
  
if yuiCSS_flag
append_file 'app/views/layouts/application.html.haml' do <<-FILE
  %body{:class =>"yui3-skin-sam  yui-skin-sam"}
FILE
end
else
append_file 'app/views/layouts/application.html.haml' do <<-FILE
  %body
FILE
end  
end

if devise_flag
append_file 'app/views/layouts/application.html.haml' do <<-FILE
    %ul.hmenu
      = render 'devise/menu/registration_items'
      = render 'devise/menu/login_items'
    %p{:style => "color: green"}= notice
    %p{:style => "color: red"}= alert
FILE
end  
end

append_file 'app/views/layouts/application.html.haml' do <<-FILE
    = yield
FILE
end

#----------------------------------------------------------------------------
# Add Stylesheets
#----------------------------------------------------------------------------

create_file 'public/stylesheets/application.css' do <<-FILE
# application.css
FILE
end


if yuiCSS_flag
append_file 'public/stylesheets/application.css' do <<-FILE
div.container {
width: 100%;
height: 100px; 
padding: 10px;
margin: 10px;
border: 1px solid red;
}

#testLogger {
margin-bottom: 1em;
}

#testLogger .yui3-console .yui3-console-title {
border: 0 none;
color: #000;
font-size: 13px;
font-weight: bold;
margin: 0;
text-transform: none;
}
#testLogger .yui3-console .yui3-console-entry-meta {
margin: 0;
}

.yui3-skin-sam .yui3-console-entry-pass .yui3-console-entry-cat {
background: #070;
color: #fff;
}

FILE
end
end

if devise_flag
append_file 'public/stylesheets/application.css' do <<-FILE
ul.hmenu {
list-style: none;	
margin: 0 0 2em;
padding: 0;
}

ul.hmenu li {
display: inline;  
}
FILE
end
end

#----------------------------------------------------------------------------
# Initialize YUI and add YUI Test
#----------------------------------------------------------------------------

if yui_flag
  if yuiTest_flag
    append_file 'public/javascripts/application.js' do <<-FILE
  
      YUI({ filter: 'raw' }).use("node", "console", "test",function (Y) {

          Y.namespace("example.test");

          Y.example.test.DataTestCase = new Y.Test.Case({

              //name of the test case - if not provided, one is auto-generated
              name : "Data Tests",

              //---------------------------------------------------------------------
              // setUp and tearDown methods - optional
              //---------------------------------------------------------------------

              /*
               * Sets up data that is needed by each test.
               */
              setUp : function () {
                  this.data = {
                      name: "test",
                      year: 2007,
                      beta: true
                  };
              },

              /*
               * Cleans up everything that was created by setUp().
               */
              tearDown : function () {
                  delete this.data;
              },

              //---------------------------------------------------------------------
              // Test methods - names must begin with "test"
              //---------------------------------------------------------------------

              testName : function () {
                  var Assert = Y.Assert;

                  Assert.isObject(this.data);
                  Assert.isString(this.data.name);
                  Assert.areEqual("test", this.data.name);            
              },

              testYear : function () {
                  var Assert = Y.Assert;

                  Assert.isObject(this.data);
                  Assert.isNumber(this.data.year);
                  Assert.areEqual(2007, this.data.year);            
              },

              testBeta : function () {
                  var Assert = Y.Assert;

                  Assert.isObject(this.data);
                  Assert.isBoolean(this.data.beta);
                  Assert.isTrue(this.data.beta);
              }

          });

          Y.example.test.ArrayTestCase = new Y.Test.Case({

              //name of the test case - if not provided, one is auto-generated
              name : "Array Tests",

              //---------------------------------------------------------------------
              // setUp and tearDown methods - optional
              //---------------------------------------------------------------------

              /*
               * Sets up data that is needed by each test.
               */
              setUp : function () {
                  this.data = [0,1,2,3,4]
              },

              /*
               * Cleans up everything that was created by setUp().
               */
              tearDown : function () {
                  delete this.data;
              },

              //---------------------------------------------------------------------
              // Test methods - names must begin with "test"
              //---------------------------------------------------------------------

              testPop : function () {
                  var Assert = Y.Assert;

                  var value = this.data.pop();

                  Assert.areEqual(4, this.data.length);
                  Assert.areEqual(4, value);            
              },        

              testPush : function () {
                  var Assert = Y.Assert;

                  this.data.push(5);

                  Assert.areEqual(6, this.data.length);
                  Assert.areEqual(5, this.data[5]);            
              },

              testSplice : function () {
                  var Assert = Y.Assert;

                  this.data.splice(2, 1, 6, 7);

                  Assert.areEqual(6, this.data.length);
                  Assert.areEqual(6, this.data[2]);           
                  Assert.areEqual(7, this.data[3]);           
              }

          });    

          Y.example.test.ExampleSuite = new Y.Test.Suite("Example Suite");
          Y.example.test.ExampleSuite.add(Y.example.test.DataTestCase);
          Y.example.test.ExampleSuite.add(Y.example.test.ArrayTestCase);

          //create the console
          var r = new Y.Console({
              newestOnTop : false,
              style: 'block' // to anchor in the example content
          });

          r.render('#testLogger');

          Y.Test.Runner.add(Y.example.test.ExampleSuite);

          //run the tests
          Y.Test.Runner.run();

      });

    FILE
    end
  end
end



#----------------------------------------------------------------------------
# Set up Devise
#----------------------------------------------------------------------------
puts "setting up Gemfile for Devise..."
append_file 'Gemfile', "\n# Bundle gem needed for Devise\n"
gem 'devise', '>= 1.1.3'

puts "installing Devise gem (takes a few minutes!)..."
run 'bundle install'

puts "creating 'config/initializers/devise.rb' Devise configuration file..."
run 'rails generate devise:install'
run 'rails generate devise:views'

puts "modifying environment configuration files for Devise..."
gsub_file 'config/environments/development.rb', /# Don't care if the mailer can't send/, '### ActionMailer Config'
gsub_file 'config/environments/development.rb', /config.action_mailer.raise_delivery_errors = false/ do
  <<-RUBY
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
    # A dummy setup for development - no deliveries, but logged
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = false
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default :charset => "utf-8"
  RUBY
  end
gsub_file 'config/environments/production.rb', /config.i18n.fallbacks = true/ do
  <<-RUBY
    config.i18n.fallbacks = true
    config.action_mailer.default_url_options = { :host => 'yourhost.com' }
  
    ### ActionMailer Config
    # Setup for production - deliveries, no errors raised
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.default :charset => "utf-8"
  RUBY
  end

puts "creating a User model and modifying routes for Devise..."
run 'rails generate devise User'
run 'rake db:migrate'


#----------------------------------------------------------------------------
# Continue with Devise set up: Add a user controller and views 
#----------------------------------------------------------------------------
generate(:controller, "users show")
gsub_file 'config/routes.rb', /get \"users\/show\"/, '#get \"users\/show\"'
gsub_file 'config/routes.rb', /devise_for :users/ do
<<-RUBY
devise_for :users
  resources :users, :only => :show
RUBY
end

gsub_file 'app/controllers/users_controller.rb', /def show/ do
<<-RUBY
before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])
RUBY
end

run 'rm app/views/users/show.html.haml'
# we have to use single-quote-style-heredoc to avoid interpolation
create_file 'app/views/users/show.html.haml' do <<-'FILE'
%p
  User: #{@user.email}
  FILE
  end

# create a partial for devise views
create_file "app/views/devise/menu/_login_items.html.haml" do <<-'FILE'
- if user_signed_in?
  %li
    = link_to('Logout', destroy_user_session_path)
- else
  %li
    = link_to('Login', new_user_session_path)
  FILE
  end
  
# create a partial for devise views
create_file "app/views/devise/menu/_registration_items.html.haml" do <<-'FILE'
- if user_signed_in?
  %li
    = link_to('Edit account', edit_user_registration_path)
- else
  %li
    = link_to('Sign up', new_user_registration_path)
  FILE
  end
#----------------------------------------------------------------------------
# Create a default user
#----------------------------------------------------------------------------
puts "creating a default user"
append_file 'db/seeds.rb' do <<-FILE
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :email => 'user@test.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created'
FILE
end
run 'rake db:seed'

#----------------------------------------------------------------------------
# Setup RSpec & Cucumber
#----------------------------------------------------------------------------
puts 'Setting up RSpec, Cucumber, webrat, factory_girl, faker'
append_file 'Gemfile' do <<-FILE
group :development, :test do
  gem "rspec-rails", ">= 2.0.1"
  gem "cucumber-rails", ">= 0.3.2"
  gem "webrat", ">= 0.7.2.beta.2"
  gem "factory_girl_rails"
  gem "faker"
end
FILE
end

run 'bundle install'
run 'script/rails generate rspec:install'
run 'script/rails generate cucumber:install'
run 'rake db:migrate'
run 'rake db:test:prepare'

run 'touch spec/factories.rb'
#----------------------------------------------------------------------------
# Finish up
#----------------------------------------------------------------------------
puts "Commiting to Git repository..."
git :add => '.'
git :commit => "-am 'Setup Complete'"

puts "DONE - setting up your custom JSlib/Devise Rails App."
