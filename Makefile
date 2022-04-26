#!/usr/bin/env bash

TERRAFORM_VAR_FILE = terraform.tfvars

.PHONY: help
help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: apply
apply: ## Applies Terraform plan w/ auto approve
	@test -s $(TERRAFORM_VAR_FILE) || { echo "The 'apply' rule assumes that variables are provided $(TERRAFORM_VAR_FILE)"; exit 1; }
	terraform apply -auto-approve --var-file $(TERRAFORM_VAR_FILE)

.PHONY: destroy
destroy: ## Destroys Terraform infrastructure w/ auto approve
	terraform destroy -auto-approve --var-file $(TERRAFORM_VAR_FILE)

.PHONY: plan
plan: ## Outputs the Terraform plan
	terraform plan --var-file $(TERRAFORM_VAR_FILE)	-no-color

.PHONY: show-plan
show-plan: ## Outputs the Terraform plan
	terraform plan --var-file $(TERRAFORM_VAR_FILE)	-no-color -out=tfplan.out
	terraform show -json tfplan.out
	rm tfplan.out

.PHONY: init
init: ## Init the terraform module
	terraform init

.PHONY: tf-version
tf-version: ## checks the terraform version
	terraform version

.PHONY: lint
lint: init tf-version ## Verifies Terraform syntax
	terraform validate

.PHONY: fmt
fmt: ## Reformat Terraform files according to standard
	terraform fmt -check -diff -recursive

.PHONY: clean
clean: ## Deletes temporary files
	@rm -rf report

.PHONY: generate-readme
generate-readme: ##  Generate all the README.md for the root module, submodules, and example modules
	terraform-docs . --recursive
	terraform-docs . --recursive --recursive-path=examples

.PHONY: generate-tfvars
generate-tfvars: ##   Generate terraform.tfvars of inputs
	terraform-docs tfvars hcl . --recursive --config=.tfvars.terraform-docs.yml
	terraform-docs tfvars hcl . --recursive --recursive-path=examples --config=.tfvars.terraform-docs.yml


.PHONY: pr-prep
pr-prep: ## Run PR prep tasks
## TODO: Fix and Add more PR prep tasks
	lint
	fmt
	generate-readme
