*&---------------------------------------------------------------------*
*& Include          MZA3MM6003O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SET_ALV_100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE set_alv_100 OUTPUT.
  PERFORM create_container USING 'CON_MAIN' go_con go_alv.
  PERFORM set_layo_0100 CHANGING gs_layo.
  PERFORM set_fcat_0100 TABLES gt_fcat.
  PERFORM set_sort_0100 TABLES gt_sort.
  PERFORM display_alv USING go_alv gt_list 'ZSA3MM6013' gs_layo gt_fcat[] gt_sort[].
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module MOVE_TO_SCREEN_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE move_to_screen_0100 OUTPUT.
  MOVE-CORRESPONDING gs_cond TO zsa3mm6012.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE modify_screen_0100 OUTPUT.
  PERFORM modify_screen_0100.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE status_0200 OUTPUT.
  SET PF-STATUS 'S200' EXCLUDING gt_atbar.
  SET TITLEBAR 'T200'.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module MOVE_TO_SCREEN_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE move_to_screen_0200 OUTPUT.
  MOVE-CORRESPONDING gs_hnew TO zsa3mm6014.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SET_DEFAULT_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE set_default_0200 OUTPUT.
  PERFORM set_default_0200 CHANGING gs_hnew.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SET_DROPDOWN_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE set_dropdown_0200 OUTPUT.
  PERFORM set_dropdown.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SET_ALV_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE set_alv_0200 OUTPUT.

  PERFORM create_container USING 'CON_ORD' go_ocon go_oalv.
  PERFORM set_layo_0200 CHANGING gs_layo.
  PERFORM set_fcat_oinfo TABLES gt_fcat.
  PERFORM set_sort_oinfo TABLES gt_sort.
  CASE gs_hnew-prtyp.
    WHEN 'PR'.
      PERFORM display_alv USING go_oalv gt_pitem 'ZSA3MM6016' gs_layo gt_fcat[] gt_sort[].
    WHEN 'SO'.
      PERFORM display_alv USING go_oalv gt_sitem 'ZSA3MM6017' gs_layo gt_fcat[] gt_sort[].
    WHEN 'MO'.
      PERFORM display_alv USING go_oalv gt_mitem 'ZSA3MM6018' gs_layo gt_fcat[] gt_sort[].
  ENDCASE.

  PERFORM create_container USING 'CON_INEW' go_icon go_ialv.
  PERFORM set_layo_0200 CHANGING gs_layo.
  PERFORM set_fcat_0200 TABLES gt_nfcat.
  PERFORM set_sort_0200 TABLES gt_sort.
  PERFORM display_alv USING go_ialv gt_inew 'ZSA3MM6015' gs_layo gt_nfcat[] gt_sort[].

ENDMODULE.


