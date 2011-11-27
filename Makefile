build:
	fcshc src/test_local_flash.as --no-flex
	fcshc src/test_local_flex.mxml
	fcshc src/test_web_flash.as --no-flex
	fcshc src/test_web_flex.mxml
test: build
	node test.js
