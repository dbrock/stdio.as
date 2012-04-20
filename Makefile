FCSHC=fcshc -X-target-player=10.1

default: test
build:
	$(FCSHC) -o tmp/flash_test.swf src test/flash_test.as --no-rsls
	$(FCSHC) -o tmp/flex_test.swf src test/flex_test.mxml
	$(FCSHC) -o tmp/interactive_test.swf src test/interactive_test.as --no-rsls
test: build
	test/test-with-process tmp/flash_test.swf
	test/test-without-process tmp/flash_test.swf
	test/test-with-process tmp/flex_test.swf
	test/test-without-process tmp/flex_test.swf
	@echo '#'
	@echo '#  Readline functionality is tested manually:'
	@echo '#  $ bin/run-swf tmp/interactive_test.swf'
	@echo '#'
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
