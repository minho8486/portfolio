**************************************************************************
*   Method attributes.                                                   *
**************************************************************************


Instantiation: Protected


**************************************************************************



  METHOD esexplistset_get_entityset.

    DATA: lt_filter TYPE /iwbep/t_mgw_select_option,
          ls_filter LIKE LINE OF lt_filter,
          ls_so     LIKE LINE OF ls_filter-select_options.

    DATA: lt_matid TYPE RANGE OF zta3mm0001-matid,
          lt_plaid TYPE RANGE OF zta3mm0002-plaid,
          lt_batid TYPE RANGE OF zta3mm0002-batid,
          ls_matid LIKE LINE OF lt_matid,
          ls_plaid LIKE LINE OF lt_plaid,
          ls_batid LIKE LINE OF lt_batid.

    lt_filter = io_tech_request_context->get_filter( )->get_filter_select_options( ).

    LOOP AT lt_filter INTO ls_filter.

      TRANSLATE ls_filter-property TO UPPER CASE.

      LOOP AT ls_filter-select_options INTO ls_so.

        CASE ls_filter-property.

          WHEN 'MATID'.
            ls_matid-sign   = ls_so-sign.
            ls_matid-option = ls_so-option.
            ls_matid-low    = ls_so-low.
            ls_matid-high   = ls_so-high.
            APPEND ls_matid TO lt_matid.

          WHEN 'PLAID'.
            ls_plaid-sign   = ls_so-sign.
            ls_plaid-option = ls_so-option.
            ls_plaid-low    = ls_so-low.
            ls_plaid-high   = ls_so-high.
            APPEND ls_plaid TO lt_plaid.

          WHEN 'BATID'.
            ls_batid-sign   = ls_so-sign.
            ls_batid-option = ls_so-option.
            ls_batid-low    = ls_so-low.
            ls_batid-high   = ls_so-high.
            APPEND ls_batid TO lt_batid.

        ENDCASE.

      ENDLOOP.

    ENDLOOP.

    call function 'ZFA3MM6021'
      EXPORTING
        it_matid     = lt_matid
        it_batid     = lt_batid
        it_plaid     = lt_plaid
        iv_days      = 10
      IMPORTING
        et_entityset = et_entityset.


  ENDMETHOD.
