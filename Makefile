BASE_HREF = "/pixel_editor_app/"
GITHUB_USER = TheRealJasoandRazi
GITHUB_REPO = https://github.com/$(GITHUB_USER)/deployment
BUILD_VERSION := $(shell grep 'version:' pubspec.yaml | awk '{print $$2}')

deploy:
	@echo "Building for web..."
	flutter build web --base-href $(BASE_HREF) --release

	@echo "Deploying to git repository"
	git config user.email "Neno701@outlook.com" && \
    git config user.name "Nemanja" && \
	cd build/web && \
	git init && \
	git add . && \
	git commit -m "Deploy Version $(BUILD_VERSION)" && \
	git branch -M main && \
	git remote add origin $(GITHUB_REPO) && \
	git push -u -f origin main

	@echo "✅ Finished deploy"

.PHONY: deploy
