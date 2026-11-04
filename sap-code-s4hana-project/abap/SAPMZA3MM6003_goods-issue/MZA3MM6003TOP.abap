*&---------------------------------------------------------------------*
*& Include MZA3MM6003TOP                            - Module Pool      SAPMZA3MM6003
*&---------------------------------------------------------------------*


PROGRAM sapmza3mm6003.

DATA: ok_code     TYPE sy-ucomm,
      gv_subrc    TYPE sy-subrc,
      gv_dynnr    TYPE sy-dynnr,
      gv_dynnr2    TYPE sy-dynnr,
      gt_atbar    LIKE TABLE OF sy-ucomm,
      gs_atbar    LIKE LINE OF gt_atbar,
      gv_answer,                              " 재확인용 변수
      gv_sflag(1).                            " 성공여부 Flag

TYPES: ts_proc1 TYPE zsa3mm6019,              " 출고 등록 정보 가공용 Type
       tt_proc1 TYPE TABLE OF zsa3mm6019,
       ts_pitem TYPE zsa3mm6016,              " 생산오더 Item
       ts_sitem TYPE zsa3mm6017,              " 판매오더 Item
       ts_mitem TYPE zsa3mm6018,              " 이동오더 Item
       BEGIN OF ts_text,                      " ALV Text용
         text(40),
       END OF ts_text,
       tt_text TYPE TABLE OF ts_text,
       tt_inven TYPE TABLE OF zta3mm0002.

DATA: go_con    TYPE REF TO cl_gui_custom_container,  " 조회 화면 List
      go_alv    TYPE REF TO cl_gui_alv_grid,
      go_icon   TYPE REF TO cl_gui_custom_container,  " 출고 등록 출고 Item List
      go_ialv   TYPE REF TO cl_gui_alv_grid,
      go_ocon   TYPE REF TO cl_gui_custom_container,  " 출고 등록 오더 Item List
      go_oalv   TYPE REF TO cl_gui_alv_grid,
      go_ucon   TYPE REF TO cl_gui_custom_container,  " 출고 수정 출고 Item List
      go_ualv   TYPE REF TO cl_gui_alv_grid,
      go_dcon   TYPE REF TO cl_gui_custom_container,  " 출고 상세 출고 Item List
      go_dalv   TYPE REF TO cl_gui_alv_grid,
      go_uhcon  TYPE REF TO cl_gui_custom_container,  " 출고 수정 출고 Header Text Edit
      go_uhedit TYPE REF TO cl_gui_textedit,
      go_uicon  TYPE REF TO cl_gui_custom_container,  " 출고 수정 출고 Item Text Edit
      go_uiedit TYPE REF TO cl_gui_textedit,
      go_dhcon  TYPE REF TO cl_gui_custom_container,  " 출고 상세 출고 Header Text Edit
      go_dhedit TYPE REF TO cl_gui_textedit,
      go_dicon  TYPE REF TO cl_gui_custom_container,  " 출고 상세 출고 Item Text Edit
      go_diedit TYPE REF TO cl_gui_textedit,
      go_ihcon  TYPE REF TO cl_gui_custom_container,  " 출고 등록 출고 Header Text Edit
      go_ihedit TYPE REF TO cl_gui_textedit,
      go_iicon  TYPE REF TO cl_gui_custom_container,  " 출고 등록 출고 Item Text Edit
      go_iiedit TYPE REF TO cl_gui_textedit,
      go_mhcon  TYPE REF TO cl_gui_custom_container,  " 출고 조회 출고 Item Text Edit
      go_mhedit TYPE REF TO cl_gui_textedit,
      go_opcon  TYPE REF TO cl_gui_custom_container,  " 오더 Item 정보 Popup
      go_opalv TYPE REF TO cl_gui_alv_grid.

DATA: gv_messg    TYPE string,
      gv_messt(1).

DATA: gs_layo  TYPE lvc_s_layo,
      gt_fcat  TYPE lvc_t_fcat WITH HEADER LINE,
      gt_nfcat TYPE lvc_t_fcat WITH HEADER LINE,
      gt_sort  TYPE lvc_t_sort WITH HEADER LINE.

