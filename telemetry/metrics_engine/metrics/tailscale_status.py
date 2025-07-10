import subprocess
import json
from telemetry.metrics_engine.base import Metric


class TailscaleStatus(Metric):
    metric_name = "tailscale_status"

    def generate_metric(self):
        try:
            result = subprocess.run(
                ["tailscale", "status", "--json"],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                check=True,
                text=True
            )
            status_data = json.loads(result.stdout)
            status_data.pop("Peer", None)
            return status_data
        except (subprocess.CalledProcessError, json.JSONDecodeError, FileNotFoundError) as e:
            return dict()
