REPO=blacktop
NAME=bro
BUILD ?= 2.5
LATEST ?= 2.5

all: build size test

build:
	cd $(BUILD); docker build -t $(REPO)/$(NAME):$(BUILD) .

size: build
ifeq "$(BUILD)" "$(LATEST)"
	sed -i.bu 's/docker image-.*-blue/docker image-$(shell docker images --format "{{.Size}}" $(REPO)/$(NAME):$(BUILD))-blue/' README.md
	sed -i.bu '/latest/ s/[0-9.]\{3,5\} MB/$(shell docker images --format "{{.Size}}" $(REPO)/$(NAME):$(BUILD))/' README.md
endif
	sed -i.bu '/$(BUILD)/ s/[0-9.]\{3,5\} MB/$(shell docker images --format "{{.Size}}" $(REPO)/$(NAME):$(BUILD))/' README.md

tags:
	docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" $(REPO)/$(NAME)

test:
	@docker run --rm $(REPO)/$(NAME):$(BUILD) --version
	@docker run --rm -v `pwd`/pcap:/pcap -v `pwd`/scripts/local.bro:/usr/local/share/bro/site/local.bro $(REPO)/$(NAME):$(BUILD) -r heartbleed.pcap local "Site::local_nets += { 192.168.11.0/24 }"
	@cat pcap/notice.log | awk '{ print $$11 }' | tail -n4

tar:
	docker save $(REPO)/$(NAME):$(BUILD) -o $(NAME).tar

circle:
	http https://circleci.com/api/v1.1/project/github/${REPO}/docker-${NAME} | jq '.[0].build_num' > .circleci/build_num
	http "$(shell http https://circleci.com/api/v1.1/project/github/${REPO}/docker-${NAME}/$(shell cat .circleci/build_num)/artifacts${CIRCLE_TOKEN} | jq '.[].url')" > .circleci/SIZE
		sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell cat .circleci/SIZE)-blue/' README.md
	sed -i.bu 's/docker image-.*-blue/docker image-$(shell cat .circleci/SIZE)-blue/' README.md
	sed -i.bu '/latest/ s/[0-9.]\{3,5\}MB/$(shell cat .circleci/SIZE)/' README.md
	sed -i.bu '/$(BUILD)/ s/[0-9.]\{3,5\}MB/$(shell cat .circleci/SIZE)/' README.md

clean:
	docker-clean stop
	docker rmi $(REPO)/$(NAME)
	docker rmi $(REPO)/$(NAME):$(BUILD)

.PHONY: build size tags test tar clean circle
