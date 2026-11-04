*&---------------------------------------------------------------------*
*& Include          ZRA3MM6002F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form create_dock_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM create_dock_0100 .
  IF go_dock IS NOT INITIAL.
    RETURN.
  ENDIF.

  CREATE OBJECT go_dock
    EXPORTING


*     parent                      =


      repid                       = sy-repid
      dynnr                       = sy-dynnr
      side                        = cl_gui_docking_container=>dock_at_top
      extension                   = 1000


*     style                       =
*     lifetime                    = lifetime_default
*     caption                     =
*     metric                      = 0
*     ratio                       =
*     no_autodef_progid_dynnr     =
*     name                        =


    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  PERFORM create_document_0100.
  PERFORM create_splitter_0100.
  PERFORM create_tree_0100.
  PERFORM create_grid_0100.
  PERFORM set_grid_layo_0100.
  PERFORM set_grid2_layo_0100.
  PERFORM set_grid_fcat_0100.
  PERFORM set_grid2_fcat_0100.
  PERFORM display_tree_0100.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form create_document_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM create_document_0100 .
  CREATE OBJECT go_doc
    EXPORTING
      style = 'ALV_GRID'.

  CLEAR gv_title.

  gv_title = '출고 모니터링'.

  CALL METHOD go_doc->add_text
    EXPORTING
      text         = gv_title


*     text_table   =
*     fix_lines    =
*     sap_style    =
*     sap_color    =


      sap_fontsize = cl_dd_document=>large


*     sap_fontstyle =


      sap_emphasis = cl_dd_document=>strong


*     style_class  =
*     a11y_tooltip =
*    CHANGING
*     document     =


    .


ENDFORM.


*&---------------------------------------------------------------------*
*& Form create_splitter_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM create_splitter_0100 .
  CREATE OBJECT go_split
    EXPORTING
      parent            = go_dock
      rows              = 3
      columns           = 1
    EXCEPTIONS
      cntl_error        = 1
      cntl_system_error = 2
      OTHERS            = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL METHOD go_split->get_container
    EXPORTING
      row       = 1
      column    = 1
    RECEIVING
      container = go_tcon.

  CALL METHOD go_split->set_row_height
    EXPORTING
      id                = 1
      height            = 10
    EXCEPTIONS
      cntl_error        = 1
      cntl_system_error = 2
      OTHERS            = 3.
  IF sy-subrc <> 0.

  ENDIF.

  CALL METHOD go_split->set_row_sash
    EXPORTING
      id    = 1
      type  = cl_gui_splitter_container=>type_movable
      value = cl_gui_splitter_container=>false.

  CALL METHOD go_split->get_container
    EXPORTING
      row       = 2
      column    = 1
    RECEIVING
      container = go_con.

  CALL METHOD go_split->get_container
    EXPORTING
      row       = 3
      column    = 1
    RECEIVING
      container = go_dcon.

  CALL METHOD go_doc->display_document
    EXPORTING
      parent             = go_tcon
    EXCEPTIONS
      html_display_error = 1
      OTHERS             = 2.

  CREATE OBJECT go_split2
    EXPORTING
      width             = 2000
      parent            = go_con
      rows              = 1
      columns           = 2
    EXCEPTIONS
      cntl_error        = 1
      cntl_system_error = 2
      OTHERS            = 3.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL METHOD go_split2->set_row_height
    EXPORTING
      id                = 1
      height            = 90
    EXCEPTIONS
      cntl_error        = 1
      cntl_system_error = 2
      OTHERS            = 3.

  IF sy-subrc <> 0.

  ENDIF.

  CALL METHOD go_split2->get_container
    EXPORTING
      row       = 1
      column    = 1
    RECEIVING
      container = go_lcon.

  CALL METHOD go_split2->get_container
    EXPORTING
      row       = 1
      column    = 2
    RECEIVING
      container = go_rcon.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form create_tree_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM create_tree_0100 .
  DATA: ls_event TYPE cntl_simple_event,
        lt_event LIKE TABLE OF ls_event.

  CREATE OBJECT go_tree
    EXPORTING


*     lifetime                    =


      parent                      = go_lcon


*     shellstyle                  =


      node_selection_mode         = cl_gui_simple_tree=>node_sel_mode_single


