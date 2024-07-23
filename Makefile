.PHONY: help
help:
	@echo "make iridescence|gtsam_points|all|deploy"

.PHONY: iridescence
iridescence:
	@echo "Building Iridescence binaries..."
	cd packages && ./build_iridescence.sh

.PHONY: gtsam_points
gtsam_points:
	@echo "Building gtsam_points binaries..."
	cd packages && ./build_gtsam_points.sh

.PHONY: all
all: iridescence gtsam_points
	@echo "Building all binaries..."

.PHONY: deploy
deploy:
	@echo "Deploying binaries..."
	sudo chown -R koide:koide packages/ubuntu*
	cp -r packages/ubuntu* ./
	./update.sh
