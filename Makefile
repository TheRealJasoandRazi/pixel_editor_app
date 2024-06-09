BASE_HREF = "/pixel_editor_app/"

deploy:
	@echo "Building for web..."
	flutter build web --base-href $(BASE_HREF) --release

	@echo "Deploying to GitHub Pages..."
	npx gh-pages -d "build/web"

	@echo "✅ Finished deploy"

.PHONY: deploy
