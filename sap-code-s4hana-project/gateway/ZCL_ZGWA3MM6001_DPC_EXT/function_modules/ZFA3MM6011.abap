FUNCTION ZFA3MM6011.


*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_MATID) TYPE  ZTTA3MM6001
*"     REFERENCE(IT_PLAID) TYPE  ZTTA3MM6002
*"     REFERENCE(IT_HSDAT) TYPE  ZTTA3MM6004
*"  EXPORTING
*"     REFERENCE(ET_ENTITYSET) TYPE  ZCL_ZGWA3MM6001_MPC=>TT_ESMATERIAL
*"----------------------------------------------------------------------


*       Global data declarations


  PERFORM get_inven_data USING it_matid it_plaid it_hsdat
                         CHANGING et_entityset.

ENDFUNCTION.
