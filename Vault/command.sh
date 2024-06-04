docker-compose -f docker-compose.yml up -d
docker exec -it vault vault opreator init
docker exec -it vault vault operator unseal
docker exec -it vault vault status