*     hide_selection              =
*     name                        =


    EXCEPTIONS
      lifetime_error              = 1
      cntl_system_error           = 2
      create_error                = 3
      failed                      = 4
      illegal_node_selection_mode = 5
      OTHERS                      = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  ls_event-eventid = cl_gui_simple_tree=>eventid_node_double_click.
  APPEND ls_event TO lt_event.

  CALL METHOD go_tree->set_registered_events
    EXPORTING
      events = lt_event.

  SET HANDLER lcl_handler_tree=>on_node_double_click FOR go_tree.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form display_ltree_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM display_alv_0100 .

  PERFORM display_grid_0100.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_pp_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM get_pp_hdata_c03 CHANGING ct_hpp LIKE gt_hpp.
  CLEAR ct_hpp.

  SELECT podid plaid rouid cstat prdnr aquan meins
    FROM zta3pp0005
    INTO CORRESPONDING FIELDS OF TABLE ct_hpp
   WHERE erdat IN so_erdat
     AND cstat = 'C03'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form make_list_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM make_list_data_1100 USING    pt_hpp LIKE gt_hpp
                                  pt_ipp LIKE gt_ipp
                         CHANGING ct_hlist LIKE gt_hlist
                                  VALUE(cv_subrc) TYPE sy-subrc.
  CLEAR ct_hlist.

  DATA: ls_hpp   TYPE zta3pp0005,
        ls_ipp   TYPE zta3pp0006,
        ls_hlist TYPE zsa3mm6020.

  LOOP AT pt_hpp INTO ls_hpp.
    READ TABLE pt_ipp WITH KEY podid = ls_hpp-podid gifla = 'X' INTO ls_ipp.
    IF sy-subrc <> 0.
      ls_hlist-icon = icon_red_light.
      ls_hlist-stat = '미출고'.
      ls_hlist-podid = ls_hpp-podid.
      ls_hlist-plaid = ls_hpp-plaid.
      ls_hlist-rouid = ls_hpp-rouid.
      ls_hlist-aquan = ls_hpp-aquan.
      ls_hlist-meins = ls_hpp-meins.

      APPEND ls_hlist TO ct_hlist.
      CLEAR ls_hlist.
    ENDIF.

    CLEAR ls_hpp.
  ENDLOOP.

  IF ct_hlist IS INITIAL.
    cv_subrc = 4.
    MESSAGE i001(zmcn11604) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_FCAT
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*


FORM set_fcat  TABLES   t_fcat STRUCTURE lvc_s_fcat
               USING    VALUE(p_fname)
                        VALUE(p_value)
                        VALUE(p_aflag).
  DATA: lv_fcat(30).
  FIELD-SYMBOLS: <fs_fcat>.

  lv_fcat = 'T_FCAT-' && p_fname.
  ASSIGN (lv_fcat) TO <fs_fcat>.

  <fs_fcat> = p_value.

  IF p_aflag = 'X'.
    APPEND t_fcat.
    CLEAR t_fcat.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form create_grid_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM create_grid_0100 .
  CREATE OBJECT go_grid
    EXPORTING


*     i_shellstyle      = 0
*     i_lifetime        =


      i_parent          = go_rcon


*     i_appl_events     = SPACE
*     i_parentdbg       =
*     i_applogparent    =
*     i_graphicsparent  =
*     i_name            =
*     i_fcat_complete   = SPACE
*     o_previous_sral_handler =
*     i_use_one_ux_appearance = ABAP_FALSE
*     o_common_hub      =


    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  SET HANDLER lcl_handler_grid=>on_double_click FOR go_grid.

  CREATE OBJECT go_grid2
    EXPORTING


*     i_shellstyle      = 0
*     i_lifetime        =


      i_parent          = go_dcon


