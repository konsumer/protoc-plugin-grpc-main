# protoc-plugin-grpc-main

Generate a complete grpc-gateway main file

## usage

You must have protoc and node installed.

Do all the steps listed [here](https://github.com/grpc-ecosystem/grpc-gateway#usage), up to "Write an entrypoint", then run this:

```
protoc --plugin=`pwd`/src/protoc-gen-grpc-main --grpc-main_out=/output -I `pwd` `pwd`/helloworld.proto
```


## in docker

I made a docker container that will build your grpc gateway & swagger file, then run it. You don't need node, protoc, or go installed to try it out.

```
docker run -v `pwd`:`pwd` -v `pwd`/output:/output --rm -it konsumer/grpc-gateway -I `pwd` `pwd`/helloworld.proto
```


## todo

> needs lots of testing with diverse protobuf configurations

### options I should parse

* `template` - full-path to handlebars template instead of main_insecure.go
* `grpc_host` - `host:port` that gRPC server is running on
* `port` - port to listen to http
* SSL keys, etc

