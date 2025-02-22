# mock-haul-truck-robot-tests
Automated testing suite for simulated haul truck CAN bus using Robot Framework. This project validates vehicle telemetry, diagnostics, and emergency stop values with a mock truck and CAN bus.

## How to Setup Virtual CAN Bus (Must be using linux)

Load the virtual CAN module
`sudo modprobe vcan`

Create virtual CAN interface 'vcan0'
`sudo ip link add dev vcan0 type vcan`

Bring it up
`sudo ip link set up vcan0`

Verify it exists
`ip link show vcan0`

## Install Python dependencies
`pip install -r requirements.txt`

## Run Robot Tests
Ensure vcan0 is set up correctly.

Go to tests folder
`cd tests`

Run tests
`robot telemetry_tests.robot`
