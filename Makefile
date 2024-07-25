.PHONY: help
help:
	@echo "make iridescence|gtsam_points|glim_ros2|all|deploy"

.PHONY: iridescence
iridescence:
	@echo "Building Iridescence binaries..."
	cd packages && ./build_iridescence.sh

.PHONY: gtsam_points
gtsam_points:
	@echo "Building gtsam_points binaries..."
	cd packages && ./build_gtsam_points.sh

.PHONY: glim_ros2
gtsam_ros2:
	@echo "Building gtsam_ros2 binaries..."
	cd packages && ./build_glim_ros2.sh

.PHONY: all
all: iridescence gtsam_points
	@echo "Building all binaries..."

.PHONY: deploy
deploy:
	@echo "Deploying binaries..."
	sudo chown -R koide:koide packages/ubuntu*
	cp -r packages/ubuntu* ./
	./update.sh
