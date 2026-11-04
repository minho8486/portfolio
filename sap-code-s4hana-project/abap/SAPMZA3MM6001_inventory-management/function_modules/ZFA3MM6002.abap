FUNCTION ZFA3MM6002.


*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_DATA)
*"     REFERENCE(IO_ALV) TYPE REF TO  CL_GUI_ALV_GRID
*"  EXPORTING
*"     REFERENCE(ES_DATA)
*"     REFERENCE(EV_SUBRC) TYPE  SY-SUBRC
*"----------------------------------------------------------------------


*       Global data declarations


PERFORM get_selected_row USING it_data io_alv
                         CHANGING es_data ev_subrc.

ENDFUNCTION.
