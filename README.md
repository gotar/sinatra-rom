Sinatra-ROM
================

Simple app to intruduce how to use ROM with sinatra app.

How to run locally
------------------

1. Install ruby (check version in Gemfile):
2. Clone app repository:
3. Install gems:
    `$ bundle install`
4. Setup ENV data inside .env file

    ```
$ cat .env
SECRET=XXX
API_USER=XXX
API_PASSWORD=XXX
    ```

5. Check if all tests pass:
    `$ bundle exec rspec`
6. Run all backend apps
    `$ bundle exec rackup`