*&---------------------------------------------------------------------*
*& Module STATUS_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE status_0300 OUTPUT.
  SET PF-STATUS 'S300'.
  SET TITLEBAR 'T300'.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module MOVE_TO_SCREEN_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE move_to_screen_0300 OUTPUT.
  MOVE-CORRESPONDING gs_hupt TO zsa3mm6014.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SET_ALV_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE set_alv_0300 OUTPUT.
  PERFORM create_container USING 'CON_UPT' go_ucon go_ualv.
  PERFORM set_layo_0300 CHANGING gs_layo.
  PERFORM set_fcat_0300 TABLES gt_fcat.
  PERFORM set_sort_0300 TABLES gt_sort.
  PERFORM display_alv USING go_ualv gt_iupt 'ZSA3MM6015' gs_layo gt_fcat[] gt_sort[].

ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SET_EDIT_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE set_edit_0300 OUTPUT.
  PERFORM create_container_edit USING 'CON_EDIT' go_uhcon go_uhedit.

  PERFORM get_bktxt USING go_uhedit gs_hupt-bktxt.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module STATUS_0301 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE status_0301 OUTPUT.
  SET PF-STATUS 'S301'.
  SET TITLEBAR 'T301'.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SET_EDIT_0301 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE set_edit_0301 OUTPUT.
  PERFORM create_container_edit USING 'CON_UIEDIT' go_uicon go_uiedit.

  PERFORM get_bktxt USING go_uiedit gs_iupt-bktxt.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module STATUS_0400 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE status_0400 OUTPUT.
  SET PF-STATUS 'S400'.
  SET TITLEBAR 'T400'.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SET_ALV_0400 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE set_alv_0400 OUTPUT.
  PERFORM create_container USING 'CON_DET' go_dcon go_dalv.
  PERFORM set_layo_0400 CHANGING gs_layo.
  PERFORM set_fcat_0400 TABLES gt_fcat.
  PERFORM set_sort_0400 TABLES gt_sort.
  PERFORM display_alv USING go_dalv gt_idet 'ZSA3MM6015' gs_layo gt_fcat[] gt_sort[].
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SET_EDIT_0400 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE set_edit_0400 OUTPUT.
  PERFORM create_container_edit USING 'CON_DEDIT' go_dhcon go_dhedit.

  PERFORM get_bktxt USING go_dhedit gs_hdet-bktxt.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module MOVE_TO_SCREEN_0400 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE move_to_screen_0400 OUTPUT.
  MOVE-CORRESPONDING gs_hdet TO zsa3mm6014.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module STATUS_0401 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE status_0401 OUTPUT.
  SET PF-STATUS 'S401'.
  SET TITLEBAR 'T401'.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SET_EDIT_0401 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE set_edit_0401 OUTPUT.
  PERFORM create_container_edit USING 'CON_DIEDIT' go_dicon go_diedit.

  PERFORM get_bktxt USING go_diedit gs_idet-bktxt.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SET_EDIT_0201 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE set_edit_0201 OUTPUT.
  PERFORM create_container_edit USING 'CON_IEDIT' go_ihcon go_ihedit.

  PERFORM get_bktxt USING go_ihedit gs_hnew-bktxt.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SET_EDIT_0203 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE set_edit_0203 OUTPUT.
  PERFORM create_container_edit USING 'CON_IIEDIT' go_iicon go_iiedit.
  PERFORM set_readonly USING go_iiedit.
  PERFORM get_bktxt USING go_iiedit gs_inew-bktxt.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module STATUS_0101 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE status_0101 OUTPUT.
  SET PF-STATUS 'S101'.
  SET TITLEBAR 'T101'.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SET_EDIT_0101 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE set_edit_0101 OUTPUT.
  PERFORM create_container_edit USING 'CON_MHEDIT' go_mhcon go_mhedit.

  PERFORM get_bktxt USING go_mhedit gs_list-bktxt.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module STATUS_0204 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE status_0204 OUTPUT.
  SET PF-STATUS 'S204'.
  SET TITLEBAR 'T204'.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module MOVE_TO_SCREEN_0204 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE move_to_screen_0204 OUTPUT.
  MOVE-CORRESPONDING gs_emp TO zsa3mm6024.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module STATUS_0205 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE status_0205 OUTPUT.
  SET PF-STATUS 'S205'.
  SET TITLEBAR 'T205'.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module MOVE_TO_SCREEN_0205 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE move_to_screen_0205 OUTPUT.
  MOVE-CORRESPONDING gs_plant TO zsa3mm6005.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module STATUS_0206 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE status_0206 OUTPUT.
  SET PF-STATUS 'S206'.
  SET TITLEBAR 'T206'.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module MOVE_TO_SCREEN_0206 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE move_to_screen_0206 OUTPUT.
  MOVE-CORRESPONDING gs_mat TO zsa3mm6004.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module STATUS_0302 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE status_0302 OUTPUT.
  SET PF-STATUS 'S302'.
  SET TITLEBAR 'T302'.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SET_ALV_0302 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE set_alv_0302 OUTPUT.
  PERFORM create_container USING 'CON_ODR_POP' go_opcon go_opalv.
  PERFORM set_layo_0302 CHANGING gs_layo.
  PERFORM set_fcat_0302 TABLES gt_fcat.
  PERFORM set_sort_oinfo TABLES gt_sort.
  CASE gv_dynnr2.
    WHEN '0303'.
      PERFORM display_alv USING go_opalv gt_pitem 'ZSA3MM6016' gs_layo gt_fcat[] gt_sort[].
    WHEN '0304'.
      PERFORM display_alv USING go_opalv gt_sitem 'ZSA3MM6017' gs_layo gt_fcat[] gt_sort[].
    WHEN '0305'.
      PERFORM display_alv USING go_opalv gt_mitem 'ZSA3MM6018' gs_layo gt_fcat[] gt_sort[].
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module MOVE_TO_SCREEN_0302 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE move_to_screen_0302 OUTPUT.
  MOVE-CORRESPONDING gs_phead TO zsa3mm6039.
  MOVE-CORRESPONDING gs_shead TO zsa3mm6040.
  MOVE-CORRESPONDING gs_mhead TO zsa3mm6041.
ENDMODULE.
