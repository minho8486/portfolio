FUNCTION ZFA3MM6013.


*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_FILTER) TYPE  /IWBEP/T_MGW_SELECT_OPTION
*"  EXPORTING
*"     REFERENCE(ET_ENTITYSET) TYPE  ZCL_ZGWA3MM6001_MPC=>TT_ESPLA
*"----------------------------------------------------------------------

*       Global data declarations


  PERFORM make_select_options USING it_filter
                              CHANGING gt_pname.

  PERFORM get_plant_search_help USING gt_pname
                                CHANGING et_entityset.

ENDFUNCTION.
