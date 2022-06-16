
#ifndef ADF4159_H
#define ADF4159_H


/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"
#include "xil_io.h"

#define ADF4159_TRANSFER_START_OFFSET  0
#define ADF4159_TX_BUFF_OFFSET         4
#define ADF4159_TRANSFER_STATUS_OFFSET 8
#define ADF4159_MUXOUT_OFFSET          12
#define ADF4159_S0_AXI_SLV_REG4_OFFSET 16


/**************************** Type Definitions *****************************/
/**
 * This typedef contains configuration information for the device.
 */
typedef struct {
	u16 DeviceId;		/* Unique ID  of device */
	UINTPTR BaseAddress;	/* Device base address */
} Adf4159_Config;

typedef struct {
	UINTPTR BaseAddress;	/* Device base address */
	u32 IsReady;
} Adf4159;

/************************** Variable Definitions ****************************/

extern Adf4159_Config Adf4159_ConfigTable[];

/**
 *
 * Write a value to a ADF4159 register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the ADF4159device.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void ADF4159_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
 *
 */
#define ADF4159_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

/**
 *
 * Read a value from a ADF4159 register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the ADF4159 device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	u32 ADF4159_mReadReg(u32 BaseAddress, unsigned RegOffset)
 *
 */
#define ADF4159_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))

/************************** Function Prototypes ****************************/
/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the ADF4159 instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus ADF4159_Reg_SelfTest(void * baseaddr_p);

Adf4159_Config * Adf4159_LookupConfig(u16 DeviceId);

XStatus Adf4159_Initialize(Adf4159 * InstancePtr, u16 DeviceId);

XStatus Adf4159_CfgInitialize(Adf4159 * InstancePtr, Adf4159_Config * Config);

Xstatus Adf4159_WriteReg(Adf4159 * InstancePtr, u32 reg);

u32 Adf4159_ReadMuxOut(Adf4159 * InstancePtr);

#endif // ADF4159_H
