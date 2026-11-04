FUNCTION ZFA3MM6012.


*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_MTEXT) TYPE  ZTTA3MM6005
*"  EXPORTING
*"     REFERENCE(ET_ENTITYSET) TYPE  ZCL_ZGWA3MM6001_MPC=>TT_ESMAT
*"----------------------------------------------------------------------


*       Global data declarations


  PERFORM get_material_search_help USING it_mtext
                                   CHANGING et_entityset.
ENDFUNCTION.
