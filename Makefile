TESTS_INIT=tests/minimal_init.lua
TESTS_DIR=tests/

# --- Default targets ---

.PHONY: install
install: install-go-tooling
.PHONY: install-go-tooling
install-go-tooling: install-format-go install-lint-go install-vuln-go
.PHONY: all
all: test format lint vuln git-diff
.PHONY: test
test: test-lua test-go
.PHONY: format
format: format-go
.PHONY: lint
lint: lint-go
.PHONY: vuln
vuln: vuln-go


# --- Targets ---

.PHONY: test-lua
test-lua:
	nvim \
		--headless \
		--noplugin \
		-u ${TESTS_INIT} \
		-c "PlenaryBustedDirectory ${TESTS_DIR} { minimal_init = '${TESTS_INIT}' }"

.PHONY: test-go
test-go:
	cd tests/go && \
		go test -v ./...

.PHONY: format-go
format-go:
	cd tests/go && \
		gci write --skip-generated --skip-vendor -s standard -s default . && \
		golines --base-formatter=gofumpt --ignore-generated --tab-len=1 --max-len=120 --write-output . && \
		git diff --exit-code

.PHONY: lint-go
lint-go:
	cd tests/go && \
		golangci-lint run --verbose ./...

.PHONY: vuln-go
vuln-go:
	cd tests/go && \
		go vet ./... && \
		gosec ./...


# --- Installation of tooling ---

.PHONY: install-format-go
install-format-go:
	go install github.com/daixiang0/gci@latest && \
		go install github.com/segmentio/golines@latest && \
		go install mvdan.cc/gofumpt@latest	# NOTE: golines uses gofumpt

.PHONY: install-lint-go
install-lint-go:
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

.PHONY: install-vuln-go
install-vuln-go:
	go install github.com/securego/gosec/v2/cmd/gosec@latest

