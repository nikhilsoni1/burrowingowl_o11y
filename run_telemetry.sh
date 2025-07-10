#!/bin/bash
set -e

# Absolute path to your project
PROJECT_DIR="/home/pi/workspace/burrowingowl_o11y"

# Navigate to the project
cd "$PROJECT_DIR"

# Activate the virtual environment
source .venv/bin/activate

# Run the telemetry module
python -m telemetry.main