*     i_appl_events     = SPACE
*     i_parentdbg       =
*     i_applogparent    =
*     i_graphicsparent  =
*     i_name            =
*     i_fcat_complete   = SPACE
*     o_previous_sral_handler =
*     i_use_one_ux_appearance = ABAP_FALSE
*     o_common_hub      =


    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_grid_layo_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM set_grid_layo_0100 .
  CLEAR gs_glayo.

  gs_glayo-cwidth_opt = 'X'.
  gs_glayo-zebra = 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_grid_fcat_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM set_grid_fcat_0100 .
  CLEAR: gt_gfcat[].

  PERFORM set_fcat: TABLES gt_gfcat
                    USING 'FIELDNAME' 'ICON' '',
                    TABLES gt_gfcat
                    USING 'COLTEXT' '상태' '',
                    TABLES gt_gfcat
                    USING 'ICON' 'X' 'X'.

  PERFORM set_fcat: TABLES gt_gfcat
                    USING 'FIELDNAME' 'STAT' '',
                    TABLES gt_gfcat
                    USING 'COLTEXT' '출고상태' 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form display_tree_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM display_tree_0100.

  DATA: lv_root_key TYPE lvc_nkey,
        lv_miss_key TYPE lvc_nkey,
        lv_part_key TYPE lvc_nkey,
        lv_done_key TYPE lvc_nkey,
        lv_item_key TYPE lvc_nkey,
        lv_text     TYPE lvc_value,
        lt_tree     LIKE gt_tree.

  PERFORM set_tree_data.

  CALL METHOD go_tree->add_nodes
    EXPORTING
      table_structure_name           = 'MTREESNODE'
      node_table                     = gt_tree
    EXCEPTIONS
      error_in_node_table            = 1
      failed                         = 2
      dp_error                       = 3
      table_structure_name_not_found = 4
      OTHERS                         = 5.
  IF sy-subrc <> 0.


*   Implement suitable error handling here


  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form display_grid_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM display_grid_0100 .
  CALL METHOD go_grid->set_table_for_first_display
    EXPORTING


*     i_buffer_active               =
*     i_bypassing_buffer            =
*     i_consistency_check           =


      i_structure_name              = 'ZSA3MM6020'


*     is_variant                    =
*     i_save                        =
*     i_default                     = 'X'


      is_layout                     = gs_glayo


*     is_print                      =
*     it_special_groups             =
*     it_toolbar_excluding          =
*     it_hyperlink                  =
*     it_alv_graphics               =
*     it_except_qinfo               =
*     ir_salv_adapter               =


    CHANGING
      it_outtab                     = gt_hlist
      it_fieldcatalog               = gt_gfcat[]


*     it_sort                       =
*     it_filter                     =


    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.


*   Implement suitable error handling here


  ENDIF.

  CALL METHOD go_grid2->set_table_for_first_display
    EXPORTING


*     i_buffer_active               =
*     i_bypassing_buffer            =
*     i_consistency_check           =


      i_structure_name              = 'ZSA3MM6021'


*     is_variant                    =
*     i_save                        =
*     i_default                     = 'X'


      is_layout                     = gs_glayo2


*     is_print                      =
*     it_special_groups             =
*     it_toolbar_excluding          =
*     it_hyperlink                  =
*     it_alv_graphics               =
*     it_except_qinfo               =
*     ir_salv_adapter               =


    CHANGING
      it_outtab                     = gt_ilist
      it_fieldcatalog               = gt_gfcat2[]


*     it_sort                       =
*     it_filter                     =


    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.


