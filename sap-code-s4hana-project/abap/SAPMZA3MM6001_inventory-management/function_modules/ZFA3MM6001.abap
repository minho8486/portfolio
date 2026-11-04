FUNCTION ZFA3MM6001.


*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_DOMNAME) TYPE  DD07V-DOMNAME
*"     REFERENCE(IV_VALUE) TYPE  DD07V-DOMVALUE_L
*"  EXPORTING
*"     REFERENCE(EV_DDTEXT) TYPE  DD07V-DDTEXT
*"----------------------------------------------------------------------


*       Global data declarations


PERFORM read_domain_text USING iv_domname iv_value
                         CHANGING ev_ddtext.

ENDFUNCTION.
