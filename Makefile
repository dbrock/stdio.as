test: build-test
	node test.js
build:
	fcshc -o stdio.swc src
build-test: build
	fcshc stdio.swc test-src/test_local_flash.as --no-rsls
	fcshc stdio.swc test-src/test_local_flex.mxml
	fcshc stdio.swc test-src/test_web_flash.as --no-rsls
	fcshc stdio.swc test-src/test_web_flex.mxml
clean:
	rm -f *.swc *.swf
