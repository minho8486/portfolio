FUNCTION ZFA3MM6015.


*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_PLAID) TYPE  ZTTA3MM6002
*"     REFERENCE(IT_STOID) TYPE  ZTTA3MM6006
*"  EXPORTING
*"     REFERENCE(ET_ENTITYSET) TYPE  ZCL_ZGWA3MM6002_MPC=>TT_ESSTO
*"----------------------------------------------------------------------



*       Global data declarations


  PERFORM get_stoid_search_help USING it_plaid it_stoid
                                CHANGING et_entityset.


ENDFUNCTION.
