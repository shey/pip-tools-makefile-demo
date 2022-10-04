.DEFAULT_GOAL := help

## Setup
.PHONY: help
help: ## Displays this help message.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: venv
venv: ## Create a local venv to install the app in
	python3.9 -m venv venv
	venv/bin/pip install --upgrade pip
	venv/bin/pip install pip-tools

.PHONY: destroy
destroy: ## Destroy the virtualenv
	rm -rf ./venv

## Gather dependencies
.PHONY: compile-base
compile-base: ## use pip-tools to generate base requirements
	pip-compile base-requirements.in

.PHONY: compile-dev
compile-dev: compile-base ## use pip-tools to generate requirements for a developer env
	pip-compile dev-requirements.in

.PHONY: compile-test
compile-test: compile-base ## use pip-tools to generate requirements for a test env.
	pip-compile test-requirements.in

.PHONY: compile-prod
compile-prod: compile-base ## use pip-tools to generate requirements for a test env.
	pip-compile prod-requirements.in

## Install dependencies
.PHONY: install-dev
install-dev: compile-dev ## Install python requirements (assumes active environment)
	pip-sync base-requirements.txt dev-requirements.txt

.PHONY: install-test
install-test: ## Install python requirements (assumes active environment)
	pip-sync base-requirements.txt test-requirements.txt

.PHONY: install-prod
install-prod: compile-prod ## Install python requirements (assumes active environment)
	pip-sync base-requirements.txt prod-requirements.txt
