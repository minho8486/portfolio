FUNCTION ZFA3MM6003.


*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_PLAID) TYPE  ZTA3MM0006-PLAID
*"     REFERENCE(IV_SPRAS) TYPE  SPRAS
*"  EXPORTING
*"     REFERENCE(EV_PNAME) TYPE  ZTA3MM0006_T-PNAME
*"     REFERENCE(EV_SUBRC) TYPE  SY-SUBRC
*"----------------------------------------------------------------------


*       Global data declarations


PERFORM read_pname USING iv_plaid iv_spras
                   CHANGING ev_pname ev_subrc gt_pname.

ENDFUNCTION.
