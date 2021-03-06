SHELL := /bin/bash
PATH  := node_modules/.bin:$(PATH)
DIST  := build

build: clean javascript style package.json documentation

javascript:
	./bin/bundle

style:
	mkdir -p $(DIST)
	cp -r style $(DIST)/style
	node-sass ./$(DIST)/style/colonel.scss --stdout > $(DIST)/colonel-kurtz.css

package.json:
	mkdir -p $(DIST)
	node -p 'p=require("./package");p.main="colonel.js";p.private=undefined;p.scripts=p.devDependencies=undefined;JSON.stringify(p,null,2)' > $(DIST)/package.json

documentation: README.md LICENSE.md docs
	mkdir -p $(DIST)
	cp -r $^ $(DIST)

release: clean build
	npm publish $(DIST)

prerelease: clean build
	npm publish $(DIST) --tag beta

clean:
	rm -rf $(DIST)

.PHONY: build javascript style documentation release prerelease clean package.json
