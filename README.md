# try-openapi-generator-cli

Sample repository to run openopenapi-generator-cli.jar to generate code/docs/schemas/configs

## TL;DR

### generate source

Run `build` target with `generator_name` option. To generate `go` client is like this.

```bash
$ make build generator_name=go
```

openapi-generator made `generated/go` into each directories and the source code will be put.

```
$ tree -L 2 petstore/generated/
petstore/generated/
└── go
    ├── README.md
    ├── api
    ├── api_pet.go
    ├── api_store.go
    ├── api_user.go
    ├── client.go
    ├── configuration.go
    ├── docs
    ├── git_push.sh
    ├── go.mod
    ├── go.sum
    ├── model_api_response.go
    ├── model_category.go
    ├── model_order.go
    ├── model_pet.go
    ├── model_tag.go
    ├── model_user.go
    ├── response.go
    ├── test
    └── utils.go

4 directories, 17 files
```

you can confirm generator names in [generators](https://openapi-generator.tech/docs/generators.html).

### generate documentation

Run `doc` target to generate the API documentation into `docs` directory.

```bash
$ make doc
```

Create single static html by [redoc-cli](https://github.com/Redocly/redoc/tree/main/cli).

```bash
$ tree docs
docs
└── petstore_doc.html
```

Open `petstore_doc.html` with your web browser.

## How to build

The `download` target will get openapi-generator-cli.jar using curl command if it is not exist.

```bash
$ make download
curl -L http://central.maven.org/maven2/org/openapitools/openapi-generator-cli/4.2.1/openapi-generator-cli-4.2.1.jar -o openapi-generator-cli-4.2.1.jar
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
```

To generate particular schema, specify the directory name with `generator_name` option.

```bash
$ make petstore generator_name=go
```
