class MetricRegistry:
    def __init__(self):
        self._registry = {}

    def register(self, name, instance):
        if name in self._registry:
            raise ValueError(f"Duplicate metric_name '{name}'")
        self._registry[name] = instance

    def get(self, name):
        return self._registry[name]

    def all(self):
        return self._registry


# singleton
metric_registry = MetricRegistry()
