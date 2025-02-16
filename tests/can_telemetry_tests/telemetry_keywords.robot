*** Settings ***
Library    ../../mock_can/CANLibrary.py
Library    ../../mock_can/truck_simulator.py
Library    Process

*** Keywords ***

Set Truck Telemetry
    [Arguments]  
    ...  ${speed}=None  ${rpm}=None  ${fuel}=None  ${payload}=None  ${voltage}=None  ${pressure}=None  ${brake}=None  
    ...  ${brake_failure}=None  ${start_engine}=None  ${emergency_stop}=None  ${autonomy_mode}=None  

    [Documentation]  Set the truck telemetry state based on provided values.

    Set Truck State  
    ...  speed=${speed}  rpm=${rpm}  fuel=${fuel}  payload=${payload}  voltage=${voltage}  
    ...  pressure=${pressure}  brake=${brake}  brake_failure=${brake_failure}  start_engine=${start_engine}  
    ...  emergency_stop=${emergency_stop}  autonomy_mode=${autonomy_mode}
    Sleep  2


Verify CAN Message
    [Arguments]  ${can_id}  ${expected_value}
    [Documentation]  Wait for a CAN message and verify its value.
    ${msg} =  Wait For CAN Message  ${can_id}
    ${expected_value} =  Evaluate  int(${expected_value})
    Should Be Equal  ${msg}  ${expected_value}


Start Truck Simulator
    [Documentation]  Start the truck simulator as a background process.
    ${SIMULATOR_PROCESS} =  Start Process  python  ../../mock_can/truck_simulator.py
    Set Global Variable  ${SIMULATOR_PROCESS}


Shutdown Truck Simulator
    [Documentation]  Ensure the truck simulator is properly terminated after tests.
    Terminate Process  ${SIMULATOR_PROCESS}