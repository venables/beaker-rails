Beaker
=====

A super barebones starter Rails 4 app, following current best practices

![Beaker](http://f.cl.ly/items/3G0Q3j3U1j462X1M2E0r/beaker.jpg)

Features/Dependencies
---------------------

* Authentication (using `has_secure_password`)
* User account management
* Forgot/reset password
* 100% code coverage

Using what?
-----------

* Database: PostgreSQL
* Testing: RSpec
* Views: Erb
* Stylesheets: SCSS
* Javascript: Coffeescript

Starting a new app
------------------

1. Clone this repo to your machine

  ```bash
  git clone https://github.com/venables/beaker.git your_app_name
  ```

2. Find and replace `Beaker` with `YourAppName`, and `beaker` with `your_app_name`. For example:

  ```bash
  find . | xargs perl -pi -e 's/Beaker/NewAppName/g'
  find . | xargs perl -pi -e 's/beaker/new_app_name/g'
  ```

3. Generate a new secret token **and put it in `./config/initializers/secret_token.rb`**

  ```bash
  rake secret
  ```

4. Pick a new foreman port in `bin/setup`

5. Delete everything in this README above `Get started`

Get started
-----------

```bash
./bin/setup
```

Run the server
--------------

```bash
foreman start
```
