
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



## Compile CSS and Javascript
rails assets:precompile
