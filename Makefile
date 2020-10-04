# info about docker build arguments
# https://docs.docker.com/engine/reference/commandline/build/


build:
	docker build -t ssacrist_project .

run:
	docker run -it -p 80:80 -p 443:443 ssacrist_project

list:
	docker ps -a
	docker images -a

fclean:
	docker system prune -a
