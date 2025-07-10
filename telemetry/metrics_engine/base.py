from telemetry.metrics_engine.registry import metric_registry

class Metric:
    metric_name = None

    def __init_subclass__(cls):
        super().__init_subclass__()
        name = getattr(cls, 'metric_name', None)
        if not isinstance(name, str) or not name:
            raise TypeError(f"{cls.__name__} must define a class-level 'metric_name' string")
        metric_registry.register(name, cls())

    def generate_metric(self):
        raise NotImplementedError
