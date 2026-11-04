**************************************************************************
*   Method attributes.                                                   *
**************************************************************************


Instantiation: Protected


**************************************************************************



  METHOD esmaterialset_get_entityset.
    DATA: lt_filter TYPE /iwbep/t_mgw_select_option,
          ls_filter LIKE LINE OF lt_filter,
          ls_so     LIKE LINE OF ls_filter-select_options.

    DATA: lt_matid TYPE RANGE OF zta3mm0002-matid,
          lt_plaid TYPE RANGE OF zta3mm0002-plaid,
          lt_batid TYPE RANGE OF zta3mm0002-batid,
          lt_hsdat TYPE RANGE OF zta3mm0003-hsdat.

    DATA: ls_matid LIKE LINE OF lt_matid,
          ls_plaid LIKE LINE OF lt_plaid,
          ls_batid LIKE LINE OF lt_batid,
          ls_hsdat LIKE LINE OF lt_hsdat.

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
        WHEN 'HSDAT'.
          ls_hsdat-sign   = ls_so-sign.
          ls_hsdat-option = ls_so-option.
          ls_hsdat-low    = ls_so-low.
          ls_hsdat-high   = ls_so-high.
          APPEND ls_hsdat TO lt_hsdat.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.

    call function 'ZFA3MM6011'
      EXPORTING
        it_matid     = lt_matid
        it_plaid     = lt_plaid
        it_hsdat     = lt_hsdat
      IMPORTING
        et_entityset = et_entityset.





**TRY.
*CALL METHOD SUPER->ESMATERIALSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.


  ENDMETHOD.
