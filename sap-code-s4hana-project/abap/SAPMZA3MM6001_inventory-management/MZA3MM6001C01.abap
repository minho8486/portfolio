*&---------------------------------------------------------------------*
*& Include          MZA3MM6001C01
*&---------------------------------------------------------------------*



CLASS lcl_handler IMPLEMENTATION.
  METHOD on_hotspot_click.
    DATA ls_list LIKE LINE OF gt_list.
    READ TABLE gt_list INDEX e_row_id-index INTO ls_list.

    CASE e_column_id-fieldname.
      WHEN 'BATID'.
        PERFORM show_bat_info USING ls_list
                              CHANGING gs_binfo gv_subrc.
        IF gv_subrc <> 0.
          PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
          RETURN.
        ENDIF.

        CALL SCREEN 101 STARTING AT 10 10.
        CLEAR gs_binfo.
      WHEN 'MTEXT'.
        PERFORM show_mat_info USING ls_list
                              CHANGING gs_minfo gv_subrc.
        IF gv_subrc <> 0.
          PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
          RETURN.
        ENDIF.

        CALL SCREEN 102 STARTING AT 10 10.
        CLEAR gs_minfo.
      WHEN 'PNAME'.
        PERFORM show_plant_info USING ls_list
                                CHANGING gs_pinfo gv_subrc.
        IF gv_subrc <> 0.
          PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
          RETURN.
        ENDIF.

        CALL SCREEN 103 STARTING AT 10 10.
        CLEAR gs_pinfo.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
