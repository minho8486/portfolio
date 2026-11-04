FUNCTION ZFA3MM6016.


*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_BATID) TYPE  ZTTA3MM6003
*"     REFERENCE(IT_MATID) TYPE  ZTTA3MM6001
*"  EXPORTING
*"     REFERENCE(ET_ENTITYSET) TYPE  ZCL_ZGWA3MM6002_MPC=>TT_ESBAT
*"----------------------------------------------------------------------



*       Global data declarations


  PERFORM get_batid_search_help USING it_batid it_matid
                                CHANGING et_entityset.


ENDFUNCTION.
