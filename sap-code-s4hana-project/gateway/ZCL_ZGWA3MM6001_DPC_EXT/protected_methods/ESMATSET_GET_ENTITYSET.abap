**************************************************************************
*   Method attributes.                                                   *
**************************************************************************


Instantiation: Protected


**************************************************************************



  METHOD esmatset_get_entityset.
    DATA: lt_filter TYPE /iwbep/t_mgw_select_option,
          ls_filter LIKE LINE OF lt_filter,
          ls_so     LIKE LINE OF ls_filter-select_options.

    DATA: lt_mtext TYPE RANGE OF zta3mm0001_t-mtext,
          ls_mtext LIKE LINE OF lt_mtext.

    lt_filter = io_tech_request_context->get_filter( )->get_filter_select_options( ).

    LOOP AT lt_filter INTO ls_filter.

      READ TABLE ls_filter-select_options INTO ls_so INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      TRANSLATE ls_filter-property TO UPPER CASE.

      CASE ls_filter-property.
        WHEN 'MTEXT'.
          ls_mtext-sign   = ls_so-sign.
          ls_mtext-option = ls_so-option.
          ls_mtext-low    = ls_so-low.
          ls_mtext-high   = ls_so-high.
          APPEND ls_mtext TO lt_mtext.
        WHEN OTHERS.

      ENDCASE.
    ENDLOOP.

    call function 'ZFA3MM6012'
      EXPORTING
        it_mtext     = lt_mtext
      IMPORTING
        et_entityset = et_entityset.

  ENDMETHOD.
