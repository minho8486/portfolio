*&---------------------------------------------------------------------*
*& Include MZA3MM6002TOP                            - Module Pool      SAPMZA3MM6002
*&---------------------------------------------------------------------*


PROGRAM sapmza3mm6002.

DATA: ok_code  LIKE sy-ucomm,
      gv_subrc LIKE sy-subrc,
      gv_dynnr LIKE sy-dynnr VALUE '0201',
      gt_atbar LIKE TABLE OF sy-ucomm,
      gs_atbar LIKE LINE OF gt_atbar.

TABLES: zsa3mm6007,
        zsa3mm6009.

DATA: gs_cond TYPE zsa3mm6007,
      gt_list TYPE TABLE OF zsa3mm6008,
      gs_list LIKE LINE OF gt_list,
      gs_new  TYPE zsa3mm6009,
      gs_upt  TYPE zsa3mm6009.

DATA: go_con TYPE REF TO cl_gui_custom_container,
      go_alv TYPE REF TO cl_gui_alv_grid.

DATA: gt_fcat TYPE lvc_t_fcat WITH HEADER LINE,
      gt_sort TYPE lvc_t_sort WITH HEADER LINE,
      gs_layo TYPE lvc_s_layo.

DATA: gv_messg    TYPE string,
      gv_messt(1).