*   Implement suitable error handling here


  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_default
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM set_default .
  so_erdat-sign = 'I'.
  so_erdat-option = 'BT'.
  so_erdat-low = sy-datum - 14.
  so_erdat-high = sy-datum.

  APPEND so_erdat.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_tree_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM set_tree_data .
  CLEAR gt_tree.

  DATA: ls_tree LIKE gs_tree.

  ls_tree-node_key = '1000'.
  ls_tree-isfolder = 'X'.
  ls_tree-expander = 'X'.
  ls_tree-text = '출고 상태'.
  APPEND ls_tree TO gt_tree.

  CLEAR ls_tree.
  ls_tree-node_key = '1100'.
  ls_tree-relatkey = '1000'.
  ls_tree-expander = ''.
  ls_tree-text = '미출고'.
  APPEND ls_tree TO gt_tree.

  CLEAR ls_tree.
  ls_tree-node_key = '1200'.
  ls_tree-relatkey = '1000'.
  ls_tree-expander = ''.
  ls_tree-text = '부분출고'.
  APPEND ls_tree TO gt_tree.

  CLEAR ls_tree.
  ls_tree-node_key = '1300'.
  ls_tree-relatkey = '1000'.
  ls_tree-expander = ''.
  ls_tree-text = '출고완료'.
  APPEND ls_tree TO gt_tree.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_not
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_PP
*&      <-- GT_LIST
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_not  CHANGING ct_hpp LIKE gt_hpp
                       ct_ipp LIKE gt_ipp
                       ct_hlist LIKE gt_hlist
                       VALUE(cv_subrc) TYPE sy-subrc.
  PERFORM get_pp_hdata_c03 CHANGING ct_hpp.

  PERFORM get_pp_item_data USING ct_hpp
                           CHANGING ct_ipp.

  PERFORM make_list_data_1100 USING ct_hpp ct_ipp
                              CHANGING ct_hlist cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_pp_idata_c03
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> CT_HPP
*&      <-- CT_IPP
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_pp_item_data  USING    pt_hpp LIKE gt_hpp
                       CHANGING ct_ipp LIKE gt_ipp.
  CLEAR ct_ipp.

  DATA: ls_hpp TYPE zta3pp0005.

  LOOP AT pt_hpp INTO ls_hpp.
    PERFORM get_pp_idata USING ls_hpp
                         CHANGING ct_ipp.

    CLEAR ls_hpp.
  ENDLOOP.

  SORT ct_ipp BY podid scode.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_pp_idata
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_HPP
*&      <-- CT_IPP
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_pp_idata  USING    cs_hpp TYPE zta3pp0005
                   CHANGING ct_ipp LIKE gt_ipp.
  DATA: lt_ipp LIKE gt_ipp.

  SELECT podid scode rawnr plaid opcod pquan meins gifla
    FROM zta3pp0006
    INTO CORRESPONDING FIELDS OF TABLE lt_ipp
   WHERE podid = cs_hpp-podid.

  IF pa_plaid IS NOT INITIAL.
    DELETE lt_ipp WHERE plaid <> pa_plaid.
  ENDIF.

  APPEND LINES OF lt_ipp TO ct_ipp.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_grid2_fcat_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM set_grid2_fcat_0100 .
  CLEAR: gt_gfcat2[].

  PERFORM set_fcat: TABLES gt_gfcat2
                    USING 'FIELDNAME' 'GIFLA' '',
                    TABLES gt_gfcat2
                    USING 'CHECKBOX' 'X' 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_grid2_layo_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM set_grid2_layo_0100 .
  CLEAR gs_glayo2.

  gs_glayo2-cwidth_opt = 'X'.
  gs_glayo2-zebra = 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_part
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_HPP
*&      <-- GT_IPP
*&      <-- GT_HLIST
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_part  CHANGING ct_hpp LIKE gt_hpp
                        ct_ipp LIKE gt_ipp
                        ct_hlist LIKE gt_hlist
                        VALUE(cv_subrc) TYPE sy-subrc.
  PERFORM get_pp_hdata_c03 CHANGING ct_hpp.

  PERFORM get_pp_item_data USING ct_hpp
                           CHANGING ct_ipp.

  PERFORM make_list_data_1200 USING ct_hpp ct_ipp
                              CHANGING ct_hlist cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form make_list_data_1200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> CT_HPP
