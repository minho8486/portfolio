**************************************************************************
*   Method attributes.                                                   *
**************************************************************************


Instantiation: Protected


**************************************************************************



  METHOD esexpchartset_get_entityset.

    DATA: ls_entityset LIKE LINE OF et_entityset,
          lt_list      TYPE ztta3mm6007,
          ls_list      LIKE LINE OF lt_list,
          lv_tabix     TYPE sy-tabix.

    call function 'ZFA3MM6021'
      EXPORTING
        iv_days      = 10
      IMPORTING
        et_entityset = lt_list.

    LOOP AT lt_list INTO ls_list.

      CLEAR ls_entityset.

      READ TABLE et_entityset INTO ls_entityset
        WITH KEY qstat_t = ls_list-qstat_t.

      IF sy-subrc = 0.

        lv_tabix = sy-tabix.

        ls_entityset-labst = ls_entityset-labst + ls_list-labst.

        MODIFY et_entityset FROM ls_entityset INDEX lv_tabix.

      ELSE.

        CLEAR ls_entityset.

        ls_entityset-qstat_t = ls_list-qstat_t.
        ls_entityset-labst   = ls_list-labst.
        ls_entityset-meins   = ls_list-meins.

        APPEND ls_entityset TO et_entityset.

      ENDIF.

      CLEAR ls_list.

    ENDLOOP.
  ENDMETHOD.
