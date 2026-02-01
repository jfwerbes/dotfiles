#!/bin/bash
DEVICE="LID0" # Replace LID0 with your device name if different
# Check if the device is disabled and enable it if needed
if grep -qw "\$DEVICE.*disabled" /proc/acpi/wakeup; then
  echo "\$DEVICE" > /proc/acpi/wakeup
fi
EOF'
