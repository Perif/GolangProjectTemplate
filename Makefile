.PHONY: build doc fmt lint run test vendor_clean vendor_get vendor_update vet

# Prepend our _vendor directory to the system GOPATH
# so that import path resolution will prioritize
# our third party snapshots.
GOPATH :=${PWD}:${PWD}/_vendor:${GOPATH}
export GOPATH
DATE=`date +%Y.%m.%d.%H%M%S`
HASH=`git log --pretty=format:%h -n 1`
BRANCH=`git branch | grep \* | cut -d ' ' -f2-`
GOVERSION=`go version | cut -d' ' -f3 | tr -d [:alpha:]`
APPNAME='myapp'

default: build

build: fmt
		go build -v -ldflags "-X info.BuildTime=${DATE} \
		-X info.CommitHash=$(HASH) -X info.BranchName=$(BRANCH)\
		-X info.GolangVersion=${GOVERSION}" \
		-o ./bin/$(APPNAME) ./src/$(APPNAME)

doc:
		godoc -http=:6060 -index

# http://golang.org/cmd/go/#hdr-Run_gofmt_on_package_sources
fmt:
		go fmt ./src/...

# https://github.com/golang/lint
# go get github.com/golang/lint/golint
lint:
		golint ./src

run: build
		./bin/$(APPNAME)

test:
		go test -v ./src/$(APPNAME)

vendor_clean:
		rm -dRf ./_vendor/src

# We have to set GOPATH to just the _vendor
# directory to ensure that `go get` doesn't
# update packages in our primary GOPATH instead.
# This will happen if you already have the package
# installed in GOPATH since `go get` will use
# that existing location as the destination.
vendor_get: vendor_clean
		GOPATH=${PWD}/_vendor go get -d -u -v \
		github.com/fatih/color

vendor_update: vendor_get
		rm -rf `find ./_vendor/src -type d -name .git` \
		&& rm -rf `find ./_vendor/src -type d -name .hg` \
		&& rm -rf `find ./_vendor/src -type d -name .bzr` \
		&& rm -rf `find ./_vendor/src -type d -name .svn`

# http://godoc.org/code.google.com/p/go.tools/cmd/vet
# go get code.google.com/p/go.tools/cmd/vet
vet:
		go vet ./src/...