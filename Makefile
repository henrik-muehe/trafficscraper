CLIENT_TEMPLATES=$(patsubst views/%,public/%,$(wildcard views/*.handlebars views/**/*.handlebars views/*.ejs views/**/*.ejs))
JS_FILES=server.js traffic.js config.js $(patsubst src/%.coffee,public/%.js,$(wildcard src/*.coffee src/**/*.coffee))

all: $(JS_FILES) $(CLIENT_TEMPLATES)

public/%.html: views/%.jade $(wildcard views/*.jade views/*/*.jade)
	./node_modules/jade/bin/jade -o $(dir $@) $<

public/%.js: src/%.coffee
	@mkdir -p $(dir $@)
	./node_modules/coffee-script/bin/coffee -o $(dir $@) -c $<

%.js: %.coffee
	./node_modules/coffee-script/bin/coffee -c $<

public/%.handlebars: views/%.handlebars
	@mkdir -p $(dir $@)
	cp $< $@

public/%.ejs: views/%.ejs
	@mkdir -p $(dir $@)
	cp $< $@

install:
	npm install
	./node_modules/jamjs/bin/jam.js install

run: all
	@kill `cat server.pid`; true
	@node server & echo $$! > server.pid

stats:
	cloc --exclude-dir=public,old,data,node_modules --force-lang=html,jade .

nodemon:
	./node_modules/nodemon/nodemon.js --watch . --ext jade,coffee,handlebars --exec 'make run' .

.PHONY: clean install all run nodemon stats
