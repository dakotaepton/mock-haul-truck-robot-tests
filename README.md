# mock-haul-truck-robot-tests
Automated API testing suite for mining autonomy systems using Robot Framework. This project validates vehicle telemetry, diagnostics, and emergency stop functions with mock APIs. Includes data-driven testing, CI/CD integration with GitHub Actions, and detailed test reports.

# How to Setup Virtual CAN Bus (Must be using linux)

Load the virtual CAN module
`sudo modprobe vcan`

Create virtual CAN interface 'vcan0'
`sudo ip link add dev vcan0 type vcan`

Bring it up
`sudo ip link set up vcan0`

Verify it exists
`ip link show vcan0`