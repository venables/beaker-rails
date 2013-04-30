Beaker
=====

A barebones starter Rails 4 app

![Beaker](http://f.cl.ly/items/3G0Q3j3U1j462X1M2E0r/beaker.jpg)

Features/Dependencies
---------------------

* Authentication (using `has_secure_password`)
* User account management
* Forgot/reset password
* 100% code coverage

Using what?
-----------

* Database: Postgresql
* Testing: RSpec
* Views: HAML
* Stylesheets: SCSS
* Javascript: Coffeescript

Starting a new app
------------------

1. Find and replace `Beaker` with `YourAppName`

2. Find and replace `beaker` with `your_app_name`

3. Generate a new secret token and put it in `./config/initializers/secret_token.rb`

    ```
    rake secret
    ```

4. Pick a new foreman port in `bin/setup`

Get started
-----------

    ./bin/setup

Run the server
--------------

    foreman start
