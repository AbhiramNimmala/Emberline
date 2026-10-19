PY ?= python3
export PYTHONPATH := $(CURDIR)

.PHONY: help setup data demo australia india static-check web all test lint fmt serve docker clean
help:            ## list targets
	@grep -E '^[a-z-]+:.*##' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-12s %s\n", $$1, $$2}'
setup:           ## install runtime + dev dependencies
	$(PY) -m pip install -e '.[api,dev]'
data:            ## download every real input into data/raw
	./scripts/fetch_real_data.sh
demo:            ## simulated 26-year California record: harmonise, validate, export
	$(PY) scripts/run_demo.py --out build/demo --cache build/simcache
australia:       ## real NASA FIRMS (4 sensors) over Australia: harmonise + cross-validate
	$(PY) scripts/run_australia.py --out build/australia
india:           ## real VIIRS season over southern India: filter vs FIRMS labels on a map
	$(PY) scripts/run_india.py --out build/india
static-check:    ## score the static-source filter against real FIRMS type labels
	$(PY) scripts/validate_static_real.py
web:             ## bundle data + imagery into build/emberline.html
	$(PY) scripts/build_web.py
all: demo australia india static-check web   ## everything, in order
test:            ## unit + end-to-end tests
	$(PY) -m pytest -q
lint:            ## ruff
	ruff check emberline scripts tests
fmt:
	ruff format emberline scripts tests
serve:           ## API + web app on :8000
	$(PY) -m emberline.cli serve --build build/demo
docker:          ## container with API + web app
	docker build -t emberline . && docker run --rm -p 8000:8000 emberline
clean:
	rm -rf build .pytest_cache
