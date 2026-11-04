**************************************************************************
*   Method attributes.                                                   *
**************************************************************************


Instantiation: Protected


**************************************************************************



  METHOD esplaset_get_entityset.
    DATA: lt_filter TYPE /iwbep/t_mgw_select_option.

    lt_filter = io_tech_request_context->get_filter( )->get_filter_select_options( ).

    call function 'ZFA3MM6013'
      EXPORTING
        it_filter    = lt_filter
      IMPORTING
        et_entityset = et_entityset.
  ENDMETHOD.
