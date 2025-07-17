# Root where your Lambda source lives
LAMBDA_DIR := lambda_files
BUILD_DIR := build/lambda

# Detect each Lambda function directory
LAMBDA_FUNCTIONS := $(shell find $(LAMBDA_DIR) -mindepth 1 -maxdepth 1 -type d)
ZIP_TARGETS := $(patsubst $(LAMBDA_DIR)/%, $(BUILD_DIR)/%.zip, $(LAMBDA_FUNCTIONS))

.PHONY: all clean show

# Default target: zip each Lambda subfolder
all: $(ZIP_TARGETS)

# Create zip for each Lambda function
$(BUILD_DIR)/%.zip: $(LAMBDA_DIR)/%
	@mkdir -p $(dir $@)                # Ensure parent directory (build/lambda/) exists
	@cd $< && zip -r $(abspath $@) . > /dev/null
	@echo "✅ Zipped $< → $@"

# Clean up
clean:
	rm -rf build/lambda
	@echo "🧹 Cleaned build/lambda directory."

# Show what it will zip
show:
	@echo "📦 Found Lambda functions in $(LAMBDA_DIR):"
	@for f in $(LAMBDA_FUNCTIONS); do echo " - $$f"; done
