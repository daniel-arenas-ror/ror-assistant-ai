
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
