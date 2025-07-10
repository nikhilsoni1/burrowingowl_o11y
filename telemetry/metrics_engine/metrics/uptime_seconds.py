from telemetry.metrics_engine.base import Metric


def get_uptime_seconds():
    """Returns system uptime in seconds as an integer."""
    try:
        with open("/proc/uptime", "r") as f:
            uptime = int(float(f.readline().split()[0]))
            return uptime
    except Exception:
        return -1  # fallback in case of error


class UptimeSecondsMetric(Metric):
    metric_name = "uptime_seconds"

    def generate_metric(self):
        return get_uptime_seconds()
