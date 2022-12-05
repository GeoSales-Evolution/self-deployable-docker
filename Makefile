IMAGE_DIRS = hestia ouroborus
IMAGE_TARGETS = $(foreach IMG, $(IMAGE_DIRS), image-$(IMG))
.PHONY: $(IMAGE_TARGETS) all

all: image-hestia image-ouroborus

$(IMAGE_TARGETS):
	$(MAKE) -C $(patsubst image-%,%,$@) image
