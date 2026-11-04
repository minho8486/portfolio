*&---------------------------------------------------------------------*
*& Include ZRA3MM6002TOP                            - Report ZRA3MM6002
*&---------------------------------------------------------------------*


REPORT zra3mm6002.

DATA: ok_code  TYPE sy-ucomm,
      gv_subrc TYPE sy-subrc,
      gv_messg TYPE string,
      gv_messt(1).

TABLES: zta3PP0006.

DATA: go_dock   TYPE REF TO cl_gui_docking_container,
      go_tcon   TYPE REF TO cl_gui_container,
      go_con    TYPE REF TO cl_gui_container,
      go_lcon   TYPE REF TO cl_gui_container,
      go_rcon   TYPE REF TO cl_gui_container,
      go_dcon   TYPE REF TO cl_gui_container,
      go_split  TYPE REF TO cl_gui_splitter_container,
      go_split2 TYPE REF TO cl_gui_splitter_container,
      go_tree   TYPE REF TO cl_gui_simple_tree,
      go_grid   TYPE REF TO cl_gui_alv_grid,
      go_grid2  TYPE REF TO cl_gui_alv_grid,
      go_doc    TYPE REF TO cl_dd_document.

DATA: gs_tlayo  TYPE lvc_s_layo,
      gt_tfcat  TYPE lvc_t_fcat WITH HEADER LINE,
      gs_glayo  TYPE lvc_s_layo,
      gt_gfcat  TYPE lvc_t_fcat WITH HEADER LINE,
      gs_glayo2 TYPE lvc_s_layo,
      gt_gfcat2 TYPE lvc_t_fcat WITH HEADER LINE,
      gv_title  TYPE sdydo_text_element.

DATA: gt_hpp   TYPE TABLE OF zta3pp0005,
      gt_ipp   TYPE TABLE OF zta3pp0006,
      gs_tree  TYPE mtreesnode,
      gt_tree  LIKE TABLE OF gs_tree,
      gt_hlist TYPE TABLE OF zsa3mm6020,
      gs_hlist LIKE LINE OF gt_hlist,
      gt_ilist TYPE TABLE OF zsa3mm6021,
      gs_ilist LIKE LINE OF gt_ilist.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.

  SELECT-OPTIONS:
    so_erdat FOR zta3pp0006-erdat.

  PARAMETERS:
    pa_plaid TYPE zta3pp0006-plaid.

SELECTION-SCREEN END OF BLOCK b1.

CLASS lcl_handler_tree DEFINITION.
  PUBLIC SECTION.

    CLASS-METHODS on_node_double_click FOR EVENT node_double_click
      OF cl_gui_simple_tree
      IMPORTING node_key.
ENDCLASS.

CLASS lcl_handler_grid DEFINITION.
  PUBLIC SECTION.

    CLASS-METHODS on_double_click FOR EVENT double_click
      OF cl_gui_alv_grid
        IMPORTING es_row_no.
ENDCLASS.
