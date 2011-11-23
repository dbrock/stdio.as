build:
	fcshc src/test_sprite.as --no-flex
	fcshc src/test_sprite_unplugged.as --no-flex
	fcshc src/test_spark.mxml
	fcshc src/test_spark_unplugged.mxml
test: build
	node test.js
