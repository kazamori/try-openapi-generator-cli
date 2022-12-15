# petstore

[petstore.yaml](https://github.com/OpenAPITools/openapi-generator/blob/master/modules/openapi-generator/src/test/resources/3_1/petstore.yaml) is a sample OpenAPI schema.

## How to build

To download openapi-generator jar file, see [parent README](../README.md). Then, to generate any souce code provided by openapi-generator from [petstore.yaml](petstore.yaml). for example, to generate `python` (it means python client source code) is like this.

```bash
$ VERSION=6.2.1
$ make build GENERATOR_JAR=../openapi-generator-cli-${VERSION}.jar generator_name=python
```

The openapi-generator made `generated/python` directory and the source code will be put.

```bash
$ tree generated/python/
```

you can confirm generator names in [generators](https://openapi-generator.tech/docs/generators.html).
