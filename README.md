
## install vip

You must install vips to manages images

https://www.libvips.org/install.html


# Start postgres

docker compose up -d postgres

check readlines

´´´
docker compose ps
docker compose logs -f postgres
´´´

## Create DB

bin/rails db:create

bin/rails db:migrate


# Run redis
redis-server

# Install yarn to precompile
brew install yarn

# npm
npm install --save-dev sass esbuild
npm install

# or with yarn:
yarn add --dev sass esbuild
yarn install

## Compile CSS and Javascript
rails assets:precompile

## Login ad admin

http://localhost:3000/admin/login

you must login as a normal user, and after that got to with an adminAccount

http://localhost:3000/admin/users

### Populate custom configuration

rails populate:custom_options

## Run Stripe Test

Create stripe account 

### Install stripe CLI

Check Stripe DOC [here](https://docs.stripe.com/stripe-cli/install)

brew install stripe/stripe-cli/stripe

run to start listening events

stripe listen --forward-to localhost:4242/webhook

source ~/.zshrc
