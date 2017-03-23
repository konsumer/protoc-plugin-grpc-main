#! /bin/bash

# this is the entry-point run by docker that will generate all the go source, then run it

/usr/local/bin/protoc -I/protobuf \
  -I$GOPATH/src -I/usr/local/include \
  -I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis/ \
  --go_out=plugins=grpc:/output \
  --grpc-gateway_out=logtostderr=true:/output \
  --swagger_out=logtostderr=true:/output \
  --plugin=/usr/app/src/protoc-gen-grpc-main --grpc-main_out=/output \
  "$@"

cd /output

# hacky thing to put pb's in GOPATH
rm -rf /go/src/pb
mkdir /go/src/pb
cp *.pb*go /go/src/pb

go run main.go

