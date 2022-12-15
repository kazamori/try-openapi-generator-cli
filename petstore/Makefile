.PHONY: generate build clean

GENERATED_SOURCE_DIR	=	./generated
GENERATOR_JAR 			=	../$(OPENAPI_GENERATOR_JAR)
SPEC_FILE				= 	$(shell ls *.yaml)

all: build

generate:
ifeq ($(GENERATOR_JAR),../)
	@echo "# GENERATOR_JAR is empty, set it the path"
	@echo "# make build GENERATOR_JAR=path/to/jar"
	exit 1
endif

ifeq ($(generator_name),)
	@echo "# generator_name is empty, set it to generate"
	@echo "# e.g.) make build generator_name=python"
else
	@echo "generator_name=$(generator_name)"
	java -jar $(GENERATOR_JAR) generate --skip-validate-spec --input-spec $(SPEC_FILE) --output $(GENERATED_SOURCE_DIR)/$(generator_name) --generator-name $(generator_name)
endif

build: clean generate

clean:
	@echo "# remove previous generated source if exists"
	rm -rf $(GENERATED_SOURCE_DIR)
