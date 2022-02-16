FILES_TO_FMT ?= $(shell find . -path ./vendor -prune -o -name '*.go' -print)

.PHONY: help
help: ## Print a short help message
	@grep -hE '^[a-zA-Z_-]+:[^:]*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

.PHONY: format
format: ## Formats all Go code
	@echo ">> formatting code"
	@gofmt -s -w $(FILES_TO_FMT)

.PHONY: lint
lint: ## Runs golangci-lint on source files
	golangci-lint run

.PHONY: test
test: ## Run all Go tests (excluding integration tests)
	go test -race -covermode=atomic -coverprofile=coverage.out ./...

.PHONY: integration
integration: ## Run Go tests (integration tests only)
	go test -race -tags=integration -covermode=atomic -coverprofile=coverage.out ./...
