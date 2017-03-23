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
docker build . -t konsumer/protoc-grpc-gateway

docker run -v `pwd`:`pwd` -v `pwd`/output:/output --rm -it konsumer/protoc-grpc-gateway -I `pwd` `pwd`/helloworld.proto
```

while developing:

```
docker run -v `pwd`:/usr/app -v `pwd`:`pwd` -v `pwd`/output:/output --entrypoint=/bin/bash --rm -it konsumer/protoc-grpc-gateway
```

## todo

* needs lots of testing with lots of protobuf configurations
* parse options, especially template ie: 

```
--grpc-main_out=logtostderr=true,template=`pwd`/mytemplate.go:/output \
```

