#-d /**
#-d   \brief SDOS for EL5042 
#-d   \details Parametrization of EL5042 2CH BISS-C encoder interface
#-d   \author Anders Sandström
#-d   \file
#-d */

#- Type
epicsEnvSet(SLAVE_TYPE,BISS_C_IF)

#- SDOS script
epicsEnvSet(SLAVE_SCRIPT,"EL5042_SDOS")

#- Channel count
epicsEnvSet(SLAVE_CHANNELS,"2")