TABLES: zsa3mm6012, " 조회 Cond
        zsa3mm6014, " 출고 Header
        zsa3mm6024, " 직원 상세 정보
        zsa3mm6005, " 플랜트 상세 정보
        zsa3mm6004, " 자재 상세 정보
        zsa3mm6039, " 생산오더 Header
        zsa3mm6040, " 판매오더 Header
        zsa3mm6041. " 이동오더 Header

DATA: gs_cond  TYPE zsa3mm6012,           " 조회 Cond
      gs_cond2 TYPE zsa3mm6012,           " 조회 Cond 백업용
      gt_list  TYPE TABLE OF zsa3mm6013,  " 출고 조회 List
      gs_list  LIKE LINE OF gt_list,      " 출고 조회 List Structure
      gs_emp   TYPE zsa3mm6024,           " 직원 상세 정보
      gs_plant TYPE zsa3mm6005,           " 플랜트 상세 정보
      gs_mat   TYPE zsa3mm6004,           " 자재 상세 정보
      gs_phead TYPE zsa3mm6039,           " 생산오더 Header
      gs_shead TYPE zsa3mm6040,           " 판매오더 Header
      gs_mhead TYPE zsa3mm6041.           " 이동오더 Header

DATA: gs_hnew  TYPE zsa3mm6014,           " 출고 등록 Header
      gt_inew  TYPE TABLE OF zsa3mm6015,  " 출고 등록 Item
      gs_inew  LIKE LINE OF gt_inew,
      gt_pitem TYPE TABLE OF zsa3mm6016,  " 생산 오더 Item List
      gt_sitem TYPE TABLE OF zsa3mm6017,  " 판매 오더 Item List
      gt_mitem TYPE TABLE OF zsa3mm6018,  " 이동 오더 Itme List
      gs_hupt  TYPE zsa3mm6014,           " 출고 수정 Header
      gt_iupt  TYPE TABLE OF zsa3mm6015,  " 출고 수정 Item
      gs_iupt  LIKE LINE OF gt_iupt,
      gs_hdet  TYPE zsa3mm6014,           " 출고 상세 Header
      gt_idet  TYPE TABLE OF zsa3mm6015,  " 출고 상세 Item
      gs_idet  LIKE LINE OF gt_idet.

DATA: gt_uiedit TYPE tt_text,             " 출고 수정 Item Text List
      gs_uiedit LIKE LINE OF gt_uiedit,
      gt_uhedit TYPE tt_text,             " 출고 수정 Header Text List
      gs_uhedit LIKE LINE OF gt_uhedit,
      gt_diedit TYPE tt_text,             " 출고 상세 Item Text List
      gs_diedit LIKE LINE OF gt_diedit,
      gt_dhedit TYPE tt_text,             " 출고 상세 Header Text List
      gs_dhedit LIKE LINE OF gt_dhedit,
      gt_iiedit TYPE tt_text,             " 출고 등록 Item Text List
      gs_iiedit LIKE LINE OF gt_uiedit,
      gt_mhedit TYPE tt_text,             " 출고 등록 Header Text List
      gs_mhedit LIKE LINE OF gt_uiedit.

DATA: gt_range TYPE RANGE OF zsa3hr0001-erdat. " 등록일자 Range 변수

DATA: gt_dropdown TYPE vrm_values,             " Drop Down 수정용
      gs_dropdown LIKE LINE OF gt_dropdown.

CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.

    CLASS-METHODS on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING e_object.

    CLASS-METHODS on_user_command FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING e_ucomm .

    CLASS-METHODS on_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING er_data_changed  e_ucomm.

ENDCLASS.

CLASS lcl_handler_edit DEFINITION.
  PUBLIC SECTION.

    CLASS-METHODS: on_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING
        e_row_id e_column_id.

ENDCLASS.

CLASS lcl_handler_emp DEFINITION.
  PUBLIC SECTION.

    CLASS-METHODS: on_double_click FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING
        e_row e_column.

ENDCLASS.