*&      --> CT_IPP
*&      <-- GT_HLIST
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM make_list_data_1200  USING    pt_hpp LIKE gt_hpp
                                   pt_ipp LIKE gt_ipp
                          CHANGING ct_hlist LIKE gt_hlist
                                   VALUE(cv_subrc) TYPE sy-subrc.
  CLEAR ct_hlist.

  DATA: ls_hpp   TYPE zta3pp0005,
        ls_ipp   TYPE zta3pp0006,
        ls_hlist TYPE zsa3mm6020.

  LOOP AT pt_hpp INTO ls_hpp.
    READ TABLE pt_ipp WITH KEY podid = ls_hpp-podid gifla = 'X' INTO ls_ipp.
    IF sy-subrc = 0.
      ls_hlist-icon = icon_yellow_light.
      ls_hlist-stat = '부분출고'.
      ls_hlist-podid = ls_hpp-podid.
      ls_hlist-plaid = ls_hpp-plaid.
      ls_hlist-rouid = ls_hpp-rouid.
      ls_hlist-aquan = ls_hpp-aquan.
      ls_hlist-meins = ls_hpp-meins.

      APPEND ls_hlist TO ct_hlist.
      CLEAR ls_hlist.
    ENDIF.

    CLEAR ls_hpp.
  ENDLOOP.

  IF ct_hlist IS INITIAL.
    cv_subrc = 4.
    MESSAGE i002(zmcn11604) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_complete
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_HPP
*&      <-- GT_IPP
*&      <-- GT_HLIST
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_complete  CHANGING ct_hpp LIKE gt_hpp
                            ct_ipp LIKE gt_ipp
                            ct_hlist LIKE gt_hlist
                            VALUE(cv_subrc) TYPE sy-subrc.

  PERFORM get_pp_hdata_c04 CHANGING ct_hpp.

  PERFORM get_pp_item_data USING ct_hpp
                           CHANGING ct_ipp.

  PERFORM make_list_data_1300 USING ct_hpp ct_ipp
                              CHANGING ct_hlist cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_pp_hdata_c04
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- CT_HPP
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_pp_hdata_c04  CHANGING ct_hpp LIKE gt_hpp.
  CLEAR ct_hpp.

  SELECT podid plaid rouid cstat prdnr aquan meins
    FROM zta3pp0005
    INTO CORRESPONDING FIELDS OF TABLE ct_hpp
   WHERE erdat IN so_erdat
     AND cstat = 'C04'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form make_list_data_1300
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> CT_HPP
*&      --> CT_IPP
*&      <-- GT_HLIST
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM make_list_data_1300  USING    pt_hpp LIKE gt_hpp
                                   pt_ipp LIKE gt_ipp
                          CHANGING ct_hlist LIKE gt_hlist
                                   VALUE(cv_subrc) TYPE sy-subrc.
  CLEAR ct_hlist.

  DATA: ls_hpp   TYPE zta3pp0005,
        ls_ipp   TYPE zta3pp0006,
        ls_hlist TYPE zsa3mm6020.

  LOOP AT pt_hpp INTO ls_hpp.
    ls_hlist-icon = icon_green_light.
    ls_hlist-stat = '출고완료'.
    ls_hlist-podid = ls_hpp-podid.
    ls_hlist-plaid = ls_hpp-plaid.
    ls_hlist-rouid = ls_hpp-rouid.
    ls_hlist-aquan = ls_hpp-aquan.
    ls_hlist-meins = ls_hpp-meins.

    APPEND ls_hlist TO ct_hlist.

    CLEAR: ls_hpp, ls_hlist.
  ENDLOOP.

  IF ct_hlist IS INITIAL.
    cv_subrc = 4.
    MESSAGE i003(zmcn11604) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_item_list_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_HLIST
*&      <-- GT_ILIST
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_item_list_data  USING    VALUE(ps_hlist) TYPE zsa3mm6020
                         CHANGING ct_ilist LIKE gt_ilist
                                  VALUE(cv_subrc) TYPE sy-subrc.
  SELECT podid scode rawnr plaid opcod pquan meins gifla
    FROM zta3pp0006
    INTO CORRESPONDING FIELDS OF TABLE ct_ilist
   WHERE podid = ps_hlist-podid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i004(zmcn11604) WITH ps_hlist-podid INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form show_message
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GV_MESSG
*&      <-- GV_MESST
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM show_message  CHANGING VALUE(cv_messg) LIKE gv_messg
                            VALUE(cv_messt) LIKE gv_messt
                            VALUE(cv_subrc) TYPE sy-subrc.
  DATA: lv_messg    TYPE string,
        lv_messt(1).

  lv_messg = cv_messg.
  lv_messt = cv_messt.

  CLEAR: cv_messg, cv_messt, cv_subrc.

  CASE lv_messt.
    WHEN 'I'.
      MESSAGE i000(zmcn11601) WITH lv_messg.
    WHEN 'S'.
      MESSAGE s000(zmcn11601) WITH lv_messg.
    WHEN 'E'.
      MESSAGE e000(zmcn11601) WITH lv_messg.
  ENDCASE.

ENDFORM.
