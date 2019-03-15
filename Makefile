IMAGE_NAME := marcelocorreia/cowsay

build:
	docker build -t $(IMAGE_NAME) .

push:
	docker push $(IMAGE_NAME)

test:
	docker run --rm -it $(IMAGE_NAME) -f mario Buongiorno!

COWS:=$(shell cd cows && ls *cow)

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

