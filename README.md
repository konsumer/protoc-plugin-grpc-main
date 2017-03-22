# protoc-plugin-grpc-main

Generate a complete grpc-gateway and run it:

```
mkdir out

docker build . -t konsumer/protoc-grpc-gateway

docker run -v `pwd`:`pwd` -v `p`/out:/out --rm konsumer/protoc-grpc-gateway -I `pwd` `pwd`/helloworld.proto
```