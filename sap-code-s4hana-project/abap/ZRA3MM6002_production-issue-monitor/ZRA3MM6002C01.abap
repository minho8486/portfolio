*&---------------------------------------------------------------------*
*& Include          ZRA3MM6002C01
*&---------------------------------------------------------------------*


CLASS lcl_handler_tree IMPLEMENTATION.
  METHOD on_node_double_click.
    CLEAR: gt_hlist, gt_ilist.

    CASE node_key.
      WHEN '1100'.
        PERFORM get_not CHANGING gt_hpp gt_ipp gt_hlist gv_subrc.
      WHEN '1200'.
        PERFORM get_part CHANGING gt_hpp gt_ipp gt_hlist gv_subrc.
      WHEN '1300'.
        PERFORM get_complete CHANGING gt_hpp gt_ipp gt_hlist gv_subrc.
    ENDCASE.

    IF gv_subrc <> 0.
      gv_messt = 'S'.
      PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    ENDIF.

    CALL METHOD cl_gui_cfw=>set_new_ok_code
      EXPORTING
        new_code = 'ENTER'.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_handler_grid IMPLEMENTATION.
  METHOD on_double_click.
    CLEAR: gt_ilist, gs_hlist.

    READ TABLE gt_hlist INDEX es_row_no-row_id INTO gs_hlist.

    PERFORM get_item_list_data USING gs_hlist
                               CHANGING gt_ilist gv_subrc.
    IF gv_subrc <> 0.
      gv_messt = 'S'.
      PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    ENDIF.

    CALL METHOD cl_gui_cfw=>set_new_ok_code
      EXPORTING
        new_code = 'ENTER'.
  ENDMETHOD.
ENDCLASS.
