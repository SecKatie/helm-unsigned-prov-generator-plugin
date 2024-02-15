PLUGIN_NAME := $(shell command -v yq >/dev/null 2>&1 && yq '.name' plugin.yaml || echo "")

test: testcharts/apache
	@echo "\033[0;34m[INFO]\033[0m Running tests..."
	@helm $(PLUGIN_NAME) testcharts/apache

reinstall: uninstall install
	@echo "\033[0;32m[SUCCESS]\033[0m Reinstall complete. *Happy Helming!*"

install: yq-check
	@echo "\033[0;34m[INFO]\033[0m Installing..."
	@helm plugin install .
	@echo "\033[0;32m[SUCCESS]\033[0m Install complete."

uninstall: yq-check
	@echo "\033[0;34m[INFO]\033[0m Uninstalling..."
	@helm plugin remove $(PLUGIN_NAME)
	@echo "\033[0;32m[SUCCESS]\033[0m Uninstall complete."

yq-check:
	@echo "\033[0;34m[INFO]\033[0m Checking for required tools..."
	@command -v yq >/dev/null 2>&1 || { echo "yq is required but it's not installed.  Aborting." >&2; exit 1; }
	@echo "\033[0;32m[SUCCESS]\033[0m yq is installed."

testcharts/apache:
	@echo "\033[0;34m[INFO]\033[0m Getting test chart..."
	@helm repo add bitnami https://charts.bitnami.com/bitnami
	@helm repo update
	@mkdir -p testcharts
	@helm pull bitnami/apache -d testcharts --untar
	@echo "\033[0;32m[SUCCESS]\033[0m Test chart downloaded."

.PHONY: reinstall install uninstall run yq-check