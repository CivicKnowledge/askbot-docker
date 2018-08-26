
NS = civicknowledge.com
VERSION = latest

REPO = askbot-docker
NAME = askbot

DOCKER ?= docker

# NOTE! Docker-compose gets the project name from the directory the compose file is in, 
# or the -p option, or the COMPOSE_PROJECT_NAME environmental variable. 
PROJECT_NAME=coreweb

VOLUMES= 

PORTS= -p8080:80


.PHONY: build push shell run start stop restart reload rm rmf release

build:
	$(DOCKER) build -t $(NS)/$(REPO):$(VERSION) .

push:
	$(DOCKER) push $(NS)/$(REPO):$(VERSION)

shell:
	$(DOCKER) run --rm -i -t $(VOLUMES) $(PORTS) $(ENV) $(NS)/$(REPO):$(VERSION)  /bin/bash

attach:
	$(DOCKER) exec  -ti $(NAME) /bin/bash

run:
	$(DOCKER) run --rm --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)


backup:
	$(DOCKER) run --rm  $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION) tar -czf - /volumes  | tar -xzvf -


logs:
	$(DOCKER) logs -f $(NAME) 

start:
	$(DOCKER) run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

stop:
	$(DOCKER) stop $(NAME)
	
restart: stop start

reload: build rmf start

rmf:
	$(DOCKER) rm -f $(NAME)

rm:
	$(DOCKER) rm $(NAME)

release: build
	make push -e VERSION=$(VERSION)

default: build