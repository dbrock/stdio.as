test: build-test
	node test-src/test.js
build:
	fcshc src -o stdio.swc
build-test: build
	fcshc stdio.swc test-src/test_local_flash.as --no-rsls
	fcshc stdio.swc test-src/test_local_flex.mxml
	fcshc stdio.swc test-src/test_web_flash.as --no-rsls
	fcshc stdio.swc test-src/test_web_flex.mxml
manual:
	ronn man/run-swf.1.ronn \
	  --html --style=man,toc \
	  --manual="FLASHPLAYER-STDIO"
clean:
	rm -f *.swc *.swf man/*.html
