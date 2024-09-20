# use current-folder's name as project name
PROJECT_NAME := $(notdir ${PWD})
MAMBA := micromamba
VENV := $$($(MAMBA) info | awk -F': ' '/base env/{print $$2}')/envs/$(PROJECT_NAME)
PYTHON := $(VENV)/bin/python
MARKER := .micromambaenv

.PHONY: all
all: env deps check test ## Run main targets

.PHONY: env
env: | $(MARKER) ## Create or update virtual environment

.PHONY: activate
activate: ## Open a new shell with the activated environment
	@unset MAKELEVEL && \
	echo 'eval "$$($(MAMBA) shell activate ${PROJECT_NAME})"; exec </dev/tty' | exec bash -i

.PHONY: deps
deps: env ## Sync dependencies in the virtual environment
	@CONDA_PREFIX=$(VENV) $(VENV)/bin/uv pip sync requirements-dev.txt
	@$(VENV)/bin/pre-commit install >/dev/null

.PHONY: lockdeps
lockdeps: env ## Update or generate dependency lock files
	@$(VENV)/bin/uv pip compile setup.cfg -o requirements.txt $(args)
	@for extra in $$($(PYTHON) -c \
		'from setuptools.config.setupcfg import read_configuration as c; \
		print(*c("setup.cfg")["options"]["extras_require"])'); do \
			$(VENV)/bin/uv pip compile setup.cfg \
			-o requirements-$$extra.txt --extra $$extra $(args); \
	done

.PHONY: check
check: env ## Run checkers, linters and auto-fixers
	@$(VENV)/bin/pre-commit run --all-files

.PHONY: test
test: env ## Run tests
	@$(PYTHON) -m pytest

.PHONY: cov
cov: env ## Run tests and report coverage
	@$(VENV)/bin/coverage erase
	@$(VENV)/bin/coverage run --source=. --branch -m pytest || true
	@$(VENV)/bin/coverage report --show-missing --skip-covered

.PHONY: build
build: ## Build artifacts
	@docker build . -t ${PROJECT_NAME}

.PHONY: run
run: ## Run main entrypoint
	@docker run --rm -it ${PROJECT_NAME}

.PHONY: clean
clean: ## Clean-up generated files
	@find -type f -name '*.pyc' -delete
	@find -type f -name '*mypyc*linux-gnu.so' -delete
	@find -type d -name '__pycache__' -delete
	@find -type d -name '.*_cache' -exec rm -rf {} +
	@rm -rf *.egg-info
	@rm -rf dist
	@rm -f .coverage

.PHONY: purge
purge: clean ## Clean-up and remove environment
	@$(MAMBA) env remove -y -n ${PROJECT_NAME} && rm -rf $(MARKER)

.PHONY: help
help: ## Show help
	@awk -F':.*##' '/##[[:space:]]/{printf "\033[1;32m%-12s\033[m%s\n", $$1, $$2}' ${MAKEFILE_LIST}

$(MARKER): environment.yml # only update when environment.yml changes
	@$(MAMBA) create -n ${PROJECT_NAME} -f $< -y
	@touch $@

.PHONY: _active
_active: # check that environment is active
ifneq ($(notdir ${CONDA_PREFIX}), $(PROJECT_NAME))
	$(error Run "$(MAMBA) activate $(PROJECT_NAME)" first)
endif
