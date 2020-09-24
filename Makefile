# info about docker build arguments
# https://docs.docker.com/engine/reference/commandline/build/
# --rm              Remove intermediate containers after a successful build
# -t                name the new image
# --detach , -d     Run container in background and print container ID
# --publish , -p    Publish a container’s port(s) to the host
# --env , -e        Set environment variables

build:
	docker build -t img_project .

run:
	docker run -it -p 80:80 -p 443:443 img_project

index_off:
	docker run \
	--env "AUTOINDEX=no" \
	--rm -d -p 80:80 -p 443:443 \
	--name ft_server \
	img_server

exec:
	docker exec -it ft_server bash

list:
	docker ps -a
	docker images -a

stop:
	docker stop img_project

clean:
	docker rmi img_project

fclean:
	docker system prune -a

.PHONY:
	build run index_off exec list stop clean fclean