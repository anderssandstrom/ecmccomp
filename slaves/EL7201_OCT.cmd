#-d /**
#-d   \brief SDOS for EL7201 drive OCT
#-d   \details Parametrization of EL7201
#-d   \author Anders Sandström
#-d   \file
#-d   \note Max current= 5.7 A
#-d   \note Max voltage= 48 V
#-d */

#- Drive type
epicsEnvSet(SLAVE_TYPE,"EL72XX_OCT_SERVO")

#- Currents
epicsEnvSet(DRV_I_MAX_MA,5700)

#- Currents (nominal)
epicsEnvSet(DRV_I_NOM_MA,2800)

#- Voltage
epicsEnvSet(DRV_U_MAX_MV,48000)

#- SDOS script
epicsEnvSet(SLAVE_SCRIPT,"EL72XX_OCT_SDOS")

#- Channel count
epicsEnvSet(SLAVE_CHANNELS,"1")