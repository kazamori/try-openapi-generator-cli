.PHONY: download doc build petstore

# generate source code

MAVEN_SITE					:=	http://central.maven.org
MAVEN_PATH 					:= 	/maven2/org/openapitools/openapi-generator-cli
OPENAPI_GENERATOR_VERSION	:=	4.2.1
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
VENV_NAME			:=	venvs/openapi
VENV_ACTIVAGTE 		:=	$(VENV_NAME)/bin/activate

NODEJS_VERSION 		:=	$(shell node --version 2>/dev/null)
NPM_VERSION 		:=	$(shell npm --version 2>/dev/null)
REDOC_CLI_VERSION 	:= 	$(shell $(REDOC_CLI) --version 2>/dev/null)
PYTHON3_VERSION 	:=	$(shell python3 --version 2>/dev/null)

$(VENV_ACTIVAGTE):
ifdef PYTHON3_VERSION
	@echo "# python3=$(PYTHON3_VERSION)"
	mkdir venvs
	python3 -m venv $(VENV_NAME)
	( \
		source $(VENV_ACTIVAGTE); \
		python3 -m pip install -U pip; \
		python3 -m pip install -U openapi-ext-tools; \
	)
else
	@echo "# install python 3.x before make doc"
	exit 1
endif

install_openapi-ext-tools: $(VENV_ACTIVAGTE)
	@echo $(shell ( \
		source $(VENV_ACTIVAGTE); \
		python3 -m pip freeze | grep openapi-ext-tools; \
	))

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

petstore.yaml: docs
	@echo $(shell ( \
		source $(VENV_ACTIVAGTE); \
		openapi-spec-cli --spec-path petstore/$@ --bundled-spec-path $(DOCS_DIR)/$@ --verbose; \
	))

petstore_doc: petstore.yaml
	$(REDOC_CLI) $(REDOC_CLI_OPTIONS) bundle $(DOCS_DIR)/$< --output $(DOCS_DIR)/$@.html

doc: install_redoc-cli install_openapi-ext-tools petstore_doc
