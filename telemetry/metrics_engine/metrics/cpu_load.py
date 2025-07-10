import os
from telemetry.metrics_engine.base import Metric


def get_cpu_load_avg():
    """Builds a clean CPU load telemetry payload."""
    load1, load5, load15 = os.getloadavg()
    num_cores = os.cpu_count()

    load_averages = dict()
    load_averages["load_1m"] = round(load1, 2)
    load_averages["load_5m"] = round(load5, 2)
    load_averages["load_15m"] = round(load15, 2)

    load_percentages = dict()
    load_percentages["load_1m"] = round((load1 / num_cores) * 100, 2)
    load_percentages["load_5m"] = round((load5 / num_cores) * 100, 2)
    load_percentages["load_15m"] = round((load15 / num_cores) * 100, 2)

    status = "healthy" if load_percentages["load_1m"] < 90 else "overloaded"

    payload = dict()
    payload["load_avg"] = load_averages
    payload["load_pct"] = load_percentages
    payload["num_cores"] = num_cores
    payload["status"] = status

    return payload


class CPULoad(Metric):
    metric_name = "cpu_load"

    def generate_metric(self):
        return get_cpu_load_avg()
