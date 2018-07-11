# fabrictest
Suppose You have set up the fabric environment. You can follow the steps to write a new fabric network.

0. `docker rm -f $(docker ps -aq)`

1. `chmod +x startFabric.sh`

2. `sh startFabric.sh`

3. `COMPOSE_PROJECT_NAME=fabrictest docker-compose -f docker-compose.yaml up -d`

4. `docker exec -it cli bash`

5. Then you can follow `code.txt` to run the command step by step.


