#==============================================================================
# validateEL72XX_RES_SERVO.cmd
#-d /**
#-d   \brief Script for validation of EL72XX_OCT_SERVO
#-d   \author Anders Sandström
#-d   \file

#-===== Validate HW_DESC matches component ===
ecmcEpicsEnvSetCalcTernary(DIE,"'EL72XX_RES_SERVO' in '${SLAVE_TYPE}'","#-", "")
${DIE}ecmcExit Error: Component and slave do not matching

#- Common validation for EL72XX OCT and RES version
< ${ecmccomp_DIR}validateEL72XX_XXX_SERVO.cmd
