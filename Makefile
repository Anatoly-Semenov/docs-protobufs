.PHONY: clean-all clean clean-build clean-pyc clean-test dist help install validate-protoc generate-pypi generate-pypi-packages generate-init-py release-npm release
.DEFAULT_GOAL := help

define BROWSER_PYSCRIPT
import os, webbrowser, sys

from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

BROWSER := python3 -c "$$BROWSER_PYSCRIPT"

help:
	@python3 -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

clean: clean-build clean-pyc clean-test ## remove all build, test, coverage and Python artifacts

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache

clean-all: clean ## clean all packages (npm, python)
	rm -fr ./package
	find ./ -name '*.tgz' -exec rm -f {} +
	find ./docs/ -name '*.py' -exec rm -f {} +
	find ./docs/ -name '*.pyi' -exec rm -f {} +

validate-protoc: generate-pypi ## running validation proto files
	{ \
	set -e ;\
	root="./docs" ; \
	for proto in $$(find $$root -type f -name '*.proto'); \
	do python3 -m grpc_tools.protoc -I=. --python_out=. --pyi_out=. --grpc_python_out=. $$proto ;\
	done ;\
	}


generate-pypi-packages:  generate-pypi generate-init-py ## generate python protobufs packages

generate-pypi: clean-all ## generate packages protoc
	{ \
	set -e ;\
	root="./docs" ; \
	for proto in $$(find $$root -type f -name '*.proto'); \
	do python3 -m grpc_tools.protoc -I=. --python_out=. --pyi_out=. --grpc_python_out=. $$proto ;\
	done ;\
	}

generate-init-py: ## generation init file
	{ \
	set -e ;\
	root="./docs/" ; \
	for dir in $$(find $$root -type d); \
	do touch $$dir/__init__.py ;\
	done ;\
	}

release: dist ## package and upload a release
	twine upload --repository docs --skip-existing dist/*

release-npm: ## npm package and upload a realease
	npm pack
	npm publish

dist: clean ## builds source and wheel package
	python3 setup.py sdist
	python3 setup.py bdist_wheel
	ls -l dist

install: clean ## install the package to the active Python's site-packages
	python3 setup.py install
