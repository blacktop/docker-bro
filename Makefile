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
	docker run --rm $(REPO)/$(NAME):$(BUILD) --help
	docker run --rm -v `pwd`/pcap:/pcap $(REPO)/$(NAME):$(BUILD) -r heartbleed.pcap local "Site::local_nets += { 192.168.11.0/24 }"

.PHONY: build size tags test
