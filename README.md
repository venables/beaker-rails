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

1. Rename the app files:

    ```
    find . | xargs perl -pi -e 's/Beaker/NewAppName/g'
    find . | xargs perl -pi -e 's/beaker/new_app_name/g'
    ```

2. Generate a new secret token and put it in `./config/initializers/secret_token.rb`

    ```
    rake secret
    ```

3. Pick a new foreman port in `bin/setup`

Get started
-----------

    ./bin/setup

Run the server
--------------

    foreman start
