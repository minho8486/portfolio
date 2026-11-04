**************************************************************************
*   Method attributes.                                                   *
**************************************************************************


Instantiation: Protected


**************************************************************************



  METHOD esstockadjset_get_entityset.
    DATA: lt_filter TYPE /iwbep/t_mgw_select_option,
          ls_filter LIKE LINE OF lt_filter,
          ls_so     LIKE LINE OF ls_filter-select_options.

    DATA: lt_matid TYPE RANGE OF zta3mm0001-matid,
          ls_matid LIKE LINE OF lt_matid,
          lt_batid TYPE RANGE OF zta3mm0003-batid,
          ls_batid LIKE LINE OF lt_batid,
          lt_plaid TYPE RANGE OF zta3mm0006-plaid,
          ls_plaid LIKE LINE OF lt_plaid,
          lt_stoid TYPE RANGE OF zta3mm0007-stoid,
          ls_stoid LIKE LINE OF lt_stoid,
          lv_subrc TYPE sy-subrc.

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
        WHEN 'PLAID'.
          ls_plaid-sign   = ls_so-sign.
          ls_plaid-option = ls_so-option.
          ls_plaid-low    = ls_so-low.
          ls_plaid-high   = ls_so-high.
          APPEND ls_plaid TO lt_plaid.
        WHEN 'PLAID'.
          ls_plaid-sign   = ls_so-sign.
          ls_plaid-option = ls_so-option.
          ls_plaid-low    = ls_so-low.
          ls_plaid-high   = ls_so-high.
          APPEND ls_plaid TO lt_plaid.
        WHEN 'STOID'.
          ls_stoid-sign   = ls_so-sign.
          ls_stoid-option = ls_so-option.
          ls_stoid-low    = ls_so-low.
          ls_stoid-high   = ls_so-high.
          APPEND ls_stoid TO lt_stoid.
        WHEN OTHERS.

      ENDCASE.
    ENDLOOP.

    call function 'ZFA3MM6017'
      EXPORTING
        it_matid     = lt_matid
        it_batid     = lt_batid
        it_plaid     = lt_plaid
        it_stoid     = lt_stoid
      IMPORTING
        et_entityset = et_entityset
        ev_subrc     = lv_subrc.
    IF lv_subrc <> 0.
      DATA(lo_message_container)
        = mo_context->get_message_container( ).

      lo_message_container->add_message(
          iv_msg_type   = 'E'
          iv_msg_id     = 'ZMCN11601'
          iv_msg_number = '001'
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = lo_message_container.

      RETURN.
    ENDIF.



  ENDMETHOD.
