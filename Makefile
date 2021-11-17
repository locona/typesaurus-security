.DEFAULT_GOAL := build
.PHONY: build

test:
	npx firebase emulators:exec --only firestore "${BIN}/jest --env node"
.PHONY: test

test-watch:
	npx firebase emulators:exec --only firestore "${BIN}/jest --env node --watch"

test-setup:
	npx firebase setup:emulators:firestore

build:
	@rm -rf lib
	@npx tsc
	@npx prettier "lib/**/*.[jt]s" --write --loglevel silent
	@cp package.json lib
	@cp *.md lib
	@rsync --archive --prune-empty-dirs --exclude '*.ts' --relative src/./ lib

publish: build
	cd lib && npm publish --access public

publish-next: build
	cd lib && npm publish --access public --tag next

docs:
	@npx typedoc --theme minimal --name Typesaurus Security
.PHONY: docs