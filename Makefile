.PHONY: download doc build petstore

# generate source code

MAVEN_SITE					:=	https://repo.maven.apache.org
MAVEN_PATH 					:= 	/maven2/org/openapitools/openapi-generator-cli
OPENAPI_GENERATOR_VERSION	:=	6.2.1
OPENAPI_GENERATOR_JAR		:=	openapi-generator-cli-$(OPENAPI_GENERATOR_VERSION).jar

all: build

$(OPENAPI_GENERATOR_JAR):
	curl -L $(MAVEN_SITE)$(MAVEN_PATH)/$(OPENAPI_GENERATOR_VERSION)/$@ -o $@
	@echo "got $@"

download: $(OPENAPI_GENERATOR_JAR)

build: download petstore

petstore:
	@echo "cd $@"
	$(MAKE) -C $@ build OPENAPI_GENERATOR_JAR=$(OPENAPI_GENERATOR_JAR)


# generate documentation
DOCS_DIR			:=  ./docs
SHELL 				:=	/bin/bash
REDOC_CLI 			:= 	./node_modules/.bin/redoc-cli
REDOC_CLI_OPTIONS 	:=	--options.expandResponses=all \
						--options.requiredPropsFirst=true \
						--options.jsonSampleExpandLevel=5

NODEJS_VERSION 		:=	$(shell node --version 2>/dev/null)
NPM_VERSION 		:=	$(shell npm --version 2>/dev/null)
REDOC_CLI_VERSION 	:= 	$(shell $(REDOC_CLI) --version 2>/dev/null)

$(REDOC_CLI):
ifdef NODEJS_VERSION
	@echo "# node.js=$(NODEJS_VERSION), npm=$(NPM_VERSION)"
	npm install redoc-cli
else
	@echo "# install node.js before make doc"
	exit 1
endif

install_redoc-cli: $(REDOC_CLI)
	@echo "# redoc-cli=$(REDOC_CLI_VERSION)"

docs:
	@mkdir -p $(DOCS_DIR)

petstore_doc:
	$(REDOC_CLI) $(REDOC_CLI_OPTIONS) build petstore/petstore.yaml --output $(DOCS_DIR)/$@.html

doc: install_redoc-cli petstore_doc
