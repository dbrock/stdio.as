build:
	fcshc src/test.as --no-flex -X -debug
test: build
	node test.js
