.PHONY: help
help:
	@echo "make iridescence|gtsam_points|glim_ros1|glim_ros2|depends|glim_ros|deploy"

.PHONY: iridescence
iridescence:
	@echo "Building Iridescence binaries..."
	cd packages && ./build_iridescence.sh

.PHONY: gtsam_points
gtsam_points:
	@echo "Building gtsam_points binaries..."
	cd packages && ./build_gtsam_points.sh

.PHONY: glim_ros1
glim_ros1:
	@echo "Building gtsam_ros1 binaries..."
	cd packages && ./build_glim_ros1.sh

.PHONY: glim_ros2
glim_ros2:
	@echo "Building gtsam_ros2 binaries..."
	cd packages && ./build_glim_ros2.sh

.PHONY: depends
depends: iridescence gtsam_points
	@echo "Building dependent binaries..."

.PHONY:
glim_ros: glim_ros1 glim_ros2
	@echo "Building glim_ros1 and glim_ros2 binaries..."

.PHONY: deploy
deploy:
	@echo "Deploying binaries..."
	sudo chown -R koide:koide packages/ubuntu*
	cp -r packages/ubuntu* ./
	./update.sh
