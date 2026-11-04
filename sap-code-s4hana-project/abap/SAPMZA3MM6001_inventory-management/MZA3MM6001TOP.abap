*&---------------------------------------------------------------------*
*& Include MZA3MM6001TOP                            - Module Pool      SAPMZA3MM6001
*&---------------------------------------------------------------------*


PROGRAM sapmza3mm6001.

DATA: ok_code  LIKE sy-ucomm,
      gv_subrc LIKE sy-subrc,
      gv_dynnr LIKE sy-dynnr VALUE '0201',
      gt_atbar LIKE TABLE OF sy-ucomm,
      gs_atbar LIKE LINE OF gt_atbar,
      gv_answer.

DATA: gv_messg    TYPE string,
      gv_messt(1).

TABLES: zsa3mm6001,
        zsa3mm6003,
        zsa3mm6004,
        zsa3mm6005,
        zsa3mm6006.

DATA: gs_cond  TYPE zsa3mm6001,
      gt_list  TYPE TABLE OF zsa3mm6002,
      gs_list  LIKE LINE OF gt_list,
      gs_ucond TYPE zsa3mm6001.

DATA: gs_binfo  TYPE zsa3mm6003,
      gs_minfo  TYPE zsa3mm6004,
      gs_pinfo  TYPE zsa3mm6005,
      gs_new    TYPE zsa3mm6006,
      gs_update TYPE zsa3mm6006,
      gs_detail TYPE zsa3mm6006.

DATA: go_con TYPE REF TO cl_gui_custom_container,
      go_alv TYPE REF TO cl_gui_alv_grid.

DATA: gs_layo TYPE lvc_s_layo,
      gt_fcat TYPE lvc_t_fcat WITH HEADER LINE,
      gt_sort TYPE lvc_t_sort WITH HEADER LINE.

DATA: gt_range TYPE RANGE OF zsa3hr0001-erdat.

CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_hotspot_click
      FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING e_row_id e_column_id.
ENDCLASS.
