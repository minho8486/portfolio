FUNCTION ZFA3MM6021.


*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_MATID) TYPE  ZTTA3MM6001 OPTIONAL
*"     REFERENCE(IT_BATID) TYPE  ZTTA3MM6003 OPTIONAL
*"     REFERENCE(IT_PLAID) TYPE  ZTTA3MM6002 OPTIONAL
*"     REFERENCE(IV_DAYS) TYPE  INT4
*"  EXPORTING
*"     REFERENCE(ET_ENTITYSET) TYPE  ZCL_ZGWA3MM6003_MPC=>TT_ESEXPLIST
*"----------------------------------------------------------------------



*       Global data declarations


  PERFORM get_exp_data USING it_matid it_plaid it_batid iv_days
                       CHANGING et_entityset.


ENDFUNCTION.
