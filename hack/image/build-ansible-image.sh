#!/usr/bin/env bash

set -eux

source hack/lib/test_lib.sh

ROOTDIR="$(pwd)"
GOTMP="$(mktemp -d -p $GOPATH/src)"
trap_add 'rm -rf $GOTMP' EXIT
BASEIMAGEDIR="$GOTMP/ansible-operator"
mkdir -p "$BASEIMAGEDIR"

# build operator binary and base image
pushd "$BASEIMAGEDIR"
go run "$ROOTDIR/hack/image/scaffold-ansible-image.go"

mkdir -p build/_output/bin/
cp $(which operator-sdk) build/_output/bin/ansible-operator
operator-sdk build $1
popd
