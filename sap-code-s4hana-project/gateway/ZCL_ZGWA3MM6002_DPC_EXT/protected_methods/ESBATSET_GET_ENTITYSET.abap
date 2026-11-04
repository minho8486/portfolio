**************************************************************************
*   Method attributes.                                                   *
**************************************************************************


Instantiation: Protected


**************************************************************************



  METHOD esbatset_get_entityset.
    DATA: lt_filter TYPE /iwbep/t_mgw_select_option,
          ls_filter LIKE LINE OF lt_filter,
          ls_so     LIKE LINE OF ls_filter-select_options.

    DATA: lt_matid TYPE RANGE OF zta3mm0001-matid,
          ls_matid LIKE LINE OF lt_matid,
          lt_batid TYPE RANGE OF zta3mm0003-batid,
          ls_batid LIKE LINE OF lt_batid.

    lt_filter = io_tech_request_context->get_filter( )->get_filter_select_options( ).

    LOOP AT lt_filter INTO ls_filter.

      READ TABLE ls_filter-select_options INTO ls_so INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      TRANSLATE ls_filter-property TO UPPER CASE.

      CASE ls_filter-property.
        WHEN 'MATID'.
          ls_matid-sign   = ls_so-sign.
          ls_matid-option = ls_so-option.
          ls_matid-low    = ls_so-low.
          ls_matid-high   = ls_so-high.
          APPEND ls_matid TO lt_matid.
        WHEN 'BATID'.
          ls_batid-sign   = ls_so-sign.
          ls_batid-option = ls_so-option.
          ls_batid-low    = ls_so-low.
          ls_batid-high   = ls_so-high.
          APPEND ls_batid TO lt_batid.
        WHEN OTHERS.

      ENDCASE.
    ENDLOOP.

    call function 'ZFA3MM6016'
      EXPORTING
        it_batid     = lt_batid
        it_matid     = lt_matid
      IMPORTING
        et_entityset = et_entityset.

  ENDMETHOD.
