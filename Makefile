default: test

build: build-tests
build-swc:
	fcshc src -o stdio.swc
build-tests: build-swc build-interactive-test
	fcshc stdio.swc test/test.as --no-rsls
	fcshc stdio.swc test/flex_test.mxml
build-interactive-test:
	fcshc stdio.swc test/interactive_test.as --no-rsls

test: build-tests
	@echo '#'
	@echo '# Not testing broken Flex implementation.'
	@echo '#'
	@echo '# To manually test the readline functionality:'
	@echo '# make test-interactive'
	@echo '#'
	test/test-with-process test.swf
	test/test-without-process test.swf
test-interactive: build-interactive-test
	bin/run-swf interactive_test.swf

manual:
	ronn man/run-swf.1.ronn \
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
