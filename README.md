# burrowingowl_o11ly

**burrowingowl_o11ly** is a modular and extensible observability system for Raspberry Pi devices. It enables secure provisioning, telemetry capture, real-time log streaming, and centralized monitoring using AWS services. The entire infrastructure can be deployed with a single `terraform init`.

## Features

- Modular infrastructure-as-code using Terraform
- Automated device provisioning with secure certificate management
- Real-time metrics and log collection
- Pluggable metrics engine (CPU, memory, disk, network, uptime, etc.)
- MQTT-based telemetry publishing via AWS IoT Core
- Kinesis + Lambda + CloudWatch integration for log streaming
- Centralized log and metric visualization (Grafana-ready)

## Metrics Engine

Located in `telemetry/metrics_engine/metrics/`, the engine supports pluggable modules:

- `cpu_temp.py`
- `cpu_load.py`
- `disk_usage.py`
- `uptime_seconds.py`
- `tailscale_status.py`
- `system_info.py`

All metrics are registered via `registry.py` and published via `iot_core/publisher.py`.

## Lambda and Log Streaming

- Lambda function: `lambda_files/kinesis_sink_to_log_group/`
- Packaged artifact: `build/lambda/kinesis_sink_to_log_group.zip`
- Deployed via Terraform as part of the log pipeline
- Metrics and logs stream into CloudWatch and/or Timestream for long-term analysis

## Security

- AWS IoT Core device authentication using X.509 certificates
- IAM roles and policies defined per component
- Secrets and certificates should be rotated and managed securely

## Extending

- Add new metrics under `telemetry/metrics_engine/metrics/`
- Define new Terraform modules in `infrastructure/modules/`
- Extend IoT topic rules or Lambda functions as needed
