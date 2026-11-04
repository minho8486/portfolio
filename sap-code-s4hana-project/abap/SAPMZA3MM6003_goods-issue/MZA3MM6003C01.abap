*&---------------------------------------------------------------------*
*& Include          MZA3MM6003C01
*&---------------------------------------------------------------------*


CLASS lcl_handler IMPLEMENTATION.

  METHOD on_toolbar.
    DATA ls_button TYPE stb_button.

    ls_button-butn_type = '3'.
    APPEND ls_button TO e_object->mt_toolbar.
    CLEAR ls_button.

    ls_button-function = 'ADD_GI'.
    ls_button-icon = icon_add_row.
    ls_button-butn_type = '0'.
    ls_button-text = TEXT-b01.  " 출고 목록 추가

    " 오더 Item 정보가 없으면 버튼 비활성화
    IF gt_pitem IS INITIAL AND gt_sitem IS INITIAL AND gt_mitem IS INITIAL.
      ls_button-disabled = 'X'.
    ENDIF.

    " 생산오더, 이동오더일 때 비활성화
    IF gs_hnew-prtyp = 'MO' OR gs_hnew-prtyp = 'PR'.
      ls_button-disabled = 'X'.
    ENDIF.

    " 출고 완료시 비활성화
    IF gv_sflag = 'X'.
      ls_button-disabled = 'X'.
    ENDIF.

    APPEND ls_button TO e_object->mt_toolbar.
    CLEAR ls_button.

    ls_button-function = 'REMOVE_GI'.
    ls_button-icon = icon_remove_row.
    ls_button-butn_type = '0'.
    ls_button-text = TEXT-b02.  "출고 목록 제거

    " 출고 Item이 비어있으면 비활성화
    IF gt_inew IS INITIAL.
      ls_button-disabled = 'X'.
    ENDIF.

    " 생산오더, 이동오더일 때 비활성화
    IF gs_hnew-prtyp = 'MO' OR gs_hnew-prtyp = 'PR'.
      ls_button-disabled = 'X'.
    ENDIF.

    " 출고 완료시 비활성화
    IF gv_sflag = 'X'.
      ls_button-disabled = 'X'.
    ENDIF.

    APPEND ls_button TO e_object->mt_toolbar.
    CLEAR ls_button.

  ENDMETHOD.

  METHOD on_user_command.
    CASE e_ucomm.
      WHEN 'ADD_GI'.
        PERFORM on_add.

        CALL METHOD cl_gui_cfw=>set_new_ok_code
          EXPORTING
            new_code = 'ENTER'.
      WHEN 'REMOVE_GI'.
        PERFORM on_remove.

        CALL METHOD cl_gui_cfw=>set_new_ok_code
          EXPORTING
            new_code = 'ENTER'.
    ENDCASE.
  ENDMETHOD.

  METHOD on_data_changed.

    DATA ls_cell LIKE LINE OF er_data_changed->mt_good_cells.
    DATA ls_inew LIKE gs_inew.

    LOOP AT er_data_changed->mt_good_cells INTO ls_cell.
      CASE ls_cell-fieldname.
        WHEN 'BKTXT'.
          DATA: lv_len TYPE i.

          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id = ls_cell-row_id
              i_fieldname = ls_cell-fieldname
            IMPORTING
              e_value = ls_inew-bktxt.

          lv_len = strlen( ls_inew-bktxt ).

          IF lv_len > 40.
            CALL METHOD er_data_changed->add_protocol_entry
              EXPORTING
                i_msgid = 'ZMCN11603'
                i_msgno = '012'
                i_msgty = 'E'
                i_msgv1 = 'ALV Edit Error'(m01)
                i_fieldname = ls_cell-fieldname
                i_row_id = ls_cell-row_id.
          ENDIF.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_handler_edit IMPLEMENTATION.
  METHOD on_hotspot_click.
    DATA: ls_item TYPE zsa3mm6015.

    CASE e_column_id-fieldname.
      WHEN 'ICOND'.
        IF sy-dynnr = '0300'.

          READ TABLE gt_iupt INDEX e_row_id-index INTO gs_iupt.
          CALL SCREEN 301 STARTING AT 10 10.
          CLEAR: gt_uiedit, gs_iupt.

        ELSEIF sy-dynnr = '0400'.

          READ TABLE gt_idet INDEX e_row_id-index INTO gs_idet.

          IF gs_list-icond IS NOT INITIAL.
            CALL SCREEN 401 STARTING AT 10 10.
          ENDIF.

          CLEAR: gt_diedit, gs_idet.

        ELSEIF sy-dynnr = '0200'.

          READ TABLE gt_inew INDEX e_row_id-index INTO gs_inew.
          CALL SCREEN 203 STARTING AT 10 10.
          CLEAR: gt_iiedit, gs_inew.

        ELSEIF sy-dynnr = '0100'.

          READ TABLE gt_list INDEX e_row_id-index INTO gs_list.

          IF gs_list-icond IS NOT INITIAL.
            CALL SCREEN 101 STARTING AT 10 10.
          ENDIF.

          CLEAR: gt_mhedit, gs_list.

        ENDIF.

        WHEN 'MATID'.
          IF sy-dynnr = '0200'.

            READ TABLE gt_inew INDEX e_row_id-index INTO ls_item.

            PERFORM get_mat_data USING ls_item-matid
                                 CHANGING gs_mat gv_subrc.
            IF gv_subrc <> 0.
              gv_messt = 'I'.
              PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
              RETURN.
            ENDIF.

            CALL SCREEN 206 STARTING AT 10 10.
            CLEAR gs_mat.

          ELSEIF sy-dynnr = '0300'.

            READ TABLE gt_iupt INDEX e_row_id-index INTO ls_item.

            PERFORM get_mat_data USING ls_item-matid
                                 CHANGING gs_mat gv_subrc.
            IF gv_subrc <> 0.
              gv_messt = 'I'.
              PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
              RETURN.
            ENDIF.

            CALL SCREEN 206 STARTING AT 10 10.
            CLEAR gs_mat.

          ELSEIF sy-dynnr = '0400'.

            READ TABLE gt_idet INDEX e_row_id-index INTO ls_item.

            PERFORM get_mat_data USING ls_item-matid
                                 CHANGING gs_mat gv_subrc.
            IF gv_subrc <> 0.
              gv_messt = 'I'.
              PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
              RETURN.
            ENDIF.

            CALL SCREEN 206 STARTING AT 10 10.
            CLEAR gs_mat.

          ENDIF.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_handler_emp IMPLEMENTATION.
  METHOD on_double_click.
    CASE e_column-fieldname.
      WHEN 'EREID'.
        READ TABLE gt_list INDEX e_row-index INTO gs_list.

        PERFORM get_emp_info USING gs_list-ereid
                             CHANGING gs_emp gv_subrc.

        CALL SCREEN 204 STARTING AT 10 10.
        CLEAR gs_emp.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
