default: test

build: build-tests
build-swc:
	fcshc -o tmp/stdio.swc src
build-tests: build-swc build-interactive-test
	fcshc -o tmp/flash_test.swf \
	  tmp/stdio.swc test/flash_test.as --no-rsls
	fcshc -o tmp/flex_test.swf \
	  tmp/stdio.swc test/flex_test.mxml
build-interactive-test:
	fcshc -o tmp/interactive_test.swf \
	  tmp/stdio.swc test/interactive_test.as --no-rsls

test: build-tests
	@echo '#'
	@echo '# To manually test the readline functionality:'
	@echo '# make test-interactive'
	@echo '#'
	test/test-with-process tmp/flash_test.swf
	test/test-without-process tmp/flash_test.swf
	test/test-with-process tmp/flex_test.swf
	test/test-without-process tmp/flex_test.swf
test-interactive: build-interactive-test
	bin/run-swf tmp/interactive_test.swf

manual:
	ronn run-swf.1.ronn \
	  --html --style=man,toc --manual="STDIO.AS" \
	  --pipe > tmp/run-swf.1.html
pages: manual
	git checkout gh-pages
	cp tmp/run-swf.1.html .
	git add run-swf.1.html
	git commit -m "Regenerate man file."
	git push origin gh-pages
	git checkout master

clean:
	rm tmp/*
