*** Settings ***
Library    ../mock_can/CANLibrary.py

*** Variables ***
${SPEED_CAN_ID}      0x100
${RPM_CAN_ID}        0x101
${FUEL_CAN_ID}       0x102
${PAYLOAD_CAN_ID}    0x104
${VOLTAGE_CAN_ID}    0x105
${PRESSURE_CAN_ID}   0x106
${BRAKE_CAN_ID}      0x107
${GPS_CAN_ID}        0x200

*** Test Cases ***

Set Truck to Idle State
    [Documentation]  Set the truck to an idle state with speed=0, RPM=500.
    
    ${speed} =  Evaluate  int(0)
    ${rpm} =  Evaluate  int(500)
    ${fuel} =  Evaluate  int(100)
    ${payload} =  Evaluate  int(50)
    ${voltage} =  Evaluate  int(26)
    ${pressure} =  Evaluate  int(250)
    ${brake} =  Evaluate  int(1)

    Set Truck State  speed=${speed}  rpm=${rpm}  fuel=${fuel}  payload=${payload}  voltage=${voltage}  pressure=${pressure}  brake=${brake}
    Sleep  2

Verify Vehicle Speed is Zero at Idle
    [Documentation]  Ensure the speed is reported as zero in idle state.
    ${msg} =  Wait For CAN Message  ${SPEED_CAN_ID}
    ${expected_value} =  Evaluate  int(0)

    Should Be Equal  ${msg}[0]  ${expected_value}

Verify RPM is in Idle Range
    [Documentation]  Ensure RPM is around 500 when idle.
    Set Truck State  rpm=500
    ${msg} =  Wait For CAN Message  ${RPM_CAN_ID}
    ${expected_value} =  Evaluate  int(500)

    Should Be Equal  ${msg}  ${expected_value}

Test Speed Increase
    [Documentation]  Set truck speed to 30 km/h and verify it.
    Set Truck State  speed=30
    Sleep  2
    ${msg} =  Wait For CAN Message  ${SPEED_CAN_ID}
    ${expected_value} =  Evaluate  int(30)

    Should Be Equal  ${msg}[0]  ${expected_value}

Test Fuel Consumption Over Time
    [Documentation]  Reduce fuel level and verify it updates correctly.
    Set Truck State  fuel=80
    Sleep  2
    ${msg} =  Wait For CAN Message  ${FUEL_CAN_ID}
    ${expected_value} =  Evaluate  int(80)

    Should Be Equal  ${msg}[0]  ${expected_value}

Test Voltage Drop Under Load
    [Documentation]  Simulate high power demand and verify voltage drop.
    Set Truck State  voltage=23
    Sleep  2
    ${msg} =  Wait For CAN Message  ${VOLTAGE_CAN_ID}
    ${expected_value} =  Evaluate  int(23)

    Should Be Equal  ${msg}[0]  ${expected_value}

Test Brake Status Change
    [Documentation]  Simulate brakes being released.
    Set Truck State  brake=0
    Sleep  2
    ${msg} =  Wait For CAN Message  ${BRAKE_CAN_ID}
    ${expected_value} =  Evaluate  int(0)

    Should Be Equal  ${msg}[0]  ${expected_value}
