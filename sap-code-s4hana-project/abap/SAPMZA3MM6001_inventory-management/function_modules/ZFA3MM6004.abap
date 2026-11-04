FUNCTION ZFA3MM6004.


*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_EMPID) TYPE  ZTA3HR0002-EMPID
*"  EXPORTING
*"     REFERENCE(EV_EMPNM) TYPE  ZTA3HR0002-EMPNM
*"     REFERENCE(EV_SUBRC) TYPE  SY-SUBRC
*"----------------------------------------------------------------------


*       Global data declarations


  PERFORM read_empnm USING iv_empid
                     CHANGING ev_empnm ev_subrc gt_empnm.

ENDFUNCTION.
