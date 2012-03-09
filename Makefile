test: build-test
	node test-src/test.js
build:
	fcshc src -o stdio.swc
build-test: build
	fcshc stdio.swc test-src/test_local_flash.as --no-rsls
	fcshc stdio.swc test-src/test_local_flex.mxml
	fcshc stdio.swc test-src/test_web_flash.as --no-rsls
	fcshc stdio.swc test-src/test_web_flex.mxml
	fcshc stdio.swc test-src/test_readline_flash.as --no-rsls
test-readline: build-test
	bin/run-stdio-swf test_readline_flash.swf
manual:
	ronn man/run-stdio-swf.1.ronn \
	  --html --style=man,toc \
	  --manual="STDIO.AS"
pages: manual
	git checkout gh-pages
	cp man/*.html .
	git add *.html
	git commit -m "Regenerate man file."
	git push origin gh-pages
	git checkout master
clean:
	rm -f *.swc *.swf man/*.html
