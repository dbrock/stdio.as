build:
	fcshc src/test_bare.as --no-flex
	fcshc src/test_flex.mxml
test: build
	node test.js
