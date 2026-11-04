*&---------------------------------------------------------------------*
*& Include ZRA3MM6001TOP                            - Report ZRA3MM6001
*&---------------------------------------------------------------------*


REPORT zra3mm6001.

DATA: ok_code     TYPE sy-ucomm,
      gv_subrc    TYPE sy-subrc,
      gv_messg    TYPE string,
      gv_messt(1).

TABLES: zsa3mm6010.

DATA: gs_layo TYPE lvc_s_layo,
      gt_fcat TYPE lvc_t_fcat WITH HEADER LINE.

DATA: gt_list  TYPE TABLE OF zsa3mm6011,
      gs_list  LIKE LINE OF gt_list,
      gt_field TYPE TABLE OF char10,
      gs_field LIKE LINE OF gt_field,
      gt_binfo TYPE TABLE OF zta3mm0003,
      gs_binfo LIKE LINE OF gt_binfo,
      gt_poqua TYPE TABLE OF zsa3mm6011,
      gs_poqua LIKE LINE OF gt_poqua.

DATA: gv_cflag(1).

DATA: go_dock TYPE REF TO cl_gui_docking_container,
      go_alv  TYPE REF TO cl_gui_alv_grid.

TYPE-POOLS: icon.

SELECTION-SCREEN BEGIN OF BLOCK t1 WITH FRAME TITLE TEXT-t03.
  SELECTION-SCREEN COMMENT /1(50) gv_info1.
  SELECTION-SCREEN COMMENT /1(50) gv_info2.
  SELECTION-SCREEN COMMENT /1(50) gv_info3.
SELECTION-SCREEN END OF BLOCK t1.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS: so_matid FOR zsa3mm6010-matid,
                  so_plaid FOR zsa3mm6010-plaid.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-t02.
  SELECT-OPTIONS: so_batid FOR zsa3mm6010-batid,
                  so_hsdat FOR zsa3mm6010-hsdat.
SELECTION-SCREEN END OF BLOCK b2.
