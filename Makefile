build:
	docker build \
		--build-arg ansible_base_version=2.11-tools-0.39 \
		--build-arg cidre_version=0.12.1 \
		--build-arg helm_version=3.7.1 \
		--build-arg keployr_version=1.0.7 \
		--build-arg BUILDKIT_INLINE_CACHE=1 \
		--platform linux/arm64v8 \
		-t local-keployr .