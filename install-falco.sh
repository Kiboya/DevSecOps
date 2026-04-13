#!/bin/bash
echo "Installing Falco (Runtime Security)..."
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update
# Using the eBPF driver which is modern and works better in nested virtual environments
helm upgrade --install falco falcosecurity/falco \
  --namespace falco \
  --create-namespace \
  --set driver.kind=ebpf \
  --set tty=true \
  --set falcosidekick.enabled=true \
  --set falcosidekick.webui.enabled=true
echo "Falco is installing. Run 'kubectl get pods -n falco' to check the status."