NAME = terraform-kubernetes-rbac

SHELL := /bin/bash

.PHONY: help all

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build docker dev container
	cd .devcontainer && docker build -f Dockerfile . -t $(NAME)

run: ## Run docker dev container
	docker run -it --rm -v "$$(pwd)":/workspaces/$(NAME) -v ~/.aws:/root/.aws -v ~/.kube:/root/.kube -v ~/.cache/pre-commit:/root/.cache/pre-commit --workdir /workspaces/$(NAME) $(NAME) /bin/bash

install: ## Install project
	# terraform
	terraform init
	cd examples/authn_authz && terraform init
	cd examples/rbac && terraform init
	cd examples/rbac_submodule && terraform init
	cd examples/eks && terraform init
	cd modules/rbac && terraform init

	# pre-commit
	git init
	git add -A
	pre-commit install

	# terratest
	go get github.com/gruntwork-io/terratest/modules/terraform
	go mod init test/terraform_rbac_test.go

lint:  ## Lint with pre-commit
	git add -A
	pre-commit run
	git add -A

test-authn-authz:  ## Test Authn Authz Example
	go test test/terraform_authn_authz_test.go -timeout 1m -v |& tee test/terraform_authn_authz_test.log

test-rbac: ## Test RBAC Example
	go test test/terraform_rbac_test.go -timeout 1m -v |& tee test/terraform_rbac_test.log

test-rbac-submodule: ## Test RBAC Submodule Example
	go test test/terraform_rbac_submodule_test.go -timeout 1m -v |& tee test/terraform_rbac_submodule_test.log

clean: ## Clean project
	@rm -f .terraform.lock.hcl
	@rm -f examples/authn_authz/.terraform.lock.hcl
	@rm -f examples/rbac/.terraform.lock.hcl
	@rm -f examples/rbac_submodule/.terraform.lock.hcl
	@rm -f modules/rbac/.terraform.lock.hcl

	@rm -rf .terraform
	@rm -rf examples/authn_authz/.terraform
	@rm -rf examples/rbac/.terraform
	@rm -rf examples/rbac_submodule/.terraform
	@rm -rf modules/rbac/.terraform

	@rm -f go.mod
	@rm -f go.sum
