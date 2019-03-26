COWS:=$(shell cd cows && ls *cow)
DOCS_DIR := docs
GITHUB_USER := marcelocorreia
GIT_BRANCH ?= master
GIT_REMOTE ?= origin
IMAGE_NAME := marcelocorreia/cowsay
NAMESPACE := github.com/marcelocorreia
RELEASE_TYPE ?= patch
REPO_NAME := cowsay
REPO_URL := git@github.com:$(GITHUB_USER)/$(REPO_NAME).git
SEMVER_DOCKER ?= marcelocorreia/semver
#

release: _release

test:
	docker run --rm -it $(IMAGE_NAME) -f mario Buongiorno!


list-cows:
	docker run --rm $(IMAGE_NAME) list

showcase1:
	@$(foreach cow,$(COWS), \
	clear && echo $(cow) && cowsay -f $(cow) Hello Worldoo.. && read n && clear;)


showcase2:
	@$(foreach cow,$(COWS), \
	clear && cowsay -f $(cow) Hello Worldoo.. && sleep 0.4 && clear;)

mario:
	@$(call docker_run,mario,che cazzo fa?)

define docker_run
	docker run --rm $(IMAGE_NAME) -f $1 $2
endef

_setup-versions:
	$(eval export CURRENT_VERSION=$(shell git ls-remote --tags $(GIT_REMOTE) | grep -v latest | awk '{ print $$2}'|grep -v 'stable'| sort -r --version-sort | head -n1|sed 's/refs\/tags\///g'))
	$(eval export NEXT_VERSION=$(shell docker run --rm --entrypoint=semver $(SEMVER_DOCKER) -c -i $(RELEASE_TYPE) $(CURRENT_VERSION)))

all-versions:
	@git ls-remote --tags $(GIT_REMOTE)

current-version: _setup-versions
	@echo $(CURRENT_VERSION)

next-version: _setup-versions
	@echo $(NEXT_VERSION)

_docker-build: _setup-versions
	sed -i .bk 's/ARG cowsay_version.*/ARG cowsay_version\=\"$(CURRENT_VERSION)\"/' Dockerfile
	docker build -t marcelocorreia/$(IMAGE_NAME):latest  .
	docker build -t marcelocorreia/$(IMAGE_NAME):$(CURRENT_VERSION) .
	$(call  git_push,Post Release Updating auto generated stuff - version: $(CURRENT_VERSION))

_docker-push: _setup-versions
	docker push marcelocorreia/$(IMAGE_NAME):latest
	docker push marcelocorreia/$(IMAGE_NAME):$(CURRENT_VERSION)

_release: _setup-versions ;$(call  git_push,Releasing $(NEXT_VERSION)) ;$(info $(M) Releasing version $(NEXT_VERSION)...)## Release by adding a new tag. RELEASE_TYPE is 'patch' by default, and can be set to 'minor' or 'major'.
	github-release release -u marcelocorreia -r $(REPO_NAME) --tag $(NEXT_VERSION) --name $(NEXT_VERSION) --description "Collection of cows for old good cowsay"
	$(MAKE) _docker-build
	$(MAKE) _docker-push

define git_push
	-git add .
	-git commit -m "$1"
	-git push
endef