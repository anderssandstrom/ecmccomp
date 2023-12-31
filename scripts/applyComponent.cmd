#==============================================================================
# applyComponent.cmd
#- Arguments: COMP [EC_COMP_TYPE, COMP_S_ID = 0, CH_ID = 1, MACROS='']
#-d /**
#-d   \brief Script for adding component configuration to a ethercat slave
#-d   \author Anders Sandström
#-d   \file
#-d   \param COMP Component name
#-d   \param EC_COMP_TYPE   (optional) Hardware descriptor, i.e. EL7037, defaults to ECMC_EC_COMP_TYPE or ECMC_EC_HWTYPE set in ecmccfg/addSlave.cmd
#-d   \param COMP_S_ID      (optional) Slave bus position, defaults to ECMC_EC_SLAVE_NUM set in ecmccfg/addSlave.cmd
#-d   \param CH_ID          (optional) Channel of slave default to 1
#-d   \param MACROS         (optional) Special macros, depending on component/slave type:
#-d          2PH_STEPPER    (general 2PH stepper cfgs):
#-d              I_MAX_MA     : Run current [mA] (Used to reduce max torque)
#-d              I_STDBY_MA   : Standby current [mA]
#-d              U_NOM_MV     : Supply voltage [mV]
#-d              INV_DIR      : Invert motor direction (0 = not invert (default), 1 = invert dir)
#-d
#-d          EL72XX_RES_SERVO (cfg for EL72XX motor with resolver):
#-d              I_MAX_MA     : Max current [mA]  (Used to reduce max torque)
#-d              U_NOM_MV     : Supply voltage [mV] (defaults to Motor or Slave setting)
#-d              CURR_KP      : Current controller KP (defaults to motor setting)
#-d              CURR_TI      : Current controller TI (defaults to motor setting)
#-d              VELO_KP      : Velocity controller KP (defaults to motor setting)
#-d              VELO_TI      : Velocity controller TI (defaults to motor setting)
#-d              BRK_APP_DLY  : Brake application delay (defaults to motor setting or 0)
#-d              BRK_REL_DLY  : Brake release delay (defaults to motor setting or 0)
#-d
#-d          EL72XX_OCT_SERVO (cfg for EL72XX motor with OCT):
#-d              Same as EL72XX_RES_SERVO plus:
#-d              INV_DIR      : Invert motor direction (0 = not invert (default), 1 = invert dir)
#-d              ENC_OFF      : Offset encoder position (defaults to 0)
#-d
#-d          BISS_C_IF        :
#-d              CLK_FRQ      : Clock frequency (defaults to setting in encoder file)
#-d
#-d   \note Example calls:
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccomp_DIR}applyComponent.cmd, "EC_COMP_TYPE=EL7037,COMP=Motor-OrientalMotor-PK267JB-Parallel,MACROS='I_RUN_MA=1000'"
#-d */

epicsEnvSet(EC_COMP_TYPE, ${EC_COMP_TYPE=${ECMC_EC_COMP_TYPE=${ECMC_EC_HWTYPE}}})
epicsEnvSet(COMP_S_ID,${COMP_S_ID=${ECMC_EC_SLAVE_NUM=0}})

#- Remove the below since must be possible to apply more than one cfg to a slave
#- Ensure same slave and channel is not added twice in a row
#- ecmcEpicsEnvSetCalcTernary(BLOCK,"${SLAVE_ID}==${COMP_HW_OLD_SLAVE_ID=-100} and ${COMP_HW_OLD_SLAVE_CH=-100}==${CH_ID}","#-", "")
#- epicsEnvSet(COMP_HW_OLD_SLAVE_ID,${SLAVE_ID})
#- epicsEnvSet(COMP_HW_OLD_SLAVE_CH,${CH_ID})

#- Set variables for component
ecmcFileExist(${ecmccomp_DIR}${COMP}.cmd,1,1)
${SCRIPTEXEC} ${ecmccomp_DIR}${COMP}.cmd

#- Set variables for slave
ecmcFileExist(${ecmccomp_DIR}${EC_COMP_TYPE}.cmd,1,1)
${SCRIPTEXEC} ${ecmccomp_DIR}${EC_COMP_TYPE}.cmd

#- Validation generic
ecmcFileExist("${ecmccomp_DIR}validateGeneric.cmd",1,1)
${SCRIPTEXEC} ${ecmccomp_DIR}validateGeneric.cmd "CH_ID=${CH_ID=1},${MACROS=''}"

#- Validate macros
ecmcFileExist("${ecmccomp_DIR}validateMacros.cmd",1,1)
${SCRIPTEXEC} ${ecmccomp_DIR}validateMacros.cmd "MACROS='${MACROS=}',SUPP_MACROS='${SUPP_MACROS=}'"

#- Validate and set the variables that should be used in the configs
ecmcFileExist("${ecmccomp_DIR}validate${COMP_TYPE}.cmd",1,1)
${SCRIPTEXEC} ${ecmccomp_DIR}validate${COMP_TYPE}.cmd "CH_ID=${CH_ID=1},${MACROS=''}"

#- Apply configuration
ecmcFileExist("${ecmccomp_DIR}${SLAVE_SCRIPT}.cmd",1,1)
${SCRIPTEXEC} ${ecmccomp_DIR}${SLAVE_SCRIPT}.cmd "CH_ID=${CH_ID=1},${MACROS=''}"

#- Cleanup component specific
ecmcFileExist("${ecmccomp_DIR}cleanup${COMP_TYPE}.cmd",1,1)
${SCRIPTEXEC} ${ecmccomp_DIR}cleanup${COMP_TYPE}.cmd

#- Cleanup Generic
ecmcFileExist("${ecmccomp_DIR}cleanupGeneric.cmd",1,1)
${SCRIPTEXEC} ${ecmccomp_DIR}cleanupGeneric.cmd
