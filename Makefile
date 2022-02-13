install:
	bundle
	yarn install

migrate:
	bin/rails db:migrate

lint:
	rubocop
	slim-lint app/views

test:
	bin/rails test

start:
	bin/rails s

console:
	bin/rails c

.PHONY: test