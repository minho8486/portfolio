FUNCTION ZFA3MM6014.


*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_MATID) TYPE  ZTA3MM0001-MATID
*"  EXPORTING
*"     REFERENCE(ES_ENTITY) TYPE  ZCL_ZGWA3MM6001_MPC=>TS_ESMATDETAIL
*"     REFERENCE(EV_SUBRC) TYPE  SY-SUBRC
*"----------------------------------------------------------------------



*       Global data declarations


  PERFORM get_material_data USING iv_matid
                            CHANGING es_entity ev_subrc.


ENDFUNCTION.
