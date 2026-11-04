*&---------------------------------------------------------------------*
*& Include ZRA3MM6003TOP                            - Report ZRA3MM6003
*&---------------------------------------------------------------------*


REPORT zra3mm6003.

DATA: ok_code  TYPE sy-ucomm,
      gv_subrc TYPE sy-subrc.

DATA: go_dock TYPE REF TO cl_gui_docking_container,
      go_ucon TYPE REF TO cl_gui_container,
      go_dcon TYPE REF TO cl_gui_container,
      go_split TYPE REF TO cl_gui_splitter_container,
      go_ualv TYPE REF TO cl_gui_alv_grid,
      go_dalv TYPE REF TO cl_gui_alv_grid.

DATA: gt_list TYPE TABLE OF zsa3mm6022,
      gs_list LIKE LINE OF gt_list,
      gt_inven TYPE TABLE OF zsa3mm6023,
      gs_inven LIKE LINE OF gt_inven.

DATA: gt_ufcat TYPE lvc_t_fcat WITH HEADER LINE,
      gt_dfcat TYPE lvc_t_fcat WITH HEADER LINE,
      gt_usort TYPE lvc_t_sort WITH HEADER LINE,
      gt_dsort TYPE lvc_t_sort WITH HEADER LINE,
      gs_layo TYPE lvc_s_layo.

PARAMETERS: pa_datum TYPE datum .
