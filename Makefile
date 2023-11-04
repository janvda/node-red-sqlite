DOCKERHUB_ID:=janvda
SERVICE_NAME:=node-red-sqlite
SERVICE_VERSION:=3.1.0-18 # same version as docker hub tag of the node-red base image.
ARCHITECTURES:= linux/arm/v7,linux/arm64/v8,linux/amd64

# if you don't want the build to use cached layers replace next line by :
#        CACHING:= --no-cache
CACHING:=

define HELP
=========================================================================================
Make Commands:

1. make buildx

    Builds the image $(DOCKERHUB_ID)/$(SERVICE_NAME):$(SERVICE_VERSION)
    for architectures: $(ARCHITECTURES)
    and publishes it to docker hub.

2. make push_readme

     Pushes README.md to Docker Hub repository $(DOCKERHUB_ID)/$(SERVICE_NAME)

3. make all

     Combination of buildx and push_readme

Before running these make commands assure you are using your local docker version (so DOCKER_HOST or docker context is not pointing
to a remote host)
=========================================================================================
endef
export HELP

default:
	@echo "$$HELP"

all: buildx push_readme

buildx: login worldgame_latest.db
	@echo "Create a new builder instance (docker container) ..."
	docker buildx create --use --name build --node build --driver-opt network=host	
	@echo "Starting the build ..."
	docker buildx build $(CACHING) --push --platform $(ARCHITECTURES) \
	                    --tag $(DOCKERHUB_ID)/$(SERVICE_NAME):$(SERVICE_VERSION) .

push_readme: login
	@echo "Push README.md file to Docker Hub ..."
	docker pushrm $(DOCKERHUB_ID)/$(SERVICE_NAME)

login:
	@echo "buildx requires that you must login to dockerhub in order to update readme"
	@echo "So, please enter your dockerhub access token here below."
	docker login -u $(DOCKERHUB_ID)

worldgame_latest.db:
	@echo "please run the aliases"

.PHONY: default buildx push_readme login all