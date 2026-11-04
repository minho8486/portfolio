**************************************************************************
*   Method attributes.                                                   *
**************************************************************************


Instantiation: Protected


**************************************************************************



  METHOD esmatdetailset_get_entity.
    DATA: ls_key   LIKE LINE OF it_key_tab,
          ls_cond TYPE zsa3mm6032,
          lv_subrc TYPE sy-subrc.

    "Get Key Condition
    LOOP AT it_key_tab INTO ls_key.
      TRANSLATE ls_key-name TO UPPER CASE.
      CASE ls_key-name.
        WHEN 'MATID'.
          ls_cond-matid = ls_key-value.
        WHEN OTHERS.

      ENDCASE.
      CLEAR ls_key.
    ENDLOOP.

    call function 'ZFA3MM6014'
      EXPORTING
        iv_matid  = ls_cond-matid
      IMPORTING
        es_entity = er_entity
        ev_subrc  = lv_subrc.

    IF lv_subrc <> 0.
      MOVE-CORRESPONDING ls_cond to er_entity.
      er_entity-sflag = 'E'.
      MESSAGE s002(zmcn11601) WITH ls_cond-matid INTO er_entity-smesg.
      RETURN.
    ENDIF.

  ENDMETHOD.
