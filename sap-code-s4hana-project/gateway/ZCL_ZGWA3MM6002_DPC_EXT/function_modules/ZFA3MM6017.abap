FUNCTION ZFA3MM6017.


*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_MATID) TYPE  ZTTA3MM6001
*"     REFERENCE(IT_BATID) TYPE  ZTTA3MM6003
*"     REFERENCE(IT_PLAID) TYPE  ZTTA3MM6002
*"     REFERENCE(IT_STOID) TYPE  ZTTA3MM6006
*"  EXPORTING
*"     REFERENCE(ET_ENTITYSET) TYPE  ZCL_ZGWA3MM6002_MPC=>TT_ESSTOCKADJ
*"     REFERENCE(EV_SUBRC) TYPE  SY-SUBRC
*"----------------------------------------------------------------------



*       Global data declarations


  PERFORM get_inventory_data USING it_matid it_batid it_plaid it_stoid
                             CHANGING et_entityset ev_subrc.


ENDFUNCTION.
