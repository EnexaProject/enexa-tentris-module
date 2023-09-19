IMAGE=hub.cs.upb.de/enexa/images/enexa-tentris-module
TENTRIS_VERSION=0.2.0-SNAPSHOT
VERSION=$(TENTRIS_VERSION)-1
TAG=$(IMAGE):$(VERSION)
TEST_DIR=test-shared-dir

build: update-ttl-file update-Dockerfile
	docker build -t $(TAG) .

test:
	[ -d $(TEST_DIR) ] || mkdir -p $(TEST_DIR)
	curl -o $(TEST_DIR)/data.ttl https://raw.githubusercontent.com/EnexaProject/enexa-transform-module/main/src/test/resources/org/dice_research/enexa/transform/testDataset.ttl
	docker run --rm \
	-v $(PWD)/$(TEST_DIR):/shared \
	-e ENEXA_SHARED_DIRECTORY=/shared \
	-e ENEXA_META_DATA_ENDPOINT=http://admin:admin@fuseki:3030/test \
	-e ENEXA_META_DATA_GRAPH=http://example.org/meta-data \
	-e ENEXA_SERVICE_URL=http://enexa:36321/ \
	-e ENEXA_WRITEABLE_DIRECTORY=/shared/experiment1 \
	-e ENEXA_MODULE_INSTANCE_DIRECTORY=/shared/experiment1/module1 \
	-e ENEXA_MODULE_INSTANCE_IRI=http://example.org/moduleinstance-$$(date +%s) \
	-e TEST_RUN=true \
	--network enexa-utils_default \
	$(TAG)
	
push:
	docker push $(TAG)

push-latest:
	docker tag $(TAG) $(IMAGE):latest
	docker push $(IMAGE):latest

update-ttl-file:
	echo "# Don't change this file! It is generated based on module.ttl.template." > module.ttl
	sed 's/$$(VERSION)/$(VERSION)/g' module.ttl.template | sed 's=$$(TAG)=$(TAG)=g' >> module.ttl
	
update-Dockerfile:
	echo "# Don't change this file! It is generated based on Dockerfile.template." > Dockerfile
	sed 's/$$(TENTRIS_VERSION)/$(TENTRIS_VERSION)/g' Dockerfile.template >> Dockerfile
