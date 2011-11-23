build:
	fcshc src/test_sprite.as --no-flex
	fcshc src/test_spark.mxml
test: build
	node test.js
