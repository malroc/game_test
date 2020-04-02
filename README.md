# GameTest

## To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## To run tests:

  * Start test suite with `mix test`

## To build and run a release:

  * Install NPM dependencies with `npm install --prefix ./assets`
  * Compile assets with `npm run deploy --prefix ./assets`
  * Digest and compress static files with `mix phx.digest`
  * Build a release with ``SECRET_KEY_BASE=`mix phx.gen.secret` MIX_ENV=prod mix release --overwrite``
  * Run server with `_build/prod/rel/game_test/bin/game_test art`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# Deployed version

Available at [`game-test-2020.herokuapp.com`](https://game-test-2020.herokuapp.com)
