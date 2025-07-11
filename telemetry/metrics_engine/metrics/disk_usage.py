import shutil
from telemetry.metrics_engine.base import Metric


def get_disk_usage(path="/"):
    """Returns disk usage stats for a given path."""
    total, used, free = shutil.disk_usage(path)
    total_gb = round(total / (1024**3), 2)
    used_gb = round(used / (1024**3), 2)
    free_gb = round(free / (1024**3), 2)
    percent_used = round(used / total * 100, 2)
    payload = dict()
    payload["path"] = path
    payload["total_gb"] = total_gb
    payload["used_gb"] = used_gb
    payload["free_gb"] = free_gb
    payload["percent_used"] = percent_used
    return payload


class DiskUsageMetric(Metric):
    metric_name = "disk_usage"

    def generate_metric(self):
        return get_disk_usage("/")
