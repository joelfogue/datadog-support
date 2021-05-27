.PHONY: init plan apply destroy test

.EXPORT_ALL_VARIABLES:

init:
	docker-compose -f docker-compose.yaml run --rm terraform init

lint:
	docker-compose -f docker-compose.yaml run --rm terraform fmt -recursive -check -diff .

fmt:
	docker-compose -f docker-compose.yaml run --rm terraform fmt

plan: 
	docker-compose -f docker-compose.yaml run --rm terraform plan

apply: 
	docker-compose -f docker-compose.yaml run --rm terraform apply -auto-approve

destroy: 
	docker-compose -f docker-compose.yaml run --rm terraform destroy -auto-approve

test: lint init plan apply destroy
