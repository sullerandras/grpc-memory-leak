#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

protoc_path=$(which protoc)
if [ ! -x "$protoc_path" ]; then
	echo "ERROR: Protobuf Compiler not found"
	exit 1
fi

protoc_path=$(which grpc_tools_ruby_protoc)
if [ ! -x "$protoc_path" ]; then
	echo "ERROR: grpc_tools_ruby_protoc not found. Install it with 'gem install grpc-tools'"
	exit 1
fi

if [ ! -d "$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis" ]; then
	echo "ERROR: please install 'go get github.com/grpc-ecosystem/grpc-gateway'"
	exit 1
fi

protoc_gen_ruby_path=$(which protoc-gen-ruby)
if [ ! -x "$protoc_gen_ruby_path" ]; then
	echo "ERROR: Protobuf Ruby bindings not found"
	exit 1
fi

if [ ! -d "protobuf" ]; then
	echo "ERROR: Protobuf Schema not found"
	exit 1
fi

mkdir -p lib/generators

grpc_tools_ruby_protoc --proto_path=protobuf \
-I/usr/local/include -I. \
-I$GOPATH/src \
-I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
--ruby_out=lib/generators \
--grpc_out=lib/generators \
protobuf/*.proto
