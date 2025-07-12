import subprocess
from telemetry.metrics_engine.base import Metric


def parse_mount_status(options: str) -> str:
    """Returns 'rw' or 'ro' based on exact match in mount options."""
    options_list = [opt.strip() for opt in options.split(",")]
    if "rw" in options_list:
        return "rw"
    if "ro" in options_list:
        return "ro"
    return "unknown"


def get_mount_health():
    output = subprocess.check_output(["mount"]).decode()
    lines = [line for line in output.splitlines() if "mmcblk0" in line]

    health = "healthy"
    partitions = list()

    for line in lines:
        parts = line.split()
        device = parts[0]
        mount_point = parts[2]
        options = line[line.find("(") + 1 : line.find(")")]
        status = parse_mount_status(options)

        if mount_point == "/" and status != "rw":
            health = "unhealthy"

        partition_data = dict()
        partition_data["device"] = device
        partition_data["mount_point"] = mount_point
        partition_data["status"] = status
        partition_data["full_message"] = line
        partitions.append(partition_data)
    payload = dict()
    payload["overall_health"] = health
    payload["partitions"] = partitions
    return payload


class MountStatusMetric(Metric):
    metric_name = "mount_status"

    def generate_metric(self):
        return get_mount_health()
