#! /bin/bash

# this is the entry-point run by docker that will generate all the go source, then run it

PROTOC="/usr/local/bin/protoc -I/protobuf -I$GOPATH/src -I/usr/local/include -I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis"

$PROTOC --go_out=plugins=grpc:/output "$@"
$PROTOC --grpc-gateway_out=logtostderr=true:/output "$@"
$PROTOC --swagger_out=logtostderr=true:/output "$@"
$PROTOC --plugin=/usr/app/src/protoc-gen-grpc-main --grpc-main_out=/output "$@"

cd /output
go run main.go
