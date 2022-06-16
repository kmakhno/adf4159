

/***************************** Include Files *******************************/
#include "adf4159.h"

/************************** Function Definitions ***************************/
Adf4159_Config * Adf4159_LookupConfig(u16 DeviceId) {
    Adf4159_Config *CfgPtr = NULL;
    int Index;
    for (Index = 0; Index < XPAR_ADF4159_NUM_INSTANCES; Index++) {
        if (Adf4159_ConfigTable[Index].DeviceId == DeviceId) {
            CfgPtr = &Adf4159_ConfigTable[Index];
            break;
        }
    }
    return CfgPtr;
}

XStatus Adf4159_Initialize(Adf4159 * InstancePtr, u16 DeviceId) {
    Adf4159_Config * ConfigPtr;
    ConfigPtr = Adf4159_LookupConfig(DeviceId);
    if (ConfigPtr == (Adf4159_Config *) NULL) {
        InstancePtr->IsReady = 0;
        return (XST_DEVICE_NOT_FOUND);
    }
    return Adf4159_CfgInitialize(InstancePtr, ConfigPtr);
}

XStatus Adf4159_CfgInitialize(Adf4159 * InstancePtr, Adf4159_Config * Config) {
    /* Set some default values. */
    InstancePtr->BaseAddress = Config->BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;
    return (XST_SUCCESS);
}

Xstatus Adf4159_WriteReg(Adf4159 * InstancePtr, u32 reg)
{
    ADF4159_mWriteReg(InstancePtr->BaseAddress, ADF4159_TX_BUFF_OFFSET, reg);
    ADF4159_mWriteReg(InstancePtr->BaseAddress, ADF4159_TRANSFER_START_OFFSET, 1);
    while (ADF4159_mReadReg(InstancePtr->BaseAddress, ADF4159_TRANSFER_STATUS_OFFSET) == 0);
    return XST_SUCCESS;
}

u32 Adf4159_ReadMuxOut(Adf4159 * InstancePtr) 
{
    return ADF4159_mReadReg(InstancePtr->BaseAddress, ADF4159_MUXOUT_OFFSET);
}