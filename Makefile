BUILD_DIR = build/web
BASE_HREF = "/pixel_editor_app/"

deploy:
	@echo "Building for web..."
	flutter build web --base-href $(BASE_HREF) --release

	@echo "Deploying to GitHub Pages..."
	npx gh-pages -d $(BUILD_DIR)

	@echo "✅ Finished deploy"

.PHONY: deploy