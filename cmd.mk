.DEFAULT_GOAL_NAME := help

CLOUDFORMATION := aws cloudformation
STACK := Example
TEMPLATE := file://template.yml


.PHONY: help
help:
	@# Display usage
	unmake $(MAKEFILE_LIST)


.PHONY: env
env:
	ln -sf cmd.mk Makefile


.PHONY: create
create: validate
	@# 更新
	$(CLOUDFORMATION) create-stack --stack-name $(STACK) --template-body $(TEMPLATE) --role-arn $AWS_ROLE_ARN


.PHONY: update
update: validate
	@# 更新
	$(CLOUDFORMATION) update-stack --stack-name $(STACK) --template-body $(TEMPLATE)


.PHONY: delete
delete:
	@# 削除 (全てのリソースが削除されます)
	$(CLOUDFORMATION) delete-stack --stack-name $(STACK)


.PHONY: validate
validate:
	@# テンプレートを検証
	$(CLOUDFORMATION) validate-template --template-body $(TEMPLATE)
