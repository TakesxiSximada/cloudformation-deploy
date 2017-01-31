.DEFAULT_GOAL_NAME := help

CLOUDFORMATION := aws cloudformation
STACK := `cat environ/current/stack`
TEMPLATE := file://templates/vpc.yml
CHANGE_SET_NAME := commit-`git show --quiet --pretty=format:"%H"`

REQUIREMENTS := $(CURDIR)/requirements.txt
WHEEL_DIR := $(CURDIR)/wheelhouse

.PHONY: help
help:
	@# Display usage
	unmake $(MAKEFILE_LIST)


.PHONY: env
env:
	sh bootstrap.sh
	pip install -r $(REQUIREMENTS) --find-links=$(WHEEL_DIR)

.PHONY: use
use:
	@## environ=staging
	ln -sf $(CURDIR)/environ/$(environ) $(CURDIR)/environ/current


.PHONY: validate
validate:
	@# テンプレートを検証
	$(CLOUDFORMATION) validate-template --template-body $(TEMPLATE)


.PHONY: change-set
change-set:
	@# change setを作成
	$(CLOUDFORMATION) create-change-set --stack-name $(STACK) --template-body $(TEMPLATE) --change-set-name=$(CHANGE_SET_NAME)
	$(CLOUDFORMATION) describe-change-set --stack-name $(STACK) --change-set-name=$(CHANGE_SET_NAME)


.PHONY: apply
apply:
	@# change setを適応
	$(CLOUDFORMATION) execute-change-set --stack-name $(STACK) --change-set-name=$(CHANGE_SET_NAME)


.PHONY: update
update:
	@# stack更新
	$(CLOUDFORMATION) update-stack --stack-name $(STACK) --template-body $(TEMPLATE)
