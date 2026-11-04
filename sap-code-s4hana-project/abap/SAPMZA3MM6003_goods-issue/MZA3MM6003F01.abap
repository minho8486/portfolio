*&---------------------------------------------------------------------*
*& Include          MZA3MM6003F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form create_container_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GO_CON
*&      --> GO_ALV
*&---------------------------------------------------------------------*


FORM create_container  USING    VALUE(p_cname)
                                po_con TYPE REF TO cl_gui_custom_container
                                po_alv TYPE REF TO cl_gui_alv_grid.
  IF po_con IS NOT INITIAL.
    RETURN.
  ENDIF.

  CREATE OBJECT po_con
    EXPORTING


*     parent                      =


      container_name              = p_cname


*     style                       =
*     lifetime                    = lifetime_default
*     repid                       =
*     dynnr                       =
*     no_autodef_progid_dynnr     =


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

  PERFORM create_alv USING po_con po_alv.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form create_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PO_CON
*&      --> PO_ALV
*&---------------------------------------------------------------------*


FORM create_alv  USING    po_con TYPE REF TO cl_gui_custom_container
                          po_alv TYPE REF TO cl_gui_alv_grid.
  CREATE OBJECT po_alv
    EXPORTING


*     i_shellstyle      = 0
*     i_lifetime        =


      i_parent          = po_con


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

  IF po_alv = go_ialv.
    SET HANDLER lcl_handler=>on_toolbar FOR po_alv.
    SET HANDLER lcl_handler=>on_user_command FOR po_alv.
    SET HANDLER lcl_handler=>on_data_changed FOR po_alv.

    CALL METHOD po_alv->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.
  ENDIF.

  IF po_alv = go_ualv OR po_alv = go_dalv OR po_alv = go_ialv OR po_alv = go_alv.
    SET HANDLER lcl_handler_edit=>on_hotspot_click FOR po_alv.
  ENDIF.

  IF po_alv = go_alv.
    SET HANDLER lcl_handler_emp=>on_double_click FOR po_alv.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GO_ALV
*&      --> GT_LIST
*&      --> P_
*&      --> GS_LAYO
*&      --> GT_FCAT
*&---------------------------------------------------------------------*


FORM display_alv  USING    po_alv TYPE REF TO cl_gui_alv_grid
                           pt_list
                           VALUE(p_sname)
                           ps_layo TYPE lvc_s_layo
                           pt_fcat TYPE lvc_t_fcat
                           pt_sort TYPE lvc_t_sort.

  CALL METHOD po_alv->set_table_for_first_display
    EXPORTING


*     i_buffer_active               =
*     i_bypassing_buffer            =
*     i_consistency_check           =


      i_structure_name              = p_sname


*     is_variant                    =
*     i_save                        =
*     i_default                     = 'X'


      is_layout                     = ps_layo


*     is_print                      =
*     it_special_groups             =
*     it_toolbar_excluding          =
*     it_hyperlink                  =
*     it_alv_graphics               =
*     it_except_qinfo               =
*     ir_salv_adapter               =


    CHANGING
      it_outtab                     = pt_list
      it_fieldcatalog               = pt_fcat
      it_sort                       = pt_sort


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
*& Form set_layo_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_LAYO
*&---------------------------------------------------------------------*


FORM set_layo_0100  CHANGING VALUE(cs_layo) TYPE lvc_s_layo.
  cs_layo-cwidth_opt = 'X'.
  cs_layo-sel_mode = 'A'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_fcat_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_FCAT
*&---------------------------------------------------------------------*


FORM set_fcat_0100  TABLES   t_fcat STRUCTURE lvc_s_fcat.
  CLEAR t_fcat[].

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'PRTYP_T' '',
                    TABLES t_fcat
                    USING 'COLTEXT' '프로세스 타입명'(t01) 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'BKTXT' '',
                    TABLES t_fcat
                    USING 'NO_OUT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'ICOND' '',
                    TABLES t_fcat
                    USING 'COLTEXT' '적요'(t02) '',
                    TABLES t_fcat
                    USING 'HOTSPOT' 'X' '',
                    TABLES t_fcat
                    USING 'ICON' 'X' 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> T_FCAT
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*


FORM set_fcat  TABLES   t_fcat STRUCTURE lvc_s_fcat
               USING    VALUE(p_fname)
                        VALUE(p_value)
                        VALUE(p_cflag).
  DATA lv_text(30).
  FIELD-SYMBOLS <fs_fcat>.

  lv_text = 'T_FCAT-' && p_fname.
  ASSIGN (lv_text) TO <fs_fcat>.

  <fs_fcat> = p_value.

  IF p_cflag = 'X'.
    APPEND t_fcat.
    CLEAR t_fcat.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_default
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_COND
*&---------------------------------------------------------------------*


FORM set_default  CHANGING VALUE(cs_cond) TYPE zsa3mm6012
                           VALUE(cv_dynnr) TYPE sy-dynnr.
  SELECT iotid
    FROM zta3mm0010
    INTO cs_cond-iotid
   UP TO 1 ROWS
   WHERE otype = 'O'
   ORDER BY iotid DESCENDING.
  ENDSELECT.

  SELECT plaid
    FROM zta3mm0006
    INTO cs_cond-plaid
   UP TO 1 ROWS
   ORDER BY plaid ASCENDING.
  ENDSELECT.

  cs_cond-erdat_s = sy-datum - 14.
  cs_cond-erdat_e = sy-datum.
  cs_cond-checb = 'X'.

  cv_dynnr = '0201'.

  gs_atbar = 'NEXT'.
  APPEND gs_atbar TO gt_atbar.
  CLEAR gs_atbar.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form modify_screen_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM modify_screen_0100 .
  LOOP AT SCREEN.
    IF screen-group1 = 'S'.
      IF gs_cond-checb = 'X'.
        screen-input = '1'.
      ELSE.
        screen-input = '0'.
      ENDIF.
    ENDIF.
    IF screen-group1 = 'M'.
      IF gs_cond-checb IS INITIAL.
        screen-input = '1'.
      ELSE.
        screen-input = '0'.
      ENDIF.
    ENDIF.

    MODIFY SCREEN.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form enter_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM enter_0100 .
  IF gs_cond-checb IS INITIAL.
    " 플랜트 명 가져오기
    PERFORM get_pname USING gs_cond-plaid
                      CHANGING gs_cond-pname gv_subrc.
    IF gv_subrc <> 0.
      PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
      RETURN.
    ENDIF.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_pname
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_COND_PLAID
*&      <-- GS_COND_PNAME
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_pname  USING    VALUE(p_plaid) TYPE zta3mm0006-plaid
                CHANGING VALUE(cv_pname) TYPE zta3mm0006_t-pname
                         VALUE(cv_subrc) TYPE sy-subrc.
  IF p_plaid IS INITIAL.
    RETURN.
  ENDIF.

  " 플랜트명 가져오기
  call function 'ZFA3MM6003'
    EXPORTING
      iv_plaid = p_plaid
      iv_spras = sy-langu
    IMPORTING
      ev_pname = cv_pname
      ev_subrc = cv_subrc.
  IF cv_subrc <> 0.
    MESSAGE i020(zmcn11601) WITH sy-langu p_plaid INTO gv_messg. " & 언어의 & 플랜트 명이 지정되지 않았습니다.
    gv_messt = 'I'.
    RETURN.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form show_message
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GV_MESSG
*&      --> GV_MESST
*&---------------------------------------------------------------------*


FORM show_message  CHANGING VALUE(cv_messg) LIKE gv_messg
                            VALUE(cv_messt) LIKE gv_messt
                            VALUE(cv_subrc) TYPE sy-subrc.
  DATA: lv_messg LIKE gv_messg,
        lv_messt LIKE gv_messt.
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


*&---------------------------------------------------------------------*
*& Form search_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM search_0100 .
  " 조건값 체크
  PERFORM check_condition USING gs_cond
                          CHANGING gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  "List 가져오기
  PERFORM get_list CHANGING gs_cond gt_list gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  " 검색 성공하면 조건값 백업
  CLEAR gs_cond2.
  gs_cond2 = gs_cond.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_list_by_iotid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_COND
*&      <-- GT_LIST
*&---------------------------------------------------------------------*


FORM get_list_by_iotid  USING    VALUE(ps_cond) TYPE zsa3mm6012
                        CHANGING ct_list LIKE gt_list
                                 VALUE(cv_subrc) TYPE sy-subrc.
  CLEAR ct_list.

  SELECT iotid plaid prtyp movid erdat ereid bktxt
    FROM zta3mm0010
    INTO CORRESPONDING FIELDS OF TABLE ct_list
   WHERE iotid = ps_cond-iotid
     AND otype = 'O'.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i002(zmcn11603) INTO gv_messg.  " 해당 조건으로 검색된 값이 없습니다.
    gv_messt = 'I'.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_list_by_others
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_COND
*&      <-- GT_LIST
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_list_by_others  USING    VALUE(ps_cond) TYPE zsa3mm6012
                         CHANGING ct_list LIKE gt_list
                                  VALUE(cv_subrc) TYPE sy-subrc.
  CLEAR ct_list.

  DATA: lt_erange TYPE RANGE OF zsa3hr0001-erdat,
        lt_arange TYPE RANGE OF zsa3hr0001-aedat.
  " 등록일자 Range 변수 만들기
  PERFORM set_erange USING ps_cond-erdat_s ps_cond-erdat_e
                     CHANGING lt_erange.
  " 수정일자 Range 변수 만들기
  PERFORM set_arange USING ps_cond-aedat_s ps_cond-aedat_e
                     CHANGING lt_arange.

  SELECT iotid plaid prtyp movid erdat ereid bktxt
    FROM zta3mm0010
    INTO CORRESPONDING FIELDS OF TABLE ct_list
   WHERE erdat IN lt_erange
     AND aedat IN lt_arange
     AND otype = 'O'
     AND plaid = ps_cond-plaid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i002(zmcn11603) INTO gv_messg.  " 해당 조건으로 검색된 값이 없습니다.
    gv_messt = 'I'.
  ENDIF.

  IF ps_cond-prtyp IS NOT INITIAL.
    DELETE ct_list WHERE prtyp <> ps_cond-prtyp.
  ENDIF.

  IF ct_list IS INITIAL.
    cv_subrc = 4.
    MESSAGE i002(zmcn11603) INTO gv_messg.  " 해당 조건으로 검색된 값이 없습니다.
    gv_messt = 'I'.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_list
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_COND
*&      <-- GT_LIST
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_list  CHANGING VALUE(cs_cond) TYPE zsa3mm6012
                        ct_list LIKE gt_list
                        cv_subrc TYPE sy-subrc.
  IF cs_cond-checb = 'X'.
    " 입출고 번호로 가져오기
    PERFORM get_list_by_iotid USING cs_cond
                              CHANGING ct_list cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.
  ELSE.
    " 플랜트명 가져오기
    PERFORM get_pname USING cs_cond-plaid
                      CHANGING cs_cond-pname cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.

    " 나머지 조건으로 가져오기
    PERFORM get_list_by_others USING cs_cond
                               CHANGING ct_list cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.
  ENDIF.

  " List Loop 돌리기
  PERFORM loop_at_list CHANGING ct_list cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_erange
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_COND_ERDAT_S
*&      --> PS_COND_ERDAT_E
*&      <-- LT_ERANGE
*&---------------------------------------------------------------------*


FORM set_erange  USING    VALUE(p_erdat_s) TYPE zsa3mm6012-erdat_s
                          VALUE(p_erdat_e) TYPE zsa3mm6012-erdat_e
                 CHANGING ct_erange LIKE gt_range.
  CLEAR ct_erange.
  DATA ls_erange LIKE LINE OF gt_range.

  IF p_erdat_e IS INITIAL.
    ls_erange-option = 'EQ'.
    ls_erange-sign = 'I'.
    ls_erange-low = p_erdat_s.
  ELSE.
    ls_erange-option = 'BT'.
    ls_erange-sign = 'I'.
    ls_erange-low = p_erdat_s.
    ls_erange-high = p_erdat_e.
  ENDIF.

  APPEND ls_erange TO ct_erange.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_arange
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_COND_AEDAT_S
*&      --> PS_COND_AEDAT_E
*&      <-- LT_ARANGE
*&---------------------------------------------------------------------*


FORM set_arange  USING    VALUE(p_aedat_s) TYPE zsa3mm6001-aedat_s
                          VALUE(p_aedat_e) TYPE zsa3mm6001-aedat_e
                 CHANGING ct_arange LIKE gt_range.
  CLEAR ct_arange.
  DATA ls_arange LIKE LINE OF gt_range.

  IF p_aedat_s IS INITIAL AND p_aedat_e IS INITIAL.
    RETURN.
  ELSEIF p_aedat_e IS INITIAL.
    ls_arange-option = 'EQ'.
    ls_arange-sign = 'I'.
    ls_arange-low = p_aedat_s.
    ls_arange-high = p_aedat_e.
  ELSE.
    ls_arange-option = 'BT'.
    ls_arange-sign = 'I'.
    ls_arange-low = p_aedat_s.
    ls_arange-high = p_aedat_e.
  ENDIF.

  APPEND ls_arange TO ct_arange.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form loop_at_list
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- CT_LIST
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM loop_at_list  CHANGING ct_list LIKE gt_list
                            VALUE(cv_subrc) TYPE sy-subrc.
  DATA ls_list TYPE zsa3mm6013.

  LOOP AT ct_list INTO ls_list.
    " 플랜트명 가져오기
    PERFORM get_pname USING ls_list-plaid
                      CHANGING ls_list-pname cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.

    " 직원명 가져오기
    PERFORM get_empnm USING ls_list-ereid
                      CHANGING ls_list-empnm cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.

    " Domain Text 가져오기
    PERFORM get_domain_value USING 'ZDA3_MM_PRTYP' ls_list-prtyp
                             CHANGING ls_list-prtyp_t.

    " 적요용 Icon
    IF ls_list-bktxt IS NOT INITIAL.
      ls_list-icond = icon_display.
    ENDIF.

    MODIFY ct_list FROM ls_list.
    CLEAR ls_list.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_empnm
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_LIST_EREID
*&      <-- LS_LIST_EMPNM
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_empnm  USING    VALUE(p_ereid) TYPE zsa3mm6013-ereid
                CHANGING VALUE(cv_empnm) TYPE zsa3mm6013-empnm
                         VALUE(cv_subrc) TYPE sy-subrc.
  call function 'ZFA3MM6004'
    EXPORTING
      iv_empid = p_ereid
    IMPORTING
      ev_empnm = cv_empnm
      ev_subrc = cv_subrc.
  IF cv_subrc <> 0.
    MESSAGE i003(zmcn11603) WITH p_ereid INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_domain_value
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> LS_LIST_PRTYP
*&      <-- LS_LIST_PRTYP_T
*&---------------------------------------------------------------------*


FORM get_domain_value  USING    VALUE(p_dname)
                                VALUE(p_value)
                       CHANGING VALUE(cv_text) TYPE dd07v-ddtext.
  DATA: lv_dname TYPE dd07v-domname,
        lv_value TYPE dd07v-domvalue_l.

  lv_dname = p_dname.
  lv_value = p_value.

  call function 'ZFA3MM6001'
    EXPORTING
      iv_domname = lv_dname
      iv_value   = lv_value
    IMPORTING
      ev_ddtext  = cv_text.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_condition
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_COND
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM check_condition  USING    VALUE(ps_cond) TYPE zsa3mm6012
                      CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  " 등록일자 조건 체크
  PERFORM check_erdat USING ps_cond-erdat_s ps_cond-erdat_e
                      CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  " 수정일자 조건 체크
  PERFORM check_aedat USING ps_cond-aedat_s ps_cond-aedat_e
                      CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_erdat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_COND_ERDAT_S
*&      --> PS_COND_ERDAT_E
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM check_erdat  USING    VALUE(p_erdat_s) TYPE zsa3mm6012-erdat_s
                           VALUE(p_erdat_e) TYPE zsa3mm6012-erdat_e
                  CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  IF gs_cond-checb = 'X'.
    RETURN.
  ENDIF.

  DATA lv_erdat TYPE datum.
  lv_erdat = p_erdat_s + 14.

  IF p_erdat_e IS NOT INITIAL.
    IF p_erdat_s > p_erdat_e.
      cv_subrc = 1.
      MESSAGE i007(zmcn11601) INTO gv_messg.  " 날짜 조건이 잘못 입력되었습니다.
      gv_messt = 'I'.
      RETURN.
    ENDIF.
    IF lv_erdat < p_erdat_e.
      cv_subrc = 2.
      MESSAGE i008(zmcn11601) INTO gv_messg.  " 날짜 범위는 2주를 초과할 수 없습니다.
      gv_messt = 'I'.
      RETURN.
    ENDIF.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_aedat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_COND_AEDAT_S
*&      --> PS_COND_AEDAT_E
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM check_aedat  USING    VALUE(p_aedat_s) TYPE zsa3mm6012-aedat_s
                           VALUE(p_aedat_e) TYPE zsa3mm6012-aedat_e
                  CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  IF gs_cond-checb = 'X'.
    RETURN.
  ENDIF.

  DATA lv_aedat TYPE datum.
  lv_aedat = p_aedat_s + 14.

  IF p_aedat_s IS NOT INITIAL AND p_aedat_e IS NOT INITIAL.
    IF p_aedat_s > p_aedat_e.
      cv_subrc = 1.
      MESSAGE i007(zmcn11601) INTO gv_messg.  " 날짜 조건이 잘못 입력되었습니다.
      gv_messt = 'I'.
      RETURN.
    ENDIF.
    IF lv_aedat < p_aedat_e.
      cv_subrc = 2.
      MESSAGE i008(zmcn11601) INTO gv_messg.  " 날짜 범위는 2주를 초과할 수 없습니다.
      gv_messt = 'I'.
      RETURN.
    ENDIF.
  ELSEIF p_aedat_e IS NOT INITIAL.
    cv_subrc = 1.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form new_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM new_0100 .
  " 출고 등록 화면으로 이동
  CALL SCREEN 200.
  CLEAR: gt_inew, gs_hnew, gt_pitem, gt_sitem, gt_mitem.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_default_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_HNEW
*&---------------------------------------------------------------------*


FORM set_default_0200  CHANGING VALUE(cs_hnew) TYPE zsa3mm6014.
  IF cs_hnew IS NOT INITIAL.
    RETURN.
  ENDIF.

  cs_hnew-otype = 'O'.
  cs_hnew-prtyp = 'PR'.


ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_search_help_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM set_odrid_f4_0200 .
  DATA: BEGIN OF ls_sh,
          odrid TYPE zsa3mm6014-odrid,
        END OF ls_sh,
        lt_sh LIKE TABLE OF ls_sh.

  DATA: lt_return    TYPE TABLE OF ddshretval,
        ls_return    LIKE LINE OF lt_return,
        lv_title(10).

  CASE gs_hnew-prtyp.
    WHEN 'PR'.
      lv_title = '생산문서'.

      SELECT podid AS odrid
        FROM zta3pp0005
        INTO CORRESPONDING FIELDS OF TABLE lt_sh
       WHERE cstat = 'C03'
       ORDER BY podid.

    WHEN 'SO'.
      lv_title = '판매문서'.

      SELECT sodid AS odrid
        FROM zta3sd0001
        INTO CORRESPONDING FIELDS OF TABLE lt_sh
       WHERE sstat = 'S2'
         AND lifsk = ''
       ORDER BY sodid.

    WHEN 'MO'.
      lv_title = '이동문서'.

      IF gs_hnew-checp = 'X'.
        SELECT movid AS odrid
          FROM zta3mm0017
          INTO CORRESPONDING FIELDS OF TABLE lt_sh
         WHERE mstat = 'M1'
           AND vtype = 'D'
         ORDER BY movid.
      ELSE.
        SELECT movid AS odrid
          FROM zta3mm0017
          INTO CORRESPONDING FIELDS OF TABLE lt_sh
         WHERE mstat = 'M1'
           AND vtype = 'P'
         ORDER BY movid.
      ENDIF.

  ENDCASE.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING


*     DDIC_STRUCTURE  = ' '


      retfield        = 'ODRID'


*     PVALKEY         = ' '


      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'ZSA3MM6014-ODRID'


*     STEPL           = 0


      window_title    = lv_title


*     VALUE           = ' '


      value_org       = 'S'


*     MULTIPLE_CHOICE = ' '
*     DISPLAY         = ' '
*     CALLBACK_PROGRAM       = ' '
*     CALLBACK_FORM   = ' '
*     CALLBACK_METHOD =
*     MARK_TAB        =
*   IMPORTING
*     USER_RESET      =


    TABLES
      value_tab       = lt_sh


*     field_tab       =


      return_tab      = lt_return


*     DYNPFLD_MAPPING =


    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
    gv_subrc = sy-subrc.
    MESSAGE i004(zmcn11603) INTO gv_messg.
    RETURN.
  ENDIF.

  PERFORM run_pai USING '=ENTER'.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_dropdown
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM set_dropdown .
  IF gt_dropdown IS NOT INITIAL.
    RETURN.
  ENDIF.

  PERFORM set_list_data USING 'PR' '생산'
                        CHANGING gt_dropdown.

  PERFORM set_list_data USING 'SO' '판매'
                        CHANGING gt_dropdown.

  PERFORM set_list_data USING 'MO' '창고이동'
                        CHANGING gt_dropdown.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'ZSA3MM6014-PRTYP'
      values          = gt_dropdown
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.


* Implement suitable error handling here


  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form run_pai
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&---------------------------------------------------------------------*


FORM run_pai  USING    VALUE(p_fcode).

  CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'
    EXPORTING
      functioncode           = p_fcode
    EXCEPTIONS
      function_not_supported = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.


* Implement suitable error handling here


  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_list_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      <-- GT_DROPDOWN
*&---------------------------------------------------------------------*


FORM set_list_data  USING    VALUE(p_key)
                             VALUE(p_text)
                    CHANGING ct_dropdown LIKE gt_dropdown.
  DATA ls_dropdown LIKE gs_dropdown.

  ls_dropdown-key = p_key.
  ls_dropdown-text  = p_text.
  APPEND ls_dropdown TO ct_dropdown.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form enter_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM enter_0200 .

  CASE gs_hnew-prtyp.
    WHEN 'PR'.
      go_ialv->check_changed_data(  ).

      " 출고 Item의 오더번호로 Header의 오더번호 바꾸기
      PERFORM set_plaid_by_pr USING gt_pitem gt_inew
                              CHANGING gs_hnew.
    WHEN 'SO'.
      go_ialv->check_changed_data(  ).
      " 출고 Item의 오더번호로 Header의 오더번호 바꾸기
      PERFORM set_plaid_by_so USING gt_sitem gt_inew
                              CHANGING gs_hnew.
    WHEN 'MO'.
      go_ialv->check_changed_data(  ).
  ENDCASE.

  " 플랜트 명 가져오기
  PERFORM get_pname USING gs_hnew-plaid
                    CHANGING gs_hnew-pname gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  " 출고 헤더 적요 Text Edit에 띄워주기
  PERFORM set_bktxt_header USING go_ihedit
                           CHANGING gs_hnew.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_layo_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_LAYO
*&---------------------------------------------------------------------*


FORM set_layo_0200  CHANGING VALUE(cs_layo) TYPE lvc_s_layo.
  CLEAR cs_layo.

  cs_layo-cwidth_opt = 'X'.
  IF gv_sflag <> 'X'.
    IF gs_hnew-prtyp = 'SO'.
      cs_layo-sel_mode = 'A'.
    ENDIF.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form prtyp_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM prtyp_0200 .
  CLEAR: gt_pitem, gt_sitem, gt_mitem,
         gt_inew, gs_hnew-plaid, gs_hnew-pname,
         gs_hnew-odrid, gs_hnew-bktxt.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form oinfo_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM oinfo_0200 .
  " 오더 Item 정보 가져오기
  PERFORM get_info CHANGING gs_hnew gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  CASE gs_hnew-prtyp.
    WHEN 'MO'.
      " 이동오더일 때 출고 Item 추가 하기
      PERFORM add_gi_item_mo USING gt_mitem
                             CHANGING gs_hnew gt_inew gv_subrc.
      IF gv_subrc <> 0.
        gv_messt = 'I'.
        CLEAR: gt_inew, gs_hnew-plaid, gs_hnew-pname.
        PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
        RETURN.
      ENDIF.
    WHEN 'PR'.
      " 생산오더 시작일 때 출고 Item 추가하기
      PERFORM add_gi_item_pr_start USING gt_pitem
                                   CHANGING gs_hnew gt_inew gv_subrc.
      IF gv_subrc <> 0.
        gv_messt = 'I'.
        CLEAR: gt_inew, gs_hnew-plaid, gs_hnew-pname.
        PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
        RETURN.
      ENDIF.
  ENDCASE.

  " 플랜트명 가져오기
  PERFORM get_pname USING gs_hnew-plaid
                    CHANGING gs_hnew-pname gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_header_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_HNEW
*&      <-- GT_INEW
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_info  CHANGING VALUE(cs_hnew) TYPE zsa3mm6014
                        VALUE(cv_subrc) TYPE sy-subrc.
  IF cs_hnew-odrid IS INITIAL.
    cv_subrc = 4.
    MESSAGE i005(zmcn11603) INTO gv_messg.  " 관련 문서 번호는 필수값 입니다.
    gv_messt = 'I'.
    RETURN.
  ENDIF.

  CLEAR: cs_hnew-plaid, cs_hnew-pname.

  " 오더별 상태 확인
  PERFORM check_state USING cs_hnew-odrid
                      CHANGING cv_subrc.
  IF cv_subrc <> 0.
    gv_messt = 'I'.
    RETURN.
  ENDIF.

  " 오더별 Item 정보 가져오기
  PERFORM get_item_info USING cs_hnew-odrid cs_hnew-prtyp cs_hnew-checp
                        CHANGING gt_mitem gt_sitem gt_pitem cv_subrc.
  IF cv_subrc <> 0.
    gv_messt = 'I'.
    RETURN.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_item_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- CT_INEW
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_item_info  USING    VALUE(p_odrid) TYPE zsa3mm6014-odrid
                             VALUE(p_prtyp) TYPE zsa3mm6014-prtyp
                             VALUE(p_checp) TYPE zsa3mm6014-checp
                    CHANGING ct_mitem LIKE gt_mitem
                             ct_sitem LIKE gt_sitem
                             ct_pitem LIKE gt_pitem
                             VALUE(cv_subrc) TYPE sy-subrc.
  CLEAR: ct_mitem, ct_sitem, ct_mitem, gt_inew.

  CASE p_prtyp.
    WHEN 'MO'.
      SELECT movid scode plaid matid mtcnt meins docnm sfcod
        FROM zta3mm0018
        INTO CORRESPONDING FIELDS OF TABLE ct_mitem
       WHERE movid = p_odrid.
      IF sy-subrc <> 0.
        MESSAGE i006(zmcn11603) WITH p_odrid INTO gv_messg. " & 없는 오더번호 입니다.
        cv_subrc = 4.
        RETURN.
      ENDIF.
    WHEN 'PR'.
      SELECT podid scode rawnr plaid opcod pquan meins gifla
        FROM zta3pp0006
        INTO CORRESPONDING FIELDS OF TABLE ct_pitem
       WHERE podid = p_odrid.
      IF sy-subrc <> 0.
        MESSAGE i006(zmcn11603) WITH p_odrid INTO gv_messg. " & 없는 오더번호 입니다.
        cv_subrc = 4.
        RETURN.
      ENDIF.
    WHEN 'SO'.
      SELECT sodid scode matid plaid squan meins sflag gifla
        FROM zta3sd0002
        INTO CORRESPONDING FIELDS OF TABLE ct_sitem
       WHERE sodid = p_odrid
         AND gifla = ''.
      IF sy-subrc <> 0.
        MESSAGE i006(zmcn11603) WITH p_odrid INTO gv_messg. " & 없는 오더번호 입니다.
        cv_subrc = 4.
        RETURN.
      ENDIF.
  ENDCASE.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_fcat_oinfo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_FCAT
*&---------------------------------------------------------------------*


FORM set_fcat_oinfo  TABLES   t_fcat STRUCTURE lvc_s_fcat.
  CLEAR t_fcat[].

  IF gs_hnew-prtyp <> 'MO'.
    PERFORM set_fcat: TABLES t_fcat
                      USING 'FIELDNAME' 'GIFLA' '',
                      TABLES t_fcat
                      USING 'CHECKBOX' 'X' 'X'.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_sort_oinfo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_SORT
*&---------------------------------------------------------------------*


FORM set_sort_oinfo  TABLES   t_sort STRUCTURE lvc_s_sort.
  CLEAR t_sort[].

  PERFORM set_sort: TABLES t_sort
                    USING 'FIELDNAME' 'SCODE' '',
                    TABLES t_sort
                    USING 'UP' 'X' 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> T_SORT
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*


FORM set_sort  TABLES   t_sort STRUCTURE lvc_s_sort
               USING    VALUE(p_fname)
                        VALUE(p_value)
                        VALUE(p_cflag).
  DATA lv_text(30).
  FIELD-SYMBOLS <fs_sort>.

  lv_text = 'T_SORT-' && p_fname.
  ASSIGN (lv_text) TO <fs_sort>.

  <fs_sort> = p_value.

  IF p_cflag = 'X'.
    APPEND t_sort.
    CLEAR t_sort.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_sort_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_SORT
*&---------------------------------------------------------------------*


FORM set_sort_0200  TABLES   t_sort STRUCTURE lvc_s_sort.
  CLEAR t_sort[].
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_sort_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_SORT
*&---------------------------------------------------------------------*


FORM set_sort_0100  TABLES   t_sort STRUCTURE lvc_s_sort.
  CLEAR t_sort[].

  PERFORM set_sort: TABLES t_sort
                    USING 'FIELDNAME' 'IOTID' '',
                    TABLES t_sort
                    USING 'SPOS' '1' '',
                    TABLES t_sort
                    USING 'DOWN' 'X' 'X'.

  PERFORM set_sort: TABLES t_sort
                    USING 'FIELDNAME' 'ERDAT' '',
                    TABLES t_sort
                    USING 'SPOS' '2' '',
                    TABLES t_sort
                    USING 'DOWN' 'X' 'X'.

  PERFORM set_sort: TABLES t_sort
                    USING 'FIELDNAME' 'PNAME' '',
                    TABLES t_sort
                    USING 'SPOS' '3' '',
                    TABLES t_sort
                    USING 'UP' 'X' 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form add_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM on_add .

  CASE gs_hnew-prtyp.
    WHEN 'SO'.
      " 판매오더일 때 출고 Item 추가
      PERFORM add_gi_item_by_so USING gt_sitem gs_hnew
                                CHANGING gt_inew gv_subrc.
      IF gv_subrc <> 0.
        gv_messt = 'I'.
        PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
        RETURN.
      ENDIF.
  ENDCASE.

  " 시퀀스 번호 재설정
  PERFORM set_inew_index CHANGING gt_inew.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form add_item
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_PINFO
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM add_item  USING    pt_pinfo
               CHANGING VALUE(cv_subrc).

ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_inventory_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_PINFO
*&      <-- LS_PROC2
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_inventory_info  USING    VALUE(p_matid) TYPE zta3mm0001-matid
                                  VALUE(p_plaid) TYPE zta3mm0006-plaid
                         CHANGING ct_proc1 TYPE tt_proc1
                                  VALUE(cv_subrc) TYPE sy-subrc.
  SELECT a~matid, plaid AS plaid1, stoid, a~batid, labst,
         scrap, hsdat, qualt, meins, maqua
    FROM zta3mm0002 AS a
   INNER JOIN zta3mm0003 AS b
      ON a~matid = b~matid
     AND a~batid = b~batid
   INNER JOIN zta3mm0001 AS c
      ON a~matid = c~matid
    INTO CORRESPONDING FIELDS OF TABLE @ct_proc1
   WHERE a~matid = @p_matid
     AND a~plaid = @p_plaid
     AND b~qualt <> '300'
     AND b~dflag <> 'X'
     AND a~labst <> 0
   ORDER BY hsdat ASCENDING.
  IF sy-subrc <> 0.
    cv_subrc = 4.
    MESSAGE i009(zmcn11603) WITH p_plaid p_matid INTO gv_messg. " & 자재 재고가 부족합니다.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_depart_plant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_HNEW_ODRID
*&      <-- LS_PROC1_PLAID2
*&---------------------------------------------------------------------*


FORM get_depart_plant  USING    p_odrid TYPE zsa3mm6014-odrid
                       CHANGING VALUE(cv_plaid2) TYPE zta3mm0006-plaid
                                VALUE(cv_subrc) TYPE sy-subrc.

  IF gs_hnew-prtyp = 'PR'.
    SELECT SINGLE plaid
      FROM zta3pp0005
      INTO cv_plaid2
     WHERE podid = p_odrid.
    IF sy-subrc <> 0.
      cv_subrc = 4.
      MESSAGE i008(zmcn11603) INTO gv_messg. " 알 수 없는 오류입니다.
      RETURN.
    ENDIF.
  ELSEIF gs_hnew-prtyp = 'MO'.
    SELECT SINGLE plaid
      FROM zta3mm0017
      INTO cv_plaid2
     WHERE movid = p_odrid.
    IF sy-subrc <> 0.
      cv_subrc = 4.
      MESSAGE i008(zmcn11603) INTO gv_messg." 알 수 없는 오류입니다.
      RETURN.
    ENDIF.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_depart_bp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_HNEW_ODRID
*&      <-- LS_PROC1_BUPID
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_depart_bp  USING    p_odrid TYPE zsa3mm6014-odrid
                    CHANGING VALUE(cv_bupid) TYPE zta3mm0004-bupid
                             VALUE(cv_subrc) TYPE sy-subrc.

  SELECT SINGLE bupid
    FROM zta3sd0001
    INTO cv_bupid
   WHERE sodid = p_odrid.
  IF sy-subrc <> 0.
    cv_subrc = 4.
    MESSAGE i008(zmcn11603) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_city_by_plant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_PROC1_PLAID1
*&      <-- LS_PROC1_CITY1
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_city_by_plant  USING    VALUE(p_plaid) TYPE zta3mm0006-plaid
                        CHANGING VALUE(cv_cityc) TYPE zta3mm0006-cityc
                                 VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE cityc
    FROM zta3mm0006
    INTO cv_cityc
   WHERE plaid = p_plaid.
  IF sy-subrc <> 0.
    cv_subrc = 4.
    MESSAGE i008(zmcn11603) INTO gv_messg. " 알 수 없는 오류입니다.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_city_by_bp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_PROC1_BUPID
*&      <-- LS_PROC1_CITY2
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_city_by_bp  USING    VALUE(p_bupid) TYPE zta3mm0004-bupid
                     CHANGING VALUE(cv_cityc) TYPE zta3hr0003-cityc
                              VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE cityc
    FROM zta3mm0004
    INTO cv_cityc
   WHERE bupid = p_bupid.
  IF sy-subrc <> 0.
    cv_subrc = 4.
    MESSAGE i008(zmcn11603) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_leadtime
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_PROC1_CITY1
*&      --> LS_PROC1_CITY2
*&      <-- LS_PROC1_LEADT
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_leadtime  USING    VALUE(p_city1) TYPE zta3mm0014-city1
                            VALUE(p_city2) TYPE zta3mm0014-city2
                   CHANGING VALUE(cv_leadt) TYPE zta3mm0014-leadt
                            VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE leadt
    FROM zta3mm0014
    INTO cv_leadt
   WHERE city1 = p_city1
     AND city2 = p_city2
     AND trstp = 'T01'.
  IF sy-subrc <> 0.
    SELECT SINGLE leadt
      FROM zta3mm0014
      INTO cv_leadt
     WHERE city1 = p_city2
       AND city2 = p_city1
       AND trstp = 'T01'.
    IF sy-subrc <> 0.
      cv_subrc = 4.
      MESSAGE i008(zmcn11603) INTO gv_messg. " 알 수 없는 오류입니다.
      RETURN.
    ENDIF.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_pouid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_HNEW_ODRID
*&      <-- LS_PHEAD
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_prdnr  USING    VALUE(p_odrid) TYPE zsa3mm6014-odrid
                CHANGING VALUE(cv_prdnr) TYPE zta3pp0005-prdnr
                         VALUE(cv_subrc) TYPE sy-subrc.

  SELECT SINGLE prdnr
    FROM zta3pp0005
    INTO cv_prdnr
   WHERE podid = p_odrid.
  IF sy-subrc <> 0.
    cv_subrc = 4.
    MESSAGE i008(zmcn11603) INTO gv_messg. " 알 수 없는 오류입니다.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_matgr
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_PHEAD_POUID
*&      <-- LV_MATGR
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_matgr  USING    VALUE(p_matid) TYPE zta3mm0001-matid
                CHANGING VALUE(cv_matgr) TYPE zta3mm0001-matgr
                         VALUE(cv_subrc) TYPE sy-subrc.
  CLEAR cv_matgr.

  SELECT SINGLE matgr
    FROM zta3mm0001
    INTO cv_matgr
   WHERE matid = p_matid.
  IF sy-subrc <> 0.
    cv_subrc = 4.
    MESSAGE i008(zmcn11603) INTO gv_messg. " 알 수 없는 오류입니다.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_inew_index
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_INEW
*&---------------------------------------------------------------------*


FORM set_inew_index  CHANGING ct_inew LIKE gt_inew.
  DATA: ls_inew LIKE gs_inew.

  LOOP AT ct_inew INTO ls_inew.
    ls_inew-icond = icon_display.
    ls_inew-scode = sy-tabix.

    MODIFY ct_inew FROM ls_inew.
    CLEAR ls_inew.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form add_gi_item_by_so
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_SITEM
*&      --> GS_HNEW
*&      <-- GT_INEW
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM add_gi_item_by_so  USING    pt_sitem LIKE gt_sitem
                                 VALUE(ps_hnew) LIKE gs_hnew
                        CHANGING ct_inew LIKE gt_inew
                                 VALUE(cv_subrc) TYPE sy-subrc.

  DATA: lt_rows   TYPE lvc_t_roid,
        ls_rows   TYPE lvc_s_roid,
        ls_sitem  TYPE ts_sitem,
        ls_shead  TYPE zta3sd0001,
        ls_proc1  TYPE ts_proc1,
        lt_proc1  LIKE TABLE OF ls_proc1,
        ls_inew   LIKE gs_inew,
        lt_backup LIKE gt_inew.

  DATA: lv_datum TYPE datum,
        lv_quant TYPE zsa3mm6015-mtcnt,
        lv_lines TYPE i.

  CALL METHOD go_oalv->get_selected_rows
    IMPORTING
      et_row_no = lt_rows.

  IF lt_rows IS INITIAL.
    cv_subrc = 4.
    MESSAGE i011(zmcn11603) INTO gv_messg. " 최소 한개의 행을 선택해야 합니다.
    RETURN.
  ENDIF.

  lt_backup = ct_inew.

  LOOP AT lt_rows INTO ls_rows.
    READ TABLE pt_sitem INDEX ls_rows-row_id INTO ls_sitem.

    IF ls_sitem-sodid <> ps_hnew-odrid.
      cv_subrc = 4.
      MESSAGE i033(zmcn11603) INTO gv_messg. " 오더 정보 가져오기를 먼저 눌러주십시오.
      RETURN.
    ENDIF.

    " 출고 Item이 비어있지 않다면
    IF ct_inew IS NOT INITIAL.
      " 이미 추가한 오더 Item인지 확인
      READ TABLE ct_inew WITH KEY sodid = ls_sitem-sodid sfcod = ls_sitem-scode INTO ls_inew.
      IF sy-subrc = 0.
        cv_subrc = 4.
        ct_inew = lt_backup.
        MESSAGE i007(zmcn11603) WITH ls_sitem-sodid ls_sitem-scode INTO gv_messg. " & & 이미 추가된 아이템입니다.
        RETURN.
      ENDIF.

      " 추가하려는 플랜트와 기존에 추가된 플랜트가 다른지 확인
      IF ps_hnew-plaid <> ls_sitem-plaid .
        cv_subrc = 4.
        ct_inew = lt_backup.
        MESSAGE i010(zmcn11603) WITH ls_sitem-sodid ls_sitem-scode INTO gv_messg. " 한번에 하나의 플랜트에서만 출고가 가능합니다.
        RETURN.
      ENDIF.
    ENDIF.

    " 재고, 배치, 자재 정보 가져오기
    PERFORM get_inventory_info USING ls_sitem-matid ls_sitem-plaid
                               CHANGING lt_proc1 cv_subrc.
    IF cv_subrc <> 0.
      ct_inew = lt_backup.
      RETURN.
    ENDIF.

    DESCRIBE TABLE lt_proc1 LINES lv_lines.

    LOOP AT lt_proc1 INTO ls_proc1.
      " 도착지 플랜트 가져오기
      PERFORM get_depart_bp USING ps_hnew-odrid
                            CHANGING ls_proc1-bupid cv_subrc.
      IF cv_subrc <> 0.
        ct_inew = lt_backup.
        RETURN.
      ENDIF.

      " 출발 플랜트 도시정보 가져오기
      PERFORM get_city_by_plant USING ls_proc1-plaid1
                                CHANGING ls_proc1-city1 cv_subrc.
      IF cv_subrc <> 0.
        ct_inew = lt_backup.
        RETURN.
      ENDIF.

      " 도착 플랜트 도시정보 가져오기
      PERFORM get_city_by_bp USING ls_proc1-bupid
                             CHANGING ls_proc1-city2 cv_subrc.
      IF cv_subrc <> 0.
        ct_inew = lt_backup.
        RETURN.
      ENDIF.

      " 리드타임 가져오기
      PERFORM get_leadtime USING ls_proc1-city1 ls_proc1-city2
                           CHANGING ls_proc1-leadt cv_subrc.
      IF cv_subrc <> 0.
        ct_inew = lt_backup.
        RETURN.
      ENDIF.

      " 사용 마감일 계산하기
      lv_datum = ls_proc1-hsdat + ls_proc1-maqua - ls_proc1-leadt - 7.

      " 사용마감일 이전일 때
      IF sy-datum <= lv_datum.
        " 재고가 필요수량보다 많을 때
        IF ls_proc1-labst >= ls_sitem-squan.
          " 출고 Item에 추가하기
          PERFORM append_to_item_so USING ls_sitem ls_proc1 'X'
                                    CHANGING ct_inew.
          EXIT.
        ELSE.
          " 마지막 레코드일 때
          IF sy-tabix = lv_lines.
            " 추가한 자재 삭제
            DELETE ct_inew WHERE matid = ls_proc1-matid.
            MESSAGE i009(zmcn11603) WITH ls_proc1-plaid1 ls_proc1-matid. " & 플랜트의 & 자재 재고가 부족합니다.
          ELSE.
            " 출고 Item에 추가하기
            PERFORM append_to_item_so USING ls_sitem ls_proc1 ''
                                      CHANGING ct_inew.

            " 추가한 재고만큼 필요수량에서 빼기
            ls_sitem-squan = ls_sitem-squan - ls_proc1-labst.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDLOOP.
    " 출고 Header에 플랜트 번호 넣기
    PERFORM set_plaid_by_so USING pt_sitem ct_inew
                            CHANGING ps_hnew.

    CLEAR: ls_rows.
  ENDLOOP.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form add_gi_item_by_mo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_MITEM
*&      --> GS_HNEW
*&      <-- GT_INEW
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM add_gi_item_by_mo  USING    pt_mitem LIKE gt_mitem
                                 VALUE(ps_hnew) LIKE gs_hnew
                        CHANGING ct_inew LIKE gt_inew
                                 VALUE(cv_subrc) TYPE sy-subrc.
  DATA: ls_proc1  TYPE ts_proc1,
        lt_proc1  LIKE TABLE OF ls_proc1,
        ls_mitem  TYPE ts_mitem,
        ls_inew   LIKE gs_inew,
        ls_phead  TYPE zta3pp0005,
        lv_matgr  TYPE zta3mm0001-matgr,
        lt_backup LIKE gt_inew.

  DATA: lv_datum TYPE datum,
        lv_quant TYPE zsa3mm6015-mtcnt,
        lv_lines TYPE i.

  LOOP AT pt_mitem INTO ls_mitem.
    PERFORM get_pp_header_info USING ls_mitem-docnm
                               CHANGING ls_phead.

    " 재고, 배치, 자재 정보 가져오기
    PERFORM get_inventory_info USING ls_mitem-matid ls_mitem-plaid
                               CHANGING lt_proc1 cv_subrc.
    IF cv_subrc <> 0.
      ct_inew = lt_backup.
      RETURN.
    ENDIF.

    " 완재품 자재그룹 가져오기
    PERFORM get_matgr USING ls_phead-prdnr
                      CHANGING lv_matgr cv_subrc.
    IF cv_subrc <> 0.
      ct_inew = lt_backup.
      RETURN.
    ENDIF.

    " 완제품이 생지류 일 때
    IF lv_matgr = 'KNE'.
      " 원자재 자재그룹 가져오기
      PERFORM get_matgr USING ls_mitem-matid
                        CHANGING lv_matgr cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.

      " 자재그룹이 과일일 때
      IF lv_matgr = 'FRU'.
        " 품질 상태가 100이 아닌것 삭제하기
        DELETE lt_proc1 WHERE qualt <> '100'.
      ENDIF.
    ENDIF.

    IF lt_proc1 IS INITIAL.
      cv_subrc = 4.
      MESSAGE i009(zmcn11603) WITH ls_mitem-plaid ls_mitem-matid INTO gv_messg. " & 플랜트의 & 자재 재고가 부족합니다.
      RETURN.
    ENDIF.

    DESCRIBE TABLE lt_proc1 LINES lv_lines.

    LOOP AT lt_proc1 INTO ls_proc1.
      " 도착지 플랜트 가져오기
      PERFORM get_depart_plant USING ps_hnew-odrid
                               CHANGING ls_proc1-plaid2 cv_subrc.
      IF cv_subrc <> 0.
        ct_inew = lt_backup.
        RETURN.
      ENDIF.

      " 출발 플랜트 도시정보 가져오기
      PERFORM get_city_by_plant USING ls_proc1-plaid1
                                CHANGING ls_proc1-city1 cv_subrc.
      IF cv_subrc <> 0.
        ct_inew = lt_backup.
        RETURN.
      ENDIF.

      " 도착 플랜트 도시정보 가져오기
      PERFORM get_city_by_plant USING ls_proc1-plaid2
                                CHANGING ls_proc1-city2 cv_subrc.
      IF cv_subrc <> 0.
        ct_inew = lt_backup.
        RETURN.
      ENDIF.

      " 리드타임 가져오기
      PERFORM get_leadtime USING ls_proc1-city1 ls_proc1-city2
                           CHANGING ls_proc1-leadt cv_subrc.
      IF cv_subrc <> 0.
        ct_inew = lt_backup.
        RETURN.
      ENDIF.

      " 사용 마감일 계산하기
      PERFORM set_datum_for_quant USING ls_phead-prdnr ls_proc1
                                  CHANGING lv_datum cv_subrc.
      IF cv_subrc <> 0.
        ct_inew = lt_backup.
        RETURN.
      ENDIF.

      " 사용마감일 이전일 때
      IF sy-datum <= lv_datum.
        " 재고가 필요수량보다 많을 때
        IF ls_proc1-labst >= ls_mitem-mtcnt.
          " 출고 Item에 추가하기
          PERFORM append_to_item_mo USING ls_mitem ls_proc1 'X' ''
                                    CHANGING ct_inew.
          EXIT.
        ELSE.
          " 마지막 레코드일 때
          IF sy-tabix = lv_lines.
            " 추가한 자재 삭제
            DELETE ct_inew WHERE matid = ls_proc1-matid.
            cv_subrc = 4.
            MESSAGE i009(zmcn11603) WITH ls_proc1-plaid1 ls_proc1-matid INTO gv_messg. " & 플랜트의 & 자재 재고가 부족합니다.
            RETURN.
          ELSE.
            " 출고 Item에 추가하기
            PERFORM append_to_item_mo USING ls_mitem ls_proc1 '' ''
                                      CHANGING ct_inew.

            " 추가한 재고만큼 필요수량에서 빼기
            ls_mitem-mtcnt = ls_mitem-mtcnt - ls_proc1-labst.
          ENDIF.
        ENDIF.
      ELSE.
        cv_subrc = 4.
        MESSAGE i009(zmcn11603) WITH ls_proc1-plaid1 ls_proc1-matid INTO gv_messg. " & 플랜트의 & 자재 재고가 부족합니다.
        RETURN.
      ENDIF.

    ENDLOOP.

    CLEAR: ls_mitem.
  ENDLOOP.

  IF ct_inew IS INITIAL.
    cv_subrc = 4.
    MESSAGE i009(zmcn11603) WITH ls_proc1-plaid1 ls_proc1-matid INTO gv_messg. " & 플랜트의 & 자재 재고가 부족합니다.
    RETURN.
  ENDIF.

  MESSAGE s013(zmcn11603). " 이동오더는 부분 출고가 불가능하여 모두 등록 됩니다.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_datum_for_quant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_MATGR
*&      --> LS_PROC1
*&      <-- LV_DATUM
*&---------------------------------------------------------------------*


FORM set_datum_for_quant  USING    VALUE(p_prdnr) TYPE zta3mm0001-matid
                                   VALUE(ps_proc1) TYPE ts_proc1
                          CHANGING VALUE(cv_datum) TYPE datum
                                   VALUE(cv_subrc) TYPE sy-subrc.
  DATA: lv_matgr TYPE zta3mm0001-matgr.

  PERFORM get_matgr USING p_prdnr
                    CHANGING lv_matgr cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.
  IF lv_matgr = 'BEV'.

    PERFORM get_matgr USING ps_proc1-matid
                      CHANGING lv_matgr cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.
    IF lv_matgr = 'FRU'.
      cv_datum = ps_proc1-hsdat + ( 2 * ps_proc1-maqua ) - ps_proc1-leadt - 1.
    ELSE.
      cv_datum = ps_proc1-hsdat + ps_proc1-maqua - ps_proc1-leadt - 1.
    ENDIF.

  ELSE.

    cv_datum = ps_proc1-hsdat + ps_proc1-maqua - ps_proc1-leadt.

  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form append_to_item
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_PROC1
*&      --> LS_PITEM
*&      --> LV_DATUM
*&      --> LV_LINES
*&      <-- CT_INEW
*&---------------------------------------------------------------------*


FORM append_to_item_pr  USING    VALUE(ps_pitem) TYPE ts_pitem
                                 VALUE(ps_proc1) TYPE ts_proc1
                                 VALUE(ps_inven) TYPE zta3mm0002
                                 VALUE(p_sflag) TYPE char1
                        CHANGING ct_inew LIKE gt_inew.
  DATA: ls_inew LIKE gs_inew.

  ls_inew-matid = ps_proc1-matid.
  ls_inew-stoid = ps_proc1-stoid.
  ls_inew-podid = ps_pitem-podid.
  ls_inew-batid = ps_proc1-batid.
  ls_inew-meins = ps_proc1-meins.
  ls_inew-sfcod = ps_pitem-scode.
  IF p_sflag = 'X'.
    ls_inew-mtcnt = ps_pitem-pquan.
  ELSE.
    ls_inew-mtcnt = ps_inven-labst.
  ENDIF.

  APPEND ls_inew TO ct_inew.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form refresh_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GO_OALV
*&      --> GS_LAYO
*&      --> GT_FCAT[]
*&---------------------------------------------------------------------*


FORM refresh_alv  USING    po_alv TYPE REF TO cl_gui_alv_grid
                           ps_layo TYPE lvc_s_layo
                           pt_fcat TYPE lvc_t_fcat.
  DATA: ls_stbl TYPE lvc_s_stbl,
        lt_fcat TYPE lvc_t_fcat.

  CALL METHOD po_alv->set_frontend_layout
    EXPORTING
      is_layout = ps_layo.

  CALL METHOD po_alv->get_frontend_fieldcatalog
    IMPORTING
      et_fieldcatalog = lt_fcat.

  CALL METHOD po_alv->set_frontend_fieldcatalog
    EXPORTING
      it_fieldcatalog = lt_fcat.

  ls_stbl-row = 'X'.
  ls_stbl-col = 'X'.
  CALL METHOD po_alv->refresh_table_display
    EXPORTING
      is_stable = ls_stbl.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_plaid_by_pr
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_PITEM
*&      <-- GS_HNEW
*&---------------------------------------------------------------------*


FORM set_plaid_by_pr  USING    pt_pitem LIKE gt_pitem
                               pt_inew LIKE gt_inew
                      CHANGING VALUE(cs_hnew) LIKE gs_hnew.

  CLEAR: cs_hnew-plaid, cs_hnew-pname.

  DATA: ls_pitem TYPE ts_pitem,
        ls_inew  LIKE gs_inew.

  IF pt_inew IS INITIAL.
    RETURN.
  ENDIF.

  READ TABLE pt_inew INDEX 1 INTO ls_inew.
  READ TABLE pt_pitem WITH KEY podid = ls_inew-podid scode = ls_inew-sfcod INTO ls_pitem.
  cs_hnew-plaid = ls_pitem-plaid.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form on_remove
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM on_remove .

  CASE gs_hnew-prtyp.
    WHEN 'PR'.
      PERFORM remove_rows_at_inew USING go_ialv
                                  CHANGING gt_inew gv_subrc.
      IF gv_subrc <> 0.
        gv_messt = 'I'.
        PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
        RETURN.
      ENDIF.
    WHEN 'SO'.
      PERFORM remove_rows_at_inew USING go_ialv
                                  CHANGING gt_inew gv_subrc.
      IF gv_subrc <> 0.
        gv_messt = 'I'.
        PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
        RETURN.
      ENDIF.
    WHEN 'MO'.
      PERFORM remove_rows_at_inew USING go_ialv
                                  CHANGING gt_inew gv_subrc.
      IF gv_subrc <> 0.
        gv_messt = 'I'.
        PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
        RETURN.
      ENDIF.
  ENDCASE.


  PERFORM set_inew_index CHANGING gt_inew.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form remove_rows_at_inew
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_INEW
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM remove_rows_at_inew  USING    po_alv TYPE REF TO cl_gui_alv_grid
                          CHANGING ct_inew LIKE gt_inew
                                   VALUE(cv_subrc) TYPE sy-subrc.
  DATA: lt_rows TYPE lvc_t_roid,
        ls_rows TYPE lvc_s_roid,
        ls_inew LIKE gs_inew,
        lt_inew LIKE gt_inew.


  CALL METHOD po_alv->get_selected_rows
    IMPORTING
      et_row_no = lt_rows.

  IF lt_rows IS INITIAL.
    cv_subrc = 4.
    MESSAGE i011(zmcn11603) INTO gv_messg.
    RETURN.
  ENDIF.

  LOOP AT lt_rows INTO ls_rows.

    READ TABLE ct_inew INDEX ls_rows-row_id INTO ls_inew.
    APPEND ls_inew TO lt_inew.
    CLEAR: ls_rows, ls_inew.

  ENDLOOP.

  LOOP AT lt_inew INTO ls_inew.
    CASE gs_hnew-prtyp.
      WHEN 'PR'.
        DELETE ct_inew WHERE podid = ls_inew-podid
                         AND sfcod = ls_inew-sfcod.
      WHEN 'SO'.
        DELETE ct_inew WHERE sodid = ls_inew-sodid
                         AND sfcod = ls_inew-sfcod.
      WHEN 'MO'.

    ENDCASE.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form append_to_item_so
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_SITEM
*&      --> LS_PROC1
*&      --> P_
*&      <-- LT_INEW
*&---------------------------------------------------------------------*


FORM append_to_item_so  USING    VALUE(ps_sitem) TYPE ts_sitem
                                 VALUE(ps_proc1) TYPE ts_proc1
                                 VALUE(p_sflag) TYPE char1
                        CHANGING ct_inew LIKE gt_inew.

  DATA: ls_inew LIKE gs_inew.

  ls_inew-matid = ps_proc1-matid.
  ls_inew-stoid = ps_proc1-stoid.
  ls_inew-sodid = ps_sitem-sodid.
  ls_inew-batid = ps_proc1-batid.
  ls_inew-meins = ps_proc1-meins.
  ls_inew-sfcod = ps_sitem-scode.
  IF p_sflag = 'X'.
    ls_inew-mtcnt = ps_sitem-squan.
  ELSE.
    ls_inew-mtcnt = ps_proc1-labst.
  ENDIF.

  APPEND ls_inew TO ct_inew.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form insert_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM insert_0200 .
  " 출고 등록 정보 검사
  PERFORM check_insert_info USING gs_hnew gt_inew gt_mitem
                            CHANGING gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  " 정말로 등록할건지 재확인
  PERFORM ask_again USING TEXT-q01
                    CHANGING gv_answer.
  IF gv_answer <> '1'.
    CLEAR gv_answer.
    RETURN.
  ENDIF.
  CLEAR gv_answer.

  " 출고 정보 등록
  PERFORM insert_entity CHANGING gs_hnew gt_inew
                                 gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'E'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.

  " 등록된 출고 정보 보여주기
  PERFORM set_next.

  " 백업했던 조건으로 조회 List 새로고침 하기
  PERFORM get_list USING gs_cond2
                   CHANGING gt_list gv_subrc.
  CLEAR gv_subrc.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form next_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM next_0200 .
  DATA: ls_atbar LIKE gs_atbar.

  CLEAR: gv_dynnr, gv_sflag, gt_atbar, gs_hnew, gt_inew,
         gt_pitem, gt_sitem, gt_mitem.
  gv_dynnr = '0201'.
  gv_sflag = ''.
  ls_atbar = 'NEXT'.
  APPEND ls_atbar TO gt_atbar.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_dynnr2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_HNEW_PRTYP
*&      <-- GV_DYNNR2
*&---------------------------------------------------------------------*


FORM set_dynnr2  USING    VALUE(p_prtyp) TYPE zsa3mm6014-prtyp
                 CHANGING VALUE(cv_dynnr2) TYPE sy-dynnr.
  CASE p_prtyp.
    WHEN 'PR'.
      cv_dynnr2 = '0211'.
    WHEN 'SO'.
      cv_dynnr2 = '0212'.
    WHEN 'MO'.
      cv_dynnr2 = '0213'.
  ENDCASE.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_plaid_by_so
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_SITEM
*&      --> GT_INEW
*&      <-- GS_HNEW
*&---------------------------------------------------------------------*


FORM set_plaid_by_so  USING    pt_sitem LIKE gt_sitem
                               pt_inew LIKE gt_inew
                      CHANGING VALUE(cs_hnew) LIKE gs_hnew.

  CLEAR: cs_hnew-plaid, cs_hnew-pname.

  DATA: ls_sitem TYPE ts_sitem,
        ls_inew  LIKE gs_inew.

  IF pt_inew IS INITIAL.
    RETURN.
  ENDIF.

  READ TABLE pt_inew INDEX 1 INTO ls_inew.
  READ TABLE pt_sitem WITH KEY sodid = ls_inew-sodid scode = ls_inew-sfcod INTO ls_sitem.
  cs_hnew-plaid = ls_sitem-plaid.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form append_to_item_mo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_MITEM
*&      --> LS_PROC1
*&      --> P_
*&      <-- CT_INEW
*&---------------------------------------------------------------------*


FORM append_to_item_mo  USING    VALUE(ps_mitem) TYPE ts_mitem
                                 VALUE(ps_proc1) TYPE ts_proc1
                                 VALUE(p_sflag) TYPE char1
                                 VALUE(p_dflag) TYPE char1
                        CHANGING ct_inew LIKE gt_inew.

  DATA: ls_inew LIKE gs_inew.

  ls_inew-matid = ps_proc1-matid.
  ls_inew-stoid = ps_proc1-stoid.
  ls_inew-batid = ps_proc1-batid.
  ls_inew-meins = ps_proc1-meins.
  IF p_dflag = 'X'.
    IF p_sflag = 'X'.
      ls_inew-mtcnt = ps_mitem-mtcnt.
    ELSE.
      ls_inew-mtcnt = ps_proc1-scrap.
    ENDIF.
  ELSE.
    IF p_sflag = 'X'.
      ls_inew-mtcnt = ps_mitem-mtcnt.
    ELSE.
      ls_inew-mtcnt = ps_proc1-labst.
    ENDIF.
  ENDIF.

  APPEND ls_inew TO ct_inew.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form add_gi_item_dispose
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_MITEM
*&      --> GS_HNEW
*&      <-- GT_INEW
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM add_gi_item_dispose  USING    pt_mitem LIKE gt_mitem
                                 VALUE(ps_hnew) LIKE gs_hnew
                        CHANGING ct_inew LIKE gt_inew
                                 VALUE(cv_subrc) TYPE sy-subrc.

  DATA: ls_mitem TYPE ts_mitem,
        ls_mhead TYPE zta3mm0017,
        ls_proc1 TYPE ts_proc1,
        lt_proc1 LIKE TABLE OF ls_proc1,
        ls_inew  LIKE gs_inew.

  DATA: lv_datum TYPE datum,
        lv_quant TYPE zsa3mm6015-mtcnt,
        lv_lines TYPE i.

  LOOP AT pt_mitem INTO ls_mitem.
    " 재고, 배치, 자재 정보 가져오기
    PERFORM get_dispose_info USING ls_mitem-matid ls_mitem-plaid
                             CHANGING lt_proc1 cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.

    DESCRIBE TABLE lt_proc1 LINES lv_lines.

    LOOP AT lt_proc1 INTO ls_proc1.
      " 이동 수량보다 재고가 많다면
      IF ls_proc1-scrap >= ls_mitem-mtcnt.
        " 출고 Item 등록하기
        PERFORM append_to_item_mo USING ls_mitem ls_proc1 'X' 'X'
                                  CHANGING ct_inew.
        EXIT.
        " 재고가 부족하다면
      ELSE.
        " 마지막 레코드일 때
        IF sy-tabix = lv_lines.
          " 등록했던 자재 지우기
          DELETE ct_inew WHERE matid = ls_proc1-matid.
          MESSAGE i009(zmcn11603) WITH ls_proc1-plaid1 ls_proc1-matid. " & 플랜트의 & 자재 재고가 부족합니다.
          " 마지막 레코드가 아닐 때
        ELSE.
          " 출고 Item 등록하기
          PERFORM append_to_item_mo USING ls_mitem ls_proc1 '' 'X'
                                    CHANGING ct_inew.
          " 등록한 재고만큼 이동수량에서 빼기
          ls_mitem-mtcnt = ls_mitem-mtcnt - ls_proc1-labst.
        ENDIF.
      ENDIF.

    ENDLOOP.

    CLEAR: ls_mitem.
  ENDLOOP.

  MESSAGE s013(zmcn11603). " 이동오더는 부분 출고가 불가능하여 모두 등록 됩니다.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_dispose_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_MITEM_MATID
*&      --> LS_MITEM_PLAID
*&      <-- LT_PROC1
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_dispose_info  USING    VALUE(p_matid) TYPE zta3mm0001-matid
                                VALUE(p_plaid) TYPE zta3mm0006-plaid
                       CHANGING ct_proc1 TYPE tt_proc1
                                VALUE(cv_subrc) TYPE sy-subrc.
  SELECT a~matid, plaid AS plaid1, stoid, a~batid, labst,
         scrap, hsdat, qualt, meins, maqua
    FROM zta3mm0002 AS a
   INNER JOIN zta3mm0003 AS b
      ON a~matid = b~matid
     AND a~batid = b~batid
   INNER JOIN zta3mm0001 AS c
      ON a~matid = c~matid
    INTO CORRESPONDING FIELDS OF TABLE @ct_proc1
   WHERE a~matid = @p_matid
     AND a~plaid = @p_plaid
     AND a~stoid = 'SL05'
     AND a~scrap <> 0
   ORDER BY hsdat.
  IF sy-subrc <> 0.
    cv_subrc = 4.
    MESSAGE i009(zmcn11603) WITH p_plaid p_matid INTO gv_messg. " & 플랜트의 & 자재 재고가 부족합니다.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_plaid_by_mo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_MITEM
*&      --> GT_INEW
*&      <-- GS_HNEW
*&---------------------------------------------------------------------*


FORM set_plaid_by_mo  USING    pt_mitem LIKE gt_mitem
                      CHANGING VALUE(cs_hnew) LIKE gs_hnew.

  CLEAR: cs_hnew-plaid, cs_hnew-pname.

  DATA: ls_mitem TYPE ts_mitem.

  IF pt_mitem IS INITIAL.
    RETURN.
  ENDIF.

  READ TABLE pt_mitem INDEX 1 INTO ls_mitem.
  cs_hnew-plaid = ls_mitem-plaid.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_insert_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_HNEW
*&      --> GT_INEW
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM check_insert_info  USING    VALUE(ps_hnew) TYPE zsa3mm6014
                                 pt_inew LIKE gt_inew
                                 pt_mitem LIKE gt_mitem
                        CHANGING VALUE(cv_subrc) TYPE sy-subrc.

  " 출고 Item이 비어있는지 체크
  IF pt_inew IS INITIAL.
    cv_subrc = 4.
    MESSAGE i026(zmcn11603) INTO gv_messg. " 출고 Item이 비어있어 등록할 수 없습니다.
    RETURN.
  ENDIF.

  " 오더 번호 체크
  PERFORM check_odrid USING ps_hnew pt_inew pt_mitem
                      CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  " 오더별 상태 확인
  PERFORM check_state USING ps_hnew-odrid
                      CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form ask_again
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> TEXT_Q01
*&      <-- GV_ANSWER
*&---------------------------------------------------------------------*


FORM ask_again  USING    VALUE(p_text) TYPE string
                CHANGING VALUE(cv_answer).
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = '정보 반영 재확인'


*     DIAGNOSE_OBJECT       = ' '


      text_question         = p_text


*     TEXT_BUTTON_1         = 'Ja'(001)


      icon_button_1         = 'ICON_OKAY'


*     TEXT_BUTTON_2         = 'Nein'(002)


      icon_button_2         = 'ICON_CANCEL'


*     DEFAULT_BUTTON        = '1'


      display_cancel_button = ''


*     USERDEFINED_F1_HELP   = ' '
*     START_COLUMN          = 25
*     START_ROW             = 6
*     POPUP_TYPE            =
*     IV_QUICKINFO_BUTTON_1 = ' '
*     IV_QUICKINFO_BUTTON_2 = ' '


    IMPORTING
      answer                = cv_answer


*   TABLES
*     PARAMETER             =


    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.
  IF sy-subrc <> 0.


* Implement suitable error handling here


  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form insert_entity
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_NEW
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM insert_entity  CHANGING VALUE(cs_hnew) TYPE zsa3mm6014
                             ct_inew LIKE gt_inew
                             VALUE(cv_subrc) TYPE sy-subrc.
  DATA: lv_num(10) TYPE n.

  " Text Edit에 입력된 값 적요로 옮기기
  PERFORM set_bktxt_header USING go_ihedit
                           CHANGING cs_hnew.

  " 출고 번호 NR에서 가져오기
  PERFORM get_number_range USING 'ZNRA3MM62' '01'
                           CHANGING lv_num cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  " 출고 번호 설정하기
  PERFORM set_iotid USING lv_num
                    CHANGING cs_hnew ct_inew.

  " 출고 Header 등록하기
  PERFORM insert_header USING cs_hnew
                        CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  " 출고 Item 등록하기
  PERFORM insert_item_list USING gt_inew
                           CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  CASE cs_hnew-prtyp.
    WHEN 'PR'.
      " 생산오더 상태 변경해주기
      PERFORM update_po_state USING gt_inew gt_pitem cs_hnew
                              CHANGING cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.
    WHEN 'SO'.
      " 판매오더 상태 변경해주기
      PERFORM update_so_state USING gt_inew gt_sitem cs_hnew
                              CHANGING cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.
    WHEN 'MO'.
      " 이동오더 상태 변경해주기
      PERFORM update_mo_state USING gt_inew cs_hnew
                              CHANGING cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.
  ENDCASE.

  " 재고 수량 변경
  PERFORM update_quantity USING gt_inew gs_hnew
                          CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  MESSAGE i014(zmcn11603) INTO gv_messg. " 등록에 성공 했습니다.
  gv_messt = 'S'.

  COMMIT WORK.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_iotid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_NUM
*&      <-- CS_HNEW
*&      <-- CT_INEW
*&---------------------------------------------------------------------*


FORM set_iotid  USING    VALUE(p_num)
                CHANGING VALUE(cs_hnew) TYPE zsa3mm6014
                         ct_inew LIKE gt_inew.
  DATA: lv_year(4) TYPE n,
        ls_inew    TYPE zsa3mm6015.
  lv_year = sy-datum+0(4).

  cs_hnew-iotid = 'R' && lv_year && p_num.

  LOOP AT ct_inew INTO ls_inew.
    ls_inew-iotid = cs_hnew-iotid.

    MODIFY ct_inew FROM ls_inew.
    CLEAR ls_inew.
  ENDLOOP.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_number_range
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      <-- LV_NUM
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_number_range  USING    VALUE(p_object) TYPE nrobj
                                VALUE(p_range) TYPE nrnr
                       CHANGING VALUE(cv_num)
                                VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_year TYPE nryear.
  lv_year = sy-datum+0(4).

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = p_range
      object                  = p_object


*     QUANTITY                = '1'
*     SUBOBJECT               = ' '


      toyear                  = lv_year


*     IGNORE_BUFFER           = ' '


    IMPORTING
      number                  = cv_num


*     QUANTITY                =
*     RETURNCODE              =


    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_intern = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
    ROLLBACK WORK.
    cv_subrc = sy-subrc.
    MESSAGE i004(zmcn11602) INTO gv_messg. " 채번에 실패 했습니다.
    RETURN.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form insert_header
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> CS_HNEW
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM insert_header  USING    VALUE(ps_hnew) TYPE zsa3mm6014
                    CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA ls_zta3mm0010 TYPE zta3mm0010.

  ls_zta3mm0010-iotid = ps_hnew-iotid.
  ls_zta3mm0010-plaid = ps_hnew-plaid.
  ls_zta3mm0010-prtyp = ps_hnew-prtyp.
  ls_zta3mm0010-otype = ps_hnew-otype.
  IF ps_hnew-prtyp = 'MO'.
    ls_zta3mm0010-movid = ps_hnew-odrid.
  ENDIF.
  ls_zta3mm0010-erdat = sy-datum.
  ls_zta3mm0010-erzet = sy-uzeit.
  ls_zta3mm0010-aedat = sy-datum.
  ls_zta3mm0010-aezet = sy-uzeit.
  ls_zta3mm0010-bktxt = ps_hnew-bktxt.

  " uname으로 직원ID 가져오기
  PERFORM get_mapping_id USING sy-uname
                         CHANGING ls_zta3mm0010-ereid.
  PERFORM get_mapping_id USING sy-uname
                         CHANGING ls_zta3mm0010-aeeid.

  INSERT zta3mm0010 FROM ls_zta3mm0010.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    ROLLBACK WORK.
    MESSAGE i015(zmcn11603) INTO gv_messg. " 등록에 실패 했습니다.
    RETURN.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form insert_item
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_INEW
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM insert_item_list  USING    pt_inew LIKE gt_inew
                  CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA: ls_inew TYPE zsa3mm6015.

  LOOP AT pt_inew INTO ls_inew.
    PERFORM insert_item USING ls_inew
                        CHANGING cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form insert_item
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_INEW
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM insert_item  USING    VALUE(ps_inew) TYPE zsa3mm6015
                  CHANGING cv_subrc TYPE sy-subrc.
  DATA: ls_zta3mm0011 TYPE zta3mm0011.

  ls_zta3mm0011-iotid = ps_inew-iotid.
  ls_zta3mm0011-scode = ps_inew-scode.
  ls_zta3mm0011-matid = ps_inew-matid.
  ls_zta3mm0011-stoid = ps_inew-stoid.
  ls_zta3mm0011-podid = ps_inew-podid.
  ls_zta3mm0011-sodid = ps_inew-sodid.
  ls_zta3mm0011-batid = ps_inew-batid.
  ls_zta3mm0011-mtcnt = ps_inew-mtcnt.
  ls_zta3mm0011-meins = ps_inew-meins.
  ls_zta3mm0011-sfcod = ps_inew-sfcod.
  ls_zta3mm0011-erdat = sy-datum.
  ls_zta3mm0011-erzet = sy-uzeit.
  ls_zta3mm0011-aedat = sy-datum.
  ls_zta3mm0011-aezet = sy-uzeit.
  ls_zta3mm0011-bktxt = ps_inew-bktxt.

  PERFORM get_mapping_id USING sy-uname
                         CHANGING ls_zta3mm0011-ereid.
  PERFORM get_mapping_id USING sy-uname
                         CHANGING ls_zta3mm0011-aeeid.

  INSERT zta3mm0011 FROM ls_zta3mm0011.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    ROLLBACK WORK.
    MESSAGE i015(zmcn11603) INTO gv_messg. " 등록에 실패 했습니다.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_mapping_id
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SY_UNAME
*&      <-- LV_AEEID
*&---------------------------------------------------------------------*


FORM get_mapping_id  USING    VALUE(p_uname) TYPE sy-uname
                     CHANGING VALUE(cv_ereid) TYPE zsa3hr0001-ereid.
  SELECT SINGLE empid
    FROM zta3hr0002
    INTO cv_ereid
   WHERE mpgid = p_uname.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_po_state
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM update_po_state  USING    pt_inew LIKE gt_inew
                               pt_pitem LIKE gt_pitem
                               VALUE(ps_hnew) TYPE zsa3mm6014
                      CHANGING VALUE(cv_subrc) TYPE sy-subrc.

  DATA: ls_inew     TYPE zsa3mm6015,
        lv_pifla(1).

  LOOP AT pt_inew INTO ls_inew.
    PERFORM update_po_item USING ls_inew
                           CHANGING cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.
  ENDLOOP.

  PERFORM check_po_state USING ps_hnew
                         CHANGING lv_pifla cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  IF lv_pifla = 'X'.
    CLEAR lv_pifla.
    PERFORM update_po_header USING ps_hnew
                             CHANGING cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_po_item
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PT_INEW
*&      --> CV_SUBRC
*&---------------------------------------------------------------------*


FORM update_po_item  USING    VALUE(ps_inew) TYPE zsa3mm6015
                     CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_aeeid TYPE zta3hr0001-aeeid.

  PERFORM get_mapping_id USING sy-uname
                         CHANGING lv_aeeid.

  UPDATE zta3pp0006 SET gifla = 'X'
                        aedat = sy-datum
                        aezet = sy-uzeit
                        aeeid = lv_aeeid
                    WHERE podid = ps_inew-podid
                      AND scode = ps_inew-sfcod.
  IF sy-subrc <> 0.
    ROLLBACK WORK.
    cv_subrc = sy-subrc.
    MESSAGE i015(zmcn11603) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_po_state
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PT_PITEM
*&      --> LS_INEW
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM check_po_state  USING    VALUE(ps_hnew) TYPE zsa3mm6014
                     CHANGING VALUE(cv_pifla)
                              VALUE(cv_subrc) TYPE sy-subrc.
  DATA: lt_pitem LIKE gt_pitem,
        ls_pitem TYPE ts_pitem.

  PERFORM get_gifla_po USING ps_hnew-odrid
                       CHANGING lt_pitem cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  LOOP AT lt_pitem INTO ls_pitem.
    IF ls_pitem-gifla = ''.
      RETURN.
    ENDIF.

    CLEAR ls_pitem.
  ENDLOOP.

  cv_pifla = 'X'.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_po_header
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_HNEW
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM update_po_header  USING    VALUE(ps_hnew) TYPE zsa3mm6014
                       CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_aeeid TYPE zsa3hr0001-aeeid.

  PERFORM get_mapping_id USING sy-uname
                         CHANGING lv_aeeid.

  UPDATE zta3PP0005 SET cstat = 'C04'
                        aedat = sy-datum
                        aezet = sy-uzeit
                        aeeid = lv_aeeid
                    WHERE podid = ps_hnew-odrid.
  IF sy-subrc <> 0.
    ROLLBACK WORK.
    cv_subrc = sy-subrc.
    MESSAGE i015(zmcn11603) INTO gv_messg.
    RETURN.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_so_state
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_INEW
*&      --> GT_SITEM
*&      --> CS_HNEW
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM update_so_state  USING    pt_inew LIKE gt_inew
                               pt_sitem LIKE gt_sitem
                               VALUE(ps_hnew) TYPE zsa3mm6014
                      CHANGING VALUE(cv_subrc) TYPE sy-subrc.

  DATA: ls_inew     TYPE zsa3mm6015,
        lv_sifla(1).

  LOOP AT pt_inew INTO ls_inew.
    PERFORM update_so_item USING ls_inew
                           CHANGING cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.
  ENDLOOP.

  PERFORM check_so_state USING ps_hnew
                           CHANGING lv_sifla cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  IF lv_sifla = 'X'.
    CLEAR lv_sifla.
    PERFORM update_so_header USING ps_hnew
                             CHANGING cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_so_item
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_INEW
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM update_so_item  USING    VALUE(ps_inew) TYPE zsa3mm6015
                     CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_aeeid TYPE zta3hr0001-aeeid.

  PERFORM get_mapping_id USING sy-uname
                         CHANGING lv_aeeid.

  UPDATE zta3sd0002 SET gifla = 'X'
                        aedat = sy-datum
                        aezet = sy-uzeit
                        aeeid = lv_aeeid
                    WHERE sodid = ps_inew-sodid
                      AND scode = ps_inew-sfcod.
  IF sy-subrc <> 0.
    ROLLBACK WORK.
    cv_subrc = sy-subrc.
    MESSAGE i015(zmcn11603) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_so_state
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PT_SITEM
*&      --> LS_INEW
*&      <-- CV_SUBRC
*&      <-- LV_PIFLA
*&---------------------------------------------------------------------*


FORM check_so_state  USING    VALUE(ps_hnew) TYPE zsa3mm6014
                     CHANGING VALUE(cv_sifla)
                              VALUE(cv_subrc) TYPE sy-subrc.
  DATA: lt_sitem LIKE gt_sitem,
        ls_sitem TYPE ts_sitem.

  PERFORM get_gifla_so USING ps_hnew-odrid
                       CHANGING lt_sitem cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  LOOP AT lt_sitem INTO ls_sitem.
    IF ls_sitem-gifla = ''.
      RETURN.
    ENDIF.

    CLEAR ls_sitem.
  ENDLOOP.

  cv_sifla = 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_so_header
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_HNEW
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM update_so_header  USING    VALUE(ps_hnew) TYPE zsa3mm6014
                       CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_aeeid TYPE zsa3hr0001-aeeid.

  PERFORM get_mapping_id USING sy-uname
                         CHANGING lv_aeeid.

  UPDATE zta3sd0001 SET sstat = 'S3'
                        aedat = sy-datum
                        aezet = sy-uzeit
                        aeeid = lv_aeeid
                    WHERE sodid = ps_hnew-odrid.
  IF sy-subrc <> 0.
    ROLLBACK WORK.
    cv_subrc = sy-subrc.
    MESSAGE i015(zmcn11603) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_mo_state
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_INEW
*&      --> GT_MITEM
*&      --> CS_HNEW
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM update_mo_state  USING    pt_inew LIKE gt_inew
                               VALUE(ps_hnew) TYPE zsa3mm6014
                      CHANGING VALUE(cv_subrc) TYPE sy-subrc.

  PERFORM update_mo_header USING ps_hnew
                           CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_mo_header
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_HNEW
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM update_mo_header  USING    VALUE(ps_hnew) TYPE zsa3mm6014
                       CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_aeeid TYPE zsa3hr0001-aeeid.

  PERFORM get_mapping_id USING sy-uname
                         CHANGING lv_aeeid.

  UPDATE zta3mm0017 SET mstat = 'M2'
                        aedat = sy-datum
                        aezet = sy-uzeit
                        aeeid = lv_aeeid
                    WHERE movid = ps_hnew-odrid.
  IF sy-subrc <> 0.
    ROLLBACK WORK.
    cv_subrc = sy-subrc.
    MESSAGE i015(zmcn11603) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_next
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM set_next .
  DATA: ls_atbar LIKE gs_atbar.

  CLEAR: gv_dynnr, gv_sflag, gt_atbar.
  gv_dynnr = '0202'.
  gv_sflag = 'X'.

  CLEAR ls_atbar.
  ls_atbar = 'INSERT'.
  APPEND ls_atbar TO gt_atbar.

  CLEAR ls_atbar.
  ls_atbar = 'RESET'.
  APPEND ls_atbar TO gt_atbar.

  PERFORM get_gi_info CHANGING gs_hnew.

  PERFORM get_pname USING gs_hnew-plaid
                    CHANGING gs_hnew-pname gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_gi_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- HS_HNEW
*&---------------------------------------------------------------------*


FORM get_gi_info  CHANGING VALUE(cs_hnew) TYPE zsa3mm6014.
  DATA: lv_odrid TYPE zsa3mm6014-odrid,
        lv_iotid TYPE zsa3mm6014-iotid.

  lv_odrid = cs_hnew-odrid.
  lv_iotid = cs_hnew-iotid.

  CLEAR cs_hnew.

  SELECT SINGLE iotid plaid prtyp erdat ereid erzet
                otype aedat aezet aeeid bktxt
    FROM zta3mm0010
    INTO CORRESPONDING FIELDS OF cs_hnew
   WHERE iotid = lv_iotid.

  cs_hnew-odrid = lv_odrid.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_gifla
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_HNEW_ODRID
*&      <-- LT_PITEM
*&---------------------------------------------------------------------*


FORM get_gifla_po  USING    VALUE(p_odrid) TYPE zsa3mm6014-odrid
                   CHANGING ct_pitem LIKE gt_pitem
                            VALUE(cv_subrc) TYPE sy-subrc.
  SELECT podid scode gifla
    FROM zta3pp0006
    INTO CORRESPONDING FIELDS OF TABLE ct_pitem
   WHERE podid = p_odrid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i006(zmcn11603) WITH p_odrid INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_gifla_so
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_HNEW_ODRID
*&      <-- LT_SITEM
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_gifla_so  USING    VALUE(p_odrid) TYPE zsa3mm6014-odrid
                   CHANGING ct_sitem LIKE gt_sitem
                            VALUE(cv_subrc) TYPE sy-subrc.
  SELECT sodid scode gifla
    FROM zta3sd0002
    INTO CORRESPONDING FIELDS OF TABLE ct_sitem
   WHERE sodid = p_odrid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i006(zmcn11603) WITH p_odrid INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN_0201 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE modify_screen_0201 OUTPUT.
  PERFORM modify_screen_0201.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Form modify_screen_0201
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM modify_screen_0201 .
  LOOP AT SCREEN.

    IF screen-name = 'ZSA3MM6014-CHECP'.
      IF gs_hnew-prtyp = 'MO'.
        screen-active = '1'.
      ELSE.
        screen-active = '0'.
      ENDIF.
    ENDIF.

    IF screen-name = 'ZSA3MM6014-ODRID'.
      IF gt_inew IS NOT INITIAL.
        screen-input = '0'.
      ELSE.
        screen-input = '1'.
      ENDIF.

      IF gt_pitem IS NOT INITIAL OR gt_sitem IS NOT INITIAL OR gt_mitem IS NOT INITIAL.
        screen-input = '0'.
      ELSE.
        screen-input = '1'.
      ENDIF.
    ENDIF.

    MODIFY SCREEN.
    CLEAR screen.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form checp_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM checp_0200 .
  CLEAR: gt_mitem, gt_inew, gs_hnew-odrid.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form add_gi_item_by_pr_start
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_PITEM
*&      --> GS_HNEW
*&      <-- GT_INEW
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM add_gi_item_pr_start  USING    pt_pitem LIKE gt_pitem
                           CHANGING VALUE(cs_hnew) LIKE gs_hnew
                                    ct_inew LIKE gt_inew
                                    VALUE(cv_subrc) TYPE sy-subrc.

  DATA: ls_pitem  TYPE ts_pitem,
        ls_phead  TYPE zta3pp0005,
        ls_proc1  TYPE ts_proc1,
        lt_proc1  LIKE TABLE OF ls_proc1,
        ls_inew   LIKE gs_inew,
        lv_matgr  TYPE zta3mm0001-matgr,
        lt_inven  TYPE TABLE OF zta3mm0002,
        ls_inven  TYPE zta3mm0002,
        lt_inven2 TYPE TABLE OF zta3mm0002.

  DATA: lv_datum TYPE datum,
        lv_quant TYPE zsa3mm6015-mtcnt,
        lv_lines TYPE i,
        lv_tabix TYPE sy-tabix.

  " 생산오더 header 정보 가져오기
  PERFORM set_plaid_by_pr_start CHANGING cs_hnew cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  SELECT SINGLE prdnr
    FROM zta3pp0005
    INTO ls_phead-prdnr
   WHERE podid = cs_hnew-odrid.

  LOOP AT pt_pitem INTO ls_pitem.

    READ TABLE lt_inven INTO ls_inven WITH KEY matid = ls_pitem-rawnr plaid = cs_hnew-plaid.
    IF sy-subrc <> 0.
      " 재고 정보 가져오기
      PERFORM get_inven_info USING ls_pitem-rawnr cs_hnew-plaid
                             CHANGING lt_inven2 cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.

      APPEND LINES OF lt_inven2 TO lt_inven.
    ENDIF.
  ENDLOOP.

  LOOP AT pt_pitem INTO ls_pitem.
    " 재고, 배치, 자재 정보 가져오기
    PERFORM get_inventory_info USING ls_pitem-rawnr cs_hnew-plaid
                               CHANGING lt_proc1 cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.

    PERFORM get_matgr USING ls_phead-prdnr
                      CHANGING lv_matgr cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.

    " 완제품이 생지류 일 때
    IF lv_matgr = 'KNE'.
      " 원자재 자재그룹 가져오기
      PERFORM get_matgr USING ls_pitem-rawnr
                        CHANGING lv_matgr cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.

      " 자재그룹이 과일일 때
      IF lv_matgr = 'FRU'.
        " 품질 상태가 100이 아닌것 삭제하기
        DELETE lt_proc1 WHERE qualt <> '100'
                          AND matid = ls_pitem-rawnr.
      ENDIF.
    ENDIF.

    IF lt_proc1 IS INITIAL.
      cv_subrc = 4.
      MESSAGE i009(zmcn11603) WITH cs_hnew-plaid ls_pitem-rawnr INTO gv_messg. " & 플랜트의 & 자재 재고가 부족합니다.
      RETURN.
    ENDIF.

    DESCRIBE TABLE lt_proc1 LINES lv_lines.

    LOOP AT lt_proc1 INTO ls_proc1.
      " 도착 플랜트 가져오기
      PERFORM get_depart_plant USING cs_hnew-odrid
                               CHANGING ls_proc1-plaid2 cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.

      " 자재 그룹 가져오기
      PERFORM get_matgr USING ls_phead-prdnr
                        CHANGING lv_matgr cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.

      "자재그룹이 과일일 때
      IF lv_matgr = 'FRU'.
        " 사용 마감일 계산
        lv_datum = ls_proc1-hsdat + ( 2 * ls_proc1-maqua ).
      ELSE.
        lv_datum = ls_proc1-hsdat + ls_proc1-maqua.
      ENDIF.

      READ TABLE lt_inven INTO ls_inven WITH KEY matid = ls_proc1-matid
                                                 batid = ls_proc1-batid
                                                 plaid = cs_hnew-plaid
                                                 stoid = ls_proc1-stoid.
      IF ls_inven-labst <> 0.

        CLEAR lv_tabix.
        lv_tabix = sy-tabix.

        " 사용 마감일 이전일 때
        IF sy-datum =< lv_datum.
          " 필요 수량보다 재고가 많을 때
          IF ls_inven-labst >= ls_pitem-pquan.
            " 출고 Item 추가
            PERFORM append_to_item_pr USING ls_pitem ls_proc1 ls_inven 'X'
                                      CHANGING ct_inew.
            ls_inven-labst -= ls_pitem-pquan.
            MODIFY lt_inven FROM ls_inven INDEX lv_tabix TRANSPORTING labst.
            EXIT.
            " 필요 수량보다 재고가 적을 때
          ELSE.
            " 마지막 레코드일 때
            IF sy-tabix = lv_lines.

              cv_subrc = 4.
              MESSAGE i009(zmcn11603) WITH ls_proc1-plaid1 ls_proc1-matid INTO gv_messg. " & 플랜트의 & 자재 재고가 부족합니다.
              RETURN.

            ELSE.
              " 출고 Item 추가
              PERFORM append_to_item_pr USING ls_pitem ls_proc1 ls_inven ''
                                        CHANGING ct_inew.
              " 필요 수량에서 등록한 재고만큼 빼기
              ls_pitem-pquan = ls_pitem-pquan - ls_inven-labst.
              ls_inven-labst = 0.
              MODIFY lt_inven FROM ls_inven INDEX lv_tabix TRANSPORTING labst.
            ENDIF.
          ENDIF.
        ELSE.
          cv_subrc = 4.
          MESSAGE i009(zmcn11603) WITH ls_proc1-plaid1 ls_proc1-matid INTO gv_messg. " & 플랜트의 & 자재 재고가 부족합니다.
          RETURN.
        ENDIF.
      ENDIF.

      CLEAR: ls_proc1.

    ENDLOOP.

    CLEAR: ls_pitem.
  ENDLOOP.

  " 시퀀스 번호 재설정 하기
  PERFORM set_inew_index CHANGING ct_inew.

  MESSAGE s016(zmcn11603). " 생산시작 출고는 부분 출고가 불가능하여 모두 등록됩니다.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form add_gi_item_mo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM add_gi_item_mo USING    pt_mitem LIKE gt_mitem
                    CHANGING VALUE(cs_hnew) LIKE gs_hnew
                             ct_inew LIKE gt_inew
                             VALUE(cv_subrc) LIKE sy-subrc.

  " 폐기재고 이동인지 확인
  IF cs_hnew-checp = 'X'.
    " 폐기 재고 이동일 때 출고 Item 추가
    PERFORM add_gi_item_dispose USING pt_mitem cs_hnew
                                CHANGING ct_inew cv_subrc.
    IF cv_subrc <> 0.
      CLEAR ct_inew.
      RETURN.
    ENDIF.
  ELSE.
    " 가용 재고 이동일 때 츨고 Item 추가
    PERFORM add_gi_item_by_mo USING pt_mitem cs_hnew
                              CHANGING ct_inew cv_subrc.
    IF cv_subrc <> 0.
      CLEAR ct_inew.
      RETURN.
    ENDIF.
  ENDIF.

  " 출고 Item의 플랜트ID 출고 Header에 넣어주기
  PERFORM set_plaid_by_mo USING pt_mitem
                          CHANGING cs_hnew.

  " 시퀀스 번호 재설정 해주기
  PERFORM set_inew_index CHANGING ct_inew.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_plaid_by_pr_start
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_PROC1
*&      <-- CS_HNEW
*&---------------------------------------------------------------------*


FORM set_plaid_by_pr_start  CHANGING VALUE(cs_hnew) TYPE zsa3mm6014
                                     VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE plaid
    FROM zta3pp0005
    INTO cs_hnew-plaid
   WHERE podid = cs_hnew-odrid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i006(zmcn11603) WITH cs_hnew-odrid INTO gv_messg. " & 없는 오더번호 입니다.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_layo_0210
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_LAYO
*&---------------------------------------------------------------------*


FORM set_layo_0210  CHANGING VALUE(cs_layo) TYPE lvc_s_layo.
  CLEAR cs_layo.

  cs_layo-cwidth_opt = 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_quantity
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_INEW
*&      --> GS_HNEW
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM update_quantity  USING    pt_inew LIKE gt_inew
                               VALUE(ps_hnew) TYPE zsa3mm6014
                      CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA: ls_inew      TYPE zsa3mm6015,
        ls_bdc       TYPE bdcdata,
        lt_bdc       LIKE TABLE OF ls_bdc,
        ls_quant     TYPE zta3mm0002,
        lv_labst(16),
        lv_scrap(16).

  LOOP AT pt_inew INTO ls_inew.
    CLEAR: ls_bdc, lt_bdc.

    PERFORM get_storage_info USING ls_inew-matid ls_inew-stoid
                                   ls_inew-batid ps_hnew-plaid
                             CHANGING ls_quant cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.

    ls_bdc-program = 'SAPMZA3MM6001'.
    ls_bdc-dynpro = '0300'.
    ls_bdc-dynbegin = 'X'.
    APPEND ls_bdc TO lt_bdc.

    CLEAR ls_bdc.
    ls_bdc-fnam = 'ZSA3MM6006-MATID'.
    ls_bdc-fval = ls_inew-matid.
    APPEND ls_bdc TO lt_bdc.

    CLEAR ls_bdc.
    ls_bdc-fnam = 'ZSA3MM6006-PLAID'.
    ls_bdc-fval = ps_hnew-plaid.
    APPEND ls_bdc TO lt_bdc.

    CLEAR ls_bdc.
    ls_bdc-fnam = 'ZSA3MM6006-STOID'.
    ls_bdc-fval = ls_inew-stoid.
    APPEND ls_bdc TO lt_bdc.

    CLEAR ls_bdc.
    ls_bdc-fnam = 'ZSA3MM6006-BATID'.
    ls_bdc-fval = ls_inew-batid.
    APPEND ls_bdc TO lt_bdc.

    IF ls_inew-stoid = 'SL05'.
      ls_quant-scrap -= ls_inew-mtcnt.
    ELSE.
      ls_quant-labst -= ls_inew-mtcnt.
    ENDIF.

    WRITE ls_quant-labst UNIT ls_inew-meins TO lv_labst.
    WRITE ls_quant-scrap UNIT ls_inew-meins TO lv_scrap.
    CONDENSE: lv_labst,
              lv_scrap.

    CLEAR ls_bdc.
    ls_bdc-fnam = 'ZSA3MM6006-LABST'.
    ls_bdc-fval = lv_labst.
    APPEND ls_bdc TO lt_bdc.

    CLEAR ls_bdc.
    ls_bdc-fnam = 'ZSA3MM6006-SCRAP'.
    ls_bdc-fval = lv_scrap.
    APPEND ls_bdc TO lt_bdc.

    CLEAR ls_bdc.
    ls_bdc-fnam = 'ZSA3MM6006-BKTXT'.
    ls_bdc-fval = ls_quant-bktxt.
    APPEND ls_bdc TO lt_bdc.

    CLEAR ls_bdc.
    ls_bdc-fnam = 'BDC_OKCODE'.
    ls_bdc-fval = 'USAVE'.
    APPEND ls_bdc TO lt_bdc.

    CLEAR ls_bdc.
    ls_bdc-program = 'SAPLSPO1'.
    ls_bdc-dynpro = '0500'.
    ls_bdc-dynbegin = 'X'.
    APPEND ls_bdc TO lt_bdc.

    CLEAR ls_bdc.
    ls_bdc-fnam = 'BDC_OKCODE'.
    ls_bdc-fval = 'OPT1'.
    APPEND ls_bdc TO lt_bdc.

    CALL TRANSACTION 'ZA3MM6001_300'
    USING lt_bdc MODE 'E'.


*    IF sy-subrc <> 0.
*      ROLLBACK WORK.
*      cv_subrc = sy-subrc.
*      RETURN.
*    ENDIF.



    CLEAR: ls_inew, ls_quant.
  ENDLOOP.


ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_storage_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_INEW_MATID
*&      --> LS_INEW_STOID
*&      --> LS_INEW_BATID
*&      --> PS_HNEW_PLAID
*&---------------------------------------------------------------------*


FORM get_storage_info  USING    VALUE(p_matid) TYPE zta3mm0002-matid
                                VALUE(p_stoid) TYPE zta3mm0002-stoid
                                VALUE(p_batid) TYPE zta3mm0002-batid
                                VALUE(p_plaid) TYPE zta3mm0002-plaid
                       CHANGING VALUE(cs_quant) TYPE zta3mm0002
                                VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE matid stoid batid plaid labst scrap bktxt
    FROM zta3mm0002
    INTO CORRESPONDING FIELDS OF cs_quant
   WHERE matid = p_matid
     AND batid = p_batid
     AND plaid = p_plaid
     AND stoid = p_stoid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i000(zmcn11603) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_state
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> CS_HNEW_ODRID
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM check_state  USING    VALUE(p_odrid) TYPE zsa3mm6014-odrid
                  CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  CASE gs_hnew-prtyp.
    WHEN 'PR'.
      " 생산오더 상태 확인
      PERFORM check_state_pr USING p_odrid
                             CHANGING cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.
    WHEN 'SO'.
      " 판매오더 상태 확인
      PERFORM check_state_so USING p_odrid
                             CHANGING cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.
    WHEN 'MO'.
      " 이동오더 상태 확인
      PERFORM check_state_mo USING p_odrid
                             CHANGING cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.
  ENDCASE.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_state_pr
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_ODRID
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM check_state_pr  USING    VALUE(p_odrid) TYPE zsa3mm6014-odrid
                     CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA: lv_cstat    TYPE zta3pp0005-cstat,
        lv_mstat    TYPE zta3mm0017-mstat,
        lv_movid    TYPE zta3mm0017-movid,
        lv_plaid    TYPE zta3pp0005-plaid,
        lv_mflag(1),
        ls_pitem    TYPE zta3pp0006,
        lt_pitem    LIKE TABLE OF zta3pp0006.

  SELECT SINGLE cstat
    FROM zta3pp0005
    INTO lv_cstat
   WHERE podid = p_odrid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i017(zmcn11603) WITH p_odrid INTO gv_messg. " & 없는 생산 오더 번호 입니다.
    RETURN.
  ENDIF.

  IF lv_cstat <> 'C03'.
    cv_subrc = 4.
    MESSAGE i019(zmcn11603) INTO gv_messg.  " 생산오더 출고는 승인 상태인 오더만 등록 가능합니다.
    RETURN.
  ENDIF.

  SELECT podid scode plaid
    FROM zta3pp0006
    INTO CORRESPONDING FIELDS OF TABLE lt_pitem
   WHERE podid = p_odrid.

  LOOP AT lt_pitem INTO ls_pitem.

    SELECT SINGLE plaid
     FROM zta3pp0005
     INTO lv_plaid
    WHERE podid = ls_pitem-podid.

    IF ls_pitem-plaid <> lv_plaid.
      SELECT SINGLE h~movid mstat
        FROM zta3mm0017 AS h
       INNER JOIN zta3mm0018 AS i
          ON h~movid = i~movid
        INTO ( lv_movid, lv_mstat )
       WHERE i~docnm = ls_pitem-podid
         AND i~sfcod = ls_pitem-scode
         AND h~mstat <> 'M9'.
      IF sy-subrc <> 0.
        cv_subrc = 4.
        MESSAGE i041(zmcn11603) INTO gv_messg.
        RETURN.
      ELSE.
        IF lv_mstat <> 'M3'.
          cv_subrc = 4.
          MESSAGE i041(zmcn11603) INTO gv_messg.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_state_so
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_ODRID
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM check_state_so  USING    VALUE(p_odrid) TYPE zsa3mm6014-odrid
                     CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_sstat TYPE zta3sd0001-sstat.

  SELECT SINGLE sstat
    FROM zta3sd0001
    INTO lv_sstat
   WHERE sodid = p_odrid.
  IF sy-subrc <> 0.
    cv_subrc = 4.
    MESSAGE i020(zmcn11603) WITH p_odrid INTO gv_messg. " & 없는 판매 오더 번호입니다.
    RETURN.
  ENDIF.

  IF lv_sstat <> 'S2'.
    cv_subrc = 4.
    MESSAGE i021(zmcn11603) INTO gv_messg. " 판매상태가 결재승인인 판매오더만 등록 가능합니다.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_state_mo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_ODRID
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM check_state_mo  USING    VALUE(p_odrid) TYPE zsa3mm6014-odrid
                     CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA: lv_mstat TYPE zta3mm0017-mstat,
        lv_vtype TYPE zta3mm0017-vtype.

  SELECT SINGLE mstat
    FROM zta3mm0017
    INTO lv_mstat
   WHERE movid = p_odrid.
  IF sy-subrc <> 0.
    cv_subrc = 4.
    MESSAGE i022(zmcn11603) WITH p_odrid INTO gv_messg. " & 없는 이동 오더 번호 입니다.
    RETURN.
  ENDIF.

  SELECT SINGLE vtype
    FROM zta3mm0017
    INTO lv_vtype
   WHERE movid = p_odrid.

  IF lv_mstat <> 'M1'.
    cv_subrc = 4.
    MESSAGE i023(zmcn11603) INTO gv_messg. " 이동상태가 등록완료인 이동오더만 등록 가능합니다.
    RETURN.
  ENDIF.

  IF gs_hnew-checp = 'X' AND lv_vtype <> 'D'.
    cv_subrc = 4.
    MESSAGE i039(zmcn11603) INTO gv_messg. " 폐기 재고 이동 출고시에는 D타입인 이동오더만 출고 가능합니다.
    RETURN.
  ENDIF.

  IF gs_hnew-checp = '' AND lv_vtype <> 'P'.
    cv_subrc = 4.
    MESSAGE i040(zmcn11603) INTO gv_messg. " 폐기 재고 이동 출고가 아니라면 P타입 이동 오더만 출고 가능합니다.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_layo_0300
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_LAYO
*&---------------------------------------------------------------------*


FORM set_layo_0300  CHANGING VALUE(cs_layo) TYPE lvc_s_layo.
  CLEAR cs_layo.

  cs_layo-cwidth_opt = 'X'.
  cs_layo-zebra = 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_fcat_0300
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_FCAT
*&---------------------------------------------------------------------*


FORM set_fcat_0300  TABLES   t_fcat STRUCTURE lvc_s_fcat.
  CLEAR t_fcat[].

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'BKTXT' '',
                    TABLES t_fcat
                    USING 'NO_OUT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'MATID' '',
                    TABLES t_fcat
                    USING 'HOTSPOT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'ICOND' '',
                    TABLES t_fcat
                    USING 'COLTEXT' '적요'(t02) '',
                    TABLES t_fcat
                    USING 'HOTSPOT' 'X' '',
                    TABLES t_fcat
                    USING 'ICON' 'X' 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_sort_0300
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_SORT
*&---------------------------------------------------------------------*


FORM set_sort_0300  TABLES   t_sort STRUCTURE lvc_s_sort.
  CLEAR t_sort[].

  PERFORM set_sort: TABLES t_sort
                    USING 'FIELDNAME' 'SCODE' '',
                    TABLES t_sort
                    USING 'UP' 'X' 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM check_0100 .

ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM update_0100 .
  DATA: ls_list LIKE gs_list.

  " 선택한 행 값 가져오기
  PERFORM get_selected_info USING gt_list go_alv
                            CHANGING ls_list gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  " 선택한 행 값으로 Header, Item 정보 가져오기
  PERFORM get_detail_info USING ls_list
                          CHANGING gs_hupt gt_iupt gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  " 플랜트명 가져오기
  PERFORM get_pname USING gs_hupt-plaid
                    CHANGING gs_hupt-pname gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  " 적요용 Icon 넣기
  PERFORM set_icon_item CHANGING gt_iupt.

  " 출고 수정 Screen 호출
  CALL SCREEN 300.
  CLEAR: gs_hupt, gt_iupt.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_selected_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_LIST
*&      --> GO_UALV
*&      <-- LS_LIST
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_selected_info  USING    pt_list LIKE gt_list
                                 po_alv TYPE REF TO cl_gui_alv_grid
                        CHANGING VALUE(cs_list) TYPE zsa3mm6013
                                 VALUE(cv_subrc) TYPE sy-subrc.
  call function 'ZFA3MM6002'
    EXPORTING
      it_data  = pt_list
      io_alv   = po_alv
    IMPORTING
      es_data  = cs_list
      ev_subrc = cv_subrc.
  IF cv_subrc <> 0.
    MESSAGE i024(zmcn11603) INTO gv_messg.  " 하나의 행을 선택하고 버튼을 눌러야 합니다.
    RETURN.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_update_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_LIST
*&      <-- GS_HUPT
*&      <-- GT_HUPT
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_detail_info  USING    VALUE(ps_list) TYPE zsa3mm6013
                      CHANGING VALUE(cs_head) TYPE zsa3mm6014
                               ct_item LIKE gt_iupt
                               VALUE(cv_subrc) TYPE sy-subrc.
  " 출고 Header 정보 가져오기
  PERFORM get_uheader_info USING ps_list-iotid
                          CHANGING cs_head cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  " 출고 Item 정보 가져오기
  PERFORM get_uitem_info USING ps_list-iotid
                        CHANGING ct_item cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  " 출고 Header에 오더번호 넣어주기
  PERFORM set_odrid USING ct_item
                    CHANGING cs_head.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_header_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_LIST_IOTID
*&      <-- CS_HUPT
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_uheader_info  USING    VALUE(p_iotid) TYPE zta3mm0010-iotid
                      CHANGING VALUE(cs_head) TYPE zsa3mm6014
                               VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE iotid otype prtyp movid AS odrid plaid
                erdat aedat bktxt erzet aezet ereid aeeid
    FROM zta3mm0010
    INTO CORRESPONDING FIELDS OF cs_head
   WHERE iotid = p_iotid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i025(zmcn11603) WITH p_iotid INTO gv_messg. " & 없는 출고 번호 입니다.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_uitem_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_LIST_IOTID
*&      <-- CT_IUPT
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_uitem_info  USING    VALUE(p_iotid) TYPE zta3mm0010-iotid
                     CHANGING ct_item LIKE gt_iupt
                              VALUE(cv_subrc) TYPE sy-subrc.
  SELECT iotid scode matid stoid podid sodid batid mtcnt
         meins sfcod bktxt
    FROM zta3mm0011
    INTO CORRESPONDING FIELDS OF TABLE ct_item
   WHERE iotid = p_iotid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i025(zmcn11603) WITH p_iotid INTO gv_messg. " & 없는 출고 번호 입니다.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_odrid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> CT_IUPT
*&      <-- CS_HUPT
*&---------------------------------------------------------------------*


FORM set_odrid  USING    pt_iupt LIKE gt_iupt
                CHANGING VALUE(cs_hupt) TYPE zsa3mm6014.
  DATA ls_iupt TYPE zsa3mm6015.

  READ TABLE pt_iupt INDEX 1 INTO ls_iupt.

  IF ls_iupt-podid IS NOT INITIAL.
    cs_hupt-odrid = ls_iupt-podid.
  ENDIF.

  IF ls_iupt-sodid IS NOT INITIAL.
    cs_hupt-odrid = ls_iupt-sodid.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form create_container_edit
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> GO_UECON
*&      --> GO_UEDIT
*&---------------------------------------------------------------------*


FORM create_container_edit  USING    VALUE(p_cname)
                                     po_con TYPE REF TO cl_gui_custom_container
                                     po_edit TYPE REF TO cl_gui_textedit.
  IF po_con IS NOT INITIAL.
    RETURN.
  ENDIF.

  CREATE OBJECT po_con
    EXPORTING


*     parent                      =


      container_name              = p_cname


*     style                       =
*     lifetime                    = lifetime_default
*     repid                       =
*     dynnr                       =
*     no_autodef_progid_dynnr     =


    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.
  IF sy-subrc <> 0.


*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.


  ENDIF.

  CREATE OBJECT po_edit
    EXPORTING


*     max_number_chars       =
*     style                  = 0
*     wordwrap_mode          = WORDWRAP_AT_WINDOWBORDER
*     wordwrap_position      = -1
*     wordwrap_to_linebreak_mode = FALSE
*     filedrop_mode          = DROPFILE_EVENT_OFF


      parent                 = po_con


*     lifetime               =
*     name                   =


    EXCEPTIONS
      error_cntl_create      = 1
      error_cntl_init        = 2
      error_cntl_link        = 3
      error_dp_create        = 4
      gui_type_not_supported = 5
      OTHERS                 = 6.
  IF sy-subrc <> 0.


*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.


  ENDIF.

  IF po_edit = go_dhedit OR po_edit = go_diedit OR po_edit = go_mhedit.
    CALL METHOD po_edit->set_readonly_mode
      EXPORTING
        readonly_mode          = 1
      EXCEPTIONS
        error_cntl_call_method = 1
        invalid_parameter      = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.


*     Implement suitable error handling here


    ENDIF.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_0300
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM update_0300 .
  " Text Edit에 입력받은 값 적요에 넣어주기
  PERFORM set_bktxt_header USING go_uhedit
                           CHANGING gs_hupt.

  " 수정 정보 저장할 것인지 재확인
  PERFORM ask_again USING TEXT-q02
                    CHANGING gv_answer.
  IF gv_answer <> '1'.
    CLEAR gv_answer.
    RETURN.
  ENDIF.
  CLEAR gv_answer.

  " 출고 정보 수정
  PERFORM update_entity USING gs_hupt gt_iupt
                        CHANGING gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  " 백업해 둔 조회 조건으로 출고 조회 List 새로고침
  PERFORM get_list USING gs_cond2
                   CHANGING gt_list gv_subrc.
  CLEAR gv_subrc.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_icon_iupt
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_IUPT
*&---------------------------------------------------------------------*


FORM set_icon_item  CHANGING ct_item LIKE gt_iupt.
  DATA: ls_item TYPE zsa3mm6015.

  LOOP AT ct_item INTO ls_item.
    IF ok_code = 'DETAIL'.
      IF ls_item-bktxt IS NOT INITIAL.
        ls_item-icond = icon_display.
      ENDIF.
    ELSE.
      ls_item-icond = icon_display.
    ENDIF.

    MODIFY ct_item FROM ls_item.
    CLEAR ls_item.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_bktxt
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_IUPT
*&      <-- GT_UEDIT
*&---------------------------------------------------------------------*


FORM get_bktxt  USING    po_edit TYPE REF TO cl_gui_textedit
                         VALUE(p_bktxt) TYPE zsa3hr0001-bktxt.
  DATA: ls_edit TYPE ts_text,
        lt_edit TYPE tt_text.

  ls_edit = p_bktxt.
  APPEND ls_edit TO lt_edit.

  CALL METHOD po_edit->set_text_as_r3table
    EXPORTING
      table           = lt_edit
    EXCEPTIONS
      error_dp        = 1
      error_dp_create = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.


*   Implement suitable error handling here


  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form enter_0301
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM enter_0301 .
  " Text Edit 입력받은 값 적요에 넣기
  PERFORM set_bktxt USING go_uiedit
                    CHANGING gs_iupt gt_iupt.

  LEAVE TO SCREEN 0.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_bktxt
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_UEDIT
*&      <-- GT_IUPT
*&---------------------------------------------------------------------*


FORM set_bktxt  USING    po_edit TYPE REF TO cl_gui_textedit
                CHANGING VALUE(cs_iupt) TYPE zsa3mm6015
                         ct_iupt LIKE gt_iupt.
  DATA: lt_edit TYPE tt_text,
        ls_edit TYPE ts_text.

  CALL METHOD po_edit->get_text_as_r3table


*    EXPORTING
*      only_when_modified     = FALSE


    IMPORTING
      table                  = lt_edit


*     is_modified            =


    EXCEPTIONS
      error_dp               = 1
      error_cntl_call_method = 2
      error_dp_create        = 3
      potential_data_loss    = 4
      OTHERS                 = 5.
  IF sy-subrc <> 0.


*   Implement suitable error handling here


  ENDIF.

  READ TABLE lt_edit INDEX 1 INTO ls_edit.

  cs_iupt-bktxt = ls_edit-text.

  MODIFY ct_iupt FROM cs_iupt TRANSPORTING bktxt WHERE scode = cs_iupt-scode.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form enter_0300
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM enter_0300 .
  " Text Edit에 입력받은값 적요에 넣어주기
  PERFORM set_bktxt_header USING go_uhedit
                           CHANGING gs_hupt.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_bktxt_header
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GO_UHEDIT
*&      <-- GS_HUPT
*&---------------------------------------------------------------------*


FORM set_bktxt_header  USING    po_edit TYPE REF TO cl_gui_textedit
                       CHANGING VALUE(cs_hupt) TYPE zsa3mm6014.
  DATA: lt_edit TYPE tt_text,
        ls_edit TYPE ts_text.

  CALL METHOD po_edit->get_text_as_r3table


*    EXPORTING
*      only_when_modified     = FALSE


    IMPORTING
      table                  = lt_edit


*     is_modified            =


    EXCEPTIONS
      error_dp               = 1
      error_cntl_call_method = 2
      error_dp_create        = 3
      potential_data_loss    = 4
      OTHERS                 = 5.
  IF sy-subrc <> 0.


*   Implement suitable error handling here


  ENDIF.

  READ TABLE lt_edit INDEX 1 INTO ls_edit.

  cs_hupt-bktxt = ls_edit-text.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_entity
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_HUPT
*&      --> GT_IUPT
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM update_entity  USING    VALUE(ps_hupt) TYPE zsa3mm6014
                             pt_iupt LIKE gt_iupt
                    CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA: ls_iupt LIKE gs_iupt.

  " 출고 Header 저장
  PERFORM update_header USING ps_hupt
                        CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  LOOP AT pt_iupt INTO ls_iupt.
    " 출고 Item 저장
    PERFORM update_item USING ls_iupt
                        CHANGING cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.
  ENDLOOP.

  COMMIT WORK.
  MESSAGE s018(zmcn11601). " 레코드 수정에 성공 했습니다.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_header
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_HUPT
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM update_header  USING    VALUE(ps_hupt) TYPE zsa3mm6014
                    CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_aeeid TYPE zsa3mm6006-aeeid.

  PERFORM get_mapping_id USING sy-uname
                         CHANGING lv_aeeid.

  UPDATE zta3mm0010 SET bktxt = ps_hupt-bktxt
                        aedat = sy-datum
                        aezet = sy-uzeit
                        aeeid = lv_aeeid
                    WHERE iotid = ps_hupt-iotid.
  IF sy-subrc <> 0.
    ROLLBACK WORK.
    cv_subrc = sy-subrc.
    MESSAGE i019(zmcn11601) INTO gv_messg. " 레코드 수정에 실패 했습니다.
    gv_messt = 'E'.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_item
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_IUPT
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM update_item  USING    VALUE(ps_iupt) TYPE zsa3mm6015
                  CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_aeeid TYPE zsa3mm6006-aeeid.

  PERFORM get_mapping_id USING sy-uname
                         CHANGING lv_aeeid.

  UPDATE zta3mm0011 SET bktxt = ps_iupt-bktxt
                        aedat = sy-datum
                        aezet = sy-uzeit
                        aeeid = lv_aeeid
                    WHERE iotid = ps_iupt-iotid
                      AND scode = ps_iupt-scode.
  IF sy-subrc <> 0.
    ROLLBACK WORK.
    cv_subrc = sy-subrc.
    MESSAGE i019(zmcn11601) INTO gv_messg. " 레코드 수정에 실패 했습니다.
    gv_messt = 'E'.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form enter_0400
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM enter_0400 .

ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_layo_0400
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_LAYO
*&---------------------------------------------------------------------*


FORM set_layo_0400  CHANGING VALUE(cs_layo) TYPE lvc_s_layo.
  CLEAR cs_layo.

  cs_layo-cwidth_opt = 'X'.
  cs_layo-zebra = 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_fcat_0400
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_FCAT
*&---------------------------------------------------------------------*


FORM set_fcat_0400  TABLES   t_fcat STRUCTURE lvc_s_fcat.
  CLEAR t_fcat[].

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'BKTXT' '',
                    TABLES t_fcat
                    USING 'NO_OUT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'MATID' '',
                    TABLES t_fcat
                    USING 'HOTSPOT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'ICOND' '',
                    TABLES t_fcat
                    USING 'COLTEXT' '적요'(t02) '',
                    TABLES t_fcat
                    USING 'HOTSPOT' 'X' '',
                    TABLES t_fcat
                    USING 'ICON' 'X' 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_sort_0400
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_SORT
*&---------------------------------------------------------------------*


FORM set_sort_0400  TABLES   t_sort STRUCTURE lvc_s_sort.
  CLEAR t_sort[].

  PERFORM set_sort: TABLES t_sort
                    USING 'FIELDNAME' 'SCODE' '',
                    TABLES t_sort
                    USING 'UP' 'X' 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form detail_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM detail_0100 .
  DATA: ls_list LIKE gs_list.

  " 선택한 행 값 가져오기
  PERFORM get_selected_info USING gt_list go_alv
                            CHANGING ls_list gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  " 선택한 행 값으로 Header, Item 정보 가져오기
  PERFORM get_detail_info USING ls_list
                          CHANGING gs_hdet gt_idet gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  " 플랜트명 가져오기
  PERFORM get_pname USING gs_hdet-plaid
                    CHANGING gs_hdet-pname gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  " 적요용 Icon 넣기
  PERFORM set_icon_item CHANGING gt_idet.

  " 출고 상세 Screen 호출
  CALL SCREEN 400.
  CLEAR: gs_hdet, gt_idet.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form enter_0401
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM enter_0401 .
  " Text Edit 입력받은 겂 적요에 넣기
  LEAVE TO SCREEN 0.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_fcat_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_NFCAT
*&---------------------------------------------------------------------*


FORM set_fcat_0200  TABLES   t_fcat STRUCTURE lvc_s_fcat.
  CLEAR t_fcat[].

  CASE gs_hnew-prtyp.
    WHEN 'PR'.
      PERFORM set_fcat: TABLES t_fcat
                        USING 'FIELDNAME' 'SODID' '',
                        TABLES t_fcat
                        USING 'NO_OUT' 'X' 'X'.
    WHEN 'SO'.
      PERFORM set_fcat: TABLES t_fcat
                        USING 'FIELDNAME' 'PODID' '',
                        TABLES t_fcat
                        USING 'NO_OUT' 'X' 'X'.
    WHEN 'MO'.
      PERFORM set_fcat: TABLES t_fcat
                        USING 'FIELDNAME' 'SODID' '',
                        TABLES t_fcat
                        USING 'NO_OUT' 'X' 'X'.

      PERFORM set_fcat: TABLES t_fcat
                        USING 'FIELDNAME' 'PODID' '',
                        TABLES t_fcat
                        USING 'NO_OUT' 'X' 'X'.

      PERFORM set_fcat: TABLES t_fcat
                        USING 'FIELDNAME' 'SFCOD' '',
                        TABLES t_fcat
                        USING 'NO_OUT' 'X' 'X'.
  ENDCASE.

  IF gv_sflag <> 'X'.
    PERFORM set_fcat: TABLES t_fcat
                      USING 'FIELDNAME' 'IOTID' '',
                      TABLES t_fcat
                      USING 'NO_OUT' 'X' 'X'.
  ENDIF.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'MATID' '',
                    TABLES t_fcat
                    USING 'HOTSPOT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'BKTXT' '',
                    TABLES t_fcat
                    USING 'NO_OUT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'ICOND' '',
                    TABLES t_fcat
                    USING 'COLTEXT' '적요'(t02) '',
                    TABLES t_fcat
                    USING 'HOTSPOT' 'X' '',
                    TABLES t_fcat
                    USING 'ICON' 'X' 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM check_emp .
  DATA: ls_emp   TYPE zta3hr0002,
        lv_empid TYPE zta3hr0002-empid.

  call function 'ZFA3SD5002'
    IMPORTING
      ev_empid   = lv_empid
      es_usrinfo = ls_emp
    CHANGING
      cv_subrc   = gv_subrc.
  CASE gv_subrc.
    WHEN 4.
      MESSAGE a027(zmcn11603) WITH lv_empid.
    WHEN 1.
      MESSAGE a028(zmcn11603) WITH lv_empid.
  ENDCASE.

ENDFORM.


*&---------------------------------------------------------------------*
*& Module STATUS_0203 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE status_0203 OUTPUT.
  SET PF-STATUS 'S203'.
  SET TITLEBAR 'T203'.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Form enter_0203
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM enter_0203 .
  " Text Edit 입력받은 값 적요에 넣어주기
  PERFORM set_bktxt USING go_iiedit
                    CHANGING gs_inew gt_inew.

  LEAVE TO SCREEN 0.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_readonly
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GO_IIEDIT
*&---------------------------------------------------------------------*


FORM set_readonly  USING    po_edit TYPE REF TO cl_gui_textedit.
  IF gv_sflag = 'X'.
    CALL METHOD po_edit->set_readonly_mode
      EXPORTING
        readonly_mode          = 1
      EXCEPTIONS
        error_cntl_call_method = 1
        invalid_parameter      = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.


*       Implement suitable error handling here


    ENDIF.
  ELSE.
    CALL METHOD po_edit->set_readonly_mode
      EXPORTING
        readonly_mode          = 0
      EXCEPTIONS
        error_cntl_call_method = 1
        invalid_parameter      = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.


*       Implement suitable error handling here


    ENDIF.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form enter_0101
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM enter_0101 .
  LEAVE TO SCREEN 0.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form erdet_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM erdet_0200 .
  " 직원 정보 가져오기
  PERFORM get_emp_info USING gs_hnew-ereid
                       CHANGING gs_emp gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  CALL SCREEN 204 STARTING AT 10 10.
  CLEAR gs_emp.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_emp_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_HNEW_EREID
*&      <-- GS_EMP
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_emp_info  USING    VALUE(p_empid) TYPE zta3hr0002-empid
                   CHANGING VALUE(cs_emp) TYPE zsa3mm6024
                            VALUE(cv_subrc) TYPE sy-subrc.
  " 직원 정보 가져오기
  PERFORM search_emp_info USING p_empid
                          CHANGING cs_emp cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  " 부서명 가져오기
  PERFORM get_depnm USING cs_emp-depid
                    CHANGING cs_emp-depnm cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  " Domain Text 가져오기
  PERFORM get_domain_value USING 'GESCH' cs_emp-gnder
                           CHANGING cs_emp-gnder_t.

  PERFORM get_domain_value USING 'ZDA3_HR_EDOMN' cs_emp-edomn
                           CHANGING cs_emp-edomn_t.

  PERFORM get_domain_value USING 'ZDA3_HR_GRADE' cs_emp-grade
                           CHANGING cs_emp-grade_t.

  " 이메일 도메인과 이어붙여주기
  cs_emp-etext = cs_emp-email && cs_emp-edomn_t.
  TRANSLATE cs_emp-etext TO LOWER CASE.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form search_emp_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_EMPID
*&      <-- CS_EMP
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM search_emp_info  USING    VALUE(p_empid) TYPE zta3hr0002-empid
                      CHANGING VALUE(cs_emp) TYPE zsa3mm6024
                               VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE empid empnm depid gnder telno email edomn grade
    FROM zta3hr0002
    INTO CORRESPONDING FIELDS OF cs_emp
   WHERE empid = p_empid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i030(zmcn11603) WITH p_empid INTO gv_messg. " & 등록되지 않은 직원입니다.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_depnm
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> CS_EMP_DEPID
*&      <-- CS_EMP_DEPNM
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_depnm  USING    VALUE(p_depid) TYPE zta3hr0001-depid
                CHANGING VALUE(cv_depnm) TYPE zta3hr0001-depnm
                         VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE depnm
    FROM zta3hr0001
    INTO cv_depnm
   WHERE depid = p_depid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i031(zmcn11603) WITH p_depid INTO gv_messg. " & 등록되지 않은 부서입니다.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form erdet_0400
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM erdet_0400 .
  " 직원 정보 가져오기
  PERFORM get_emp_info USING gs_hdet-ereid
                       CHANGING gs_emp gv_subrc.
  IF gv_subrc <> 0.

  ENDIF.

  CALL SCREEN 204 STARTING AT 10 10.
  CLEAR gs_emp.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form pdata_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM pdata_0200 .
  " 플랜트 정보 가져오기
  PERFORM get_plant_info USING gs_hnew-plaid
                         CHANGING gs_plant gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  CALL SCREEN 205 STARTING AT 10 10.
  CLEAR: gs_plant.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_plant_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_HDET_PLAID
*&      <-- GS_PLANT
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_plant_info  USING    VALUE(p_plaid) TYPE zta3mm0006-plaid
                     CHANGING VALUE(cs_plant) TYPE zsa3mm6005
                              VALUE(cv_subrc) TYPE sy-subrc.
  " 플랜트 정보 가져오기
  PERFORM search_plant_info USING p_plaid
                            CHANGING cs_plant cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  " 플랜트명 가져오기
  PERFORM get_pname USING p_plaid
                    CHANGING cs_plant-pname cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form search_plant_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_PLAID
*&      <-- CS_PLANT
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM search_plant_info  USING    VALUE(p_plaid) TYPE zta3mm0006-plaid
                        CHANGING VALUE(cs_plant) TYPE zsa3mm6005
                                 VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE plaid p~empid empnm ptlno p~cityc
                ctext npost stras faxno pflag
    FROM zta3mm0006 AS p
   INNER JOIN zta3hr0002 AS e
      ON p~empid = e~empid
   INNER JOIN zta3hr0003_t AS c
      ON p~cityc = c~cityc
     AND c~spras = sy-langu
    INTO CORRESPONDING FIELDS OF cs_plant
   WHERE p~plaid = p_plaid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i032(zmcn11603) WITH p_plaid INTO gv_messg. " & 등록되지 않은 플랜트 입니다.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form pdata_0300
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM pdata_0300 .
  " 플랜트 정보 가져오기
  PERFORM get_plant_info USING gs_hupt-plaid
                         CHANGING gs_plant gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  CALL SCREEN 205 STARTING AT 10 10.
  CLEAR: gs_plant.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form pdata_0400
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM pdata_0400 .
  " 플랜트 정보 가져오기
  PERFORM get_plant_info USING gs_hdet-plaid
                         CHANGING gs_plant gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  CALL SCREEN 205 STARTING AT 10 10.
  CLEAR: gs_plant.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_odrid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_HNEW
*&      --> PT_INEW
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM check_odrid  USING    VALUE(ps_hnew) TYPE zsa3mm6014
                           pt_inew LIKE gt_inew
                           pt_mitem LIKE gt_mitem
                  CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA: ls_inew  TYPE zsa3mm6015,
        ls_mitem TYPE ts_mitem.


  CASE ps_hnew-prtyp.
    WHEN 'PR'.
      READ TABLE pt_inew INDEX 1 INTO ls_inew.

      IF ps_hnew-odrid <> ls_inew-podid.
        cv_subrc = 4.
        MESSAGE i034(zmcn11603) INTO gv_messg. " 입출고 헤더와 아이템의 오더번호가 다릅니다.
        RETURN.
      ENDIF.
    WHEN 'SO'.
      READ TABLE pt_inew INDEX 1 INTO ls_inew.

      IF ps_hnew-odrid <> ls_inew-sodid.
        cv_subrc = 4.
        MESSAGE i034(zmcn11603) INTO gv_messg. " 입출고 헤더와 아이템의 오더번호가 다릅니다.
        RETURN.
      ENDIF.
    WHEN 'MO'.
      READ TABLE pt_mitem INDEX 1 INTO ls_mitem.

      IF ps_hnew-odrid <> ls_mitem-movid.
        cv_subrc = 4.
        MESSAGE i033(zmcn11603) INTO gv_messg. " 오더 정보 가져오기를 먼저 눌러주십시오.
        RETURN.
      ENDIF.
  ENDCASE.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_mat_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_ITEM_MATID
*&      <-- GS_MAT
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_mat_data  USING    VALUE(p_matid) TYPE zta3mm0001-matid
                   CHANGING VALUE(cs_mat) TYPE zsa3mm6004
                            VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE matid mtype matgr stway meins maqua
    FROM zta3mm0001
    INTO CORRESPONDING FIELDS OF cs_mat
   WHERE matid = p_matid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i002(zmcn11601) WITH p_matid.
    RETURN.
  ENDIF.

  PERFORM get_mtext USING p_matid
                    CHANGING cs_mat-mtext cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  PERFORM get_domain_value USING 'ZDA3_MM_MTYPE' cs_mat-mtype
                           CHANGING cs_mat-mtype_t.

  PERFORM get_domain_value USING 'ZDA3_MM_MATGR' cs_mat-matgr
                           CHANGING cs_mat-matgr_t.

  PERFORM get_domain_value USING 'ZDA3_MM_STWAY' cs_mat-stway
                           CHANGING cs_mat-stway_t.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_mtext
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_MATID
*&      <-- CS_MAT_MTEXT
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_mtext  USING    VALUE(p_matid) TYPE zsa3mm6002-matid
                CHANGING VALUE(cv_mtext) TYPE zsa3mm6002-mtext
                         VALUE(cv_subrc) TYPE sy-subrc.
  CLEAR cv_mtext.

  IF p_matid IS INITIAL.
    RETURN.
  ENDIF.

  SELECT SINGLE mtext
    FROM zta3mm0001_t
    INTO cv_mtext
   WHERE matid = p_matid
     AND spras = sy-langu.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i035(zmcn11603) WITH sy-langu p_matid INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form order_0300
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM order_0300 .
  PERFORM get_header_data USING gs_hupt
                          CHANGING gs_phead gs_shead gs_mhead gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM get_item_data USING gs_hupt
                        CHANGING gt_mitem gt_sitem gt_pitem gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  CLEAR: gv_dynnr2.
  CASE gs_hupt-prtyp.
    WHEN 'PR'.
      gv_dynnr2 = '0303'.
    WHEN 'SO'.
      gv_dynnr2 = '0304'.
    WHEN 'MO'.
      gv_dynnr2 = '0305'.
  ENDCASE.

  IF gs_hdet-prtyp <> 'IM'.
    CALL SCREEN 302 STARTING AT 10 10.
  ENDIF.

  CLEAR: gt_mitem, gt_sitem, gt_pitem, gs_phead, gs_shead, gs_mhead.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_item_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_HUPT_ODRID
*&      <-- GT_MITEM
*&      <-- GT_SITEM
*&      <-- GT_PITEM
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_item_data  USING    VALUE(ps_header) TYPE zsa3mm6014
                    CHANGING ct_mitem LIKE gt_mitem
                             ct_sitem LIKE gt_sitem
                             ct_pitem LIKE gt_pitem
                             VALUE(cv_subrc) TYPE sy-subrc.
  CLEAR: ct_mitem, ct_sitem, ct_pitem.

  CASE ps_header-prtyp.
    WHEN 'PR'.
      PERFORM get_item_data_pr USING ps_header-odrid
                               CHANGING ct_pitem cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.
    WHEN 'SO'.
      PERFORM get_item_data_so USING ps_header-odrid
                               CHANGING ct_sitem cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.
    WHEN 'MO'.
      PERFORM get_item_data_mo USING ps_header-odrid
                               CHANGING ct_mitem cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.
  ENDCASE.


ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_header_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_HUPT
*&      <-- GS_PHEAD
*&      <-- GS_SHEAD
*&      <-- GS_MHEAD
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_header_data  USING    VALUE(ps_header) TYPE zsa3mm6014
                      CHANGING VALUE(cs_phead) TYPE zsa3mm6039
                               VALUE(cs_shead) TYPE zsa3mm6040
                               VALUE(cs_mhead) TYPE zsa3mm6041
                               VALUE(cv_subrc) TYPE sy-subrc.
  CLEAR: cs_phead, cs_shead, cs_mhead.

  CASE ps_header-prtyp.
    WHEN 'PR'.

      PERFORM get_header_data_pr USING ps_header-odrid
                                 CHANGING cs_phead cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.

      PERFORM get_domain_value USING 'ZDA3_PP_CSTAT' cs_phead-cstat
                               CHANGING cs_phead-cstat_t.

      PERFORM get_mtext USING cs_phead-prdnr
                        CHANGING cs_phead-mtext cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.

    WHEN 'SO'.
      PERFORM get_header_data_so USING ps_header-odrid
                                 CHANGING cs_shead cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.

      PERFORM get_domain_value USING 'ZDA3_SD_SSTAT' cs_shead-sstat
                               CHANGING cs_shead-sstat_t.

      PERFORM get_domain_value USING 'ZDA3_SD_LIFSK' cs_shead-lifsk
                               CHANGING cs_shead-lifsk_t.
    WHEN 'MO'.
      PERFORM get_header_data_mo USING ps_header-odrid
                                 CHANGING cs_mhead cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.

      PERFORM get_pname USING cs_mhead-plaid
                        CHANGING cs_mhead-pname cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.

      PERFORM get_domain_value USING 'ZDA3_MM_MSTAT' cs_mhead-mstat
                               CHANGING cs_mhead-mstat_t.

      PERFORM get_domain_value USING 'ZDA3_MM_VTYPE' cs_mhead-vtype
                               CHANGING cs_mhead-vtype_t.
  ENDCASE.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_header_data_pr
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_HEADER_ODRID
*&      <-- CS_PHEAD
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_header_data_pr  USING    VALUE(p_odrid) TYPE zsa3mm6014-odrid
                         CHANGING VALUE(cs_phead) TYPE zsa3mm6039
                                  VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE podid plaid rouid cstat prdnr aquan meins aflag
    FROM zta3pp0005
    INTO CORRESPONDING FIELDS OF cs_phead
   WHERE podid = p_odrid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i036(zmcn11603) WITH p_odrid INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_header_data_so
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_HEADER_ODRID
*&      <-- CS_SHEAD
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_header_data_so  USING    VALUE(p_odrid) TYPE zsa3mm6014-odrid
                         CHANGING VALUE(cs_shead) TYPE zsa3mm6040
                                  VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE sodid s~bupid bupnm totpr waers sstat vdate lifsk aflag
    FROM zta3sd0001 AS s
   INNER JOIN zta3mm0004 AS b
      ON s~bupid = b~bupid
    INTO CORRESPONDING FIELDS OF cs_shead
   WHERE sodid = p_odrid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i037(zmcn11603) WITH p_odrid INTO gv_messg.
    RETURN.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_header_data_mo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_HEADER_ODRID
*&      <-- CS_MHEAD
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_header_data_mo  USING    VALUE(p_odrid) TYPE zsa3mm6014-odrid
                         CHANGING VALUE(cs_mhead) TYPE zsa3mm6041
                                  VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE movid plaid mstat vtype
    FROM zta3mm0017
    INTO CORRESPONDING FIELDS OF cs_mhead
   WHERE movid = p_odrid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i038(zmcn11603) WITH p_odrid INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_item_data_pr
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_HEADER_ODRID
*&      <-- CT_PITEM
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_item_data_pr  USING    VALUE(p_odrid) TYPE zsa3mm6014-odrid
                       CHANGING ct_pitem LIKE gt_pitem
                                VALUE(cv_subrc) TYPE sy-subrc.
  SELECT podid scode rawnr plaid opcod pquan meins gifla
    FROM zta3pp0006
    INTO CORRESPONDING FIELDS OF TABLE ct_pitem
   WHERE podid = p_odrid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i036(zmcn11603) WITH p_odrid INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_item_data_so
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_HEADER_ODRID
*&      <-- CT_SITEM
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_item_data_so  USING    VALUE(p_odrid) TYPE zsa3mm6014-odrid
                       CHANGING ct_sitem LIKE gt_sitem
                                VALUE(cv_subrc) TYPE sy-subrc.
  SELECT sodid scode matid plaid squan meins sflag gifla
    FROM zta3sd0002
    INTO CORRESPONDING FIELDS OF TABLE ct_sitem
   WHERE sodid = p_odrid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i037(zmcn11603) WITH p_odrid INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_item_data_mo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_HEADER_ODRID
*&      <-- CT_MITEM
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_item_data_mo  USING    VALUE(p_odrid) TYPE zsa3mm6014-odrid
                       CHANGING ct_mitem LIKE gt_mitem
                                VALUE(cv_subrc) TYPE sy-subrc.
  SELECT movid scode plaid matid mtcnt meins docnm sfcod
    FROM zta3mm0018
    INTO CORRESPONDING FIELDS OF TABLE ct_mitem
   WHERE movid = p_odrid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i038(zmcn11603) WITH p_odrid INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_layo_0302
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_LAYO
*&---------------------------------------------------------------------*


FORM set_layo_0302  CHANGING VALUE(cs_layo) TYPE lvc_s_layo.
  CLEAR cs_layo.

  cs_layo-cwidth_opt = 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_fcat_0302
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_FCAT
*&---------------------------------------------------------------------*


FORM set_fcat_0302  TABLES   t_fcat STRUCTURE gt_fcat.
  CLEAR t_fcat[].

  CASE gv_dynnr.
    WHEN '0303'.
      PERFORM set_fcat: TABLES t_fcat
                        USING 'FIELDNAME' 'GIFLA' '',
                        TABLES t_fcat
                        USING 'CHECKBOX' 'X' 'X'.
    WHEN '0304'.
      PERFORM set_fcat: TABLES t_fcat
                        USING 'FIELDNAME' 'GIFLA' '',
                        TABLES t_fcat
                        USING 'CHECKBOX' 'X' 'X'.

      PERFORM set_fcat: TABLES t_fcat
                        USING 'FIELDNAME' 'SFLAG' '',
                        TABLES t_fcat
                        USING 'CHECKBOX' 'X' 'X'.

    WHEN '0305'.

  ENDCASE.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form order_0400
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM order_0400 .
  PERFORM get_header_data USING gs_hdet
                          CHANGING gs_phead gs_shead gs_mhead gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM get_item_data USING gs_hdet
                        CHANGING gt_mitem gt_sitem gt_pitem gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  CLEAR: gv_dynnr2.
  CASE gs_hdet-prtyp.
    WHEN 'PR'.
      gv_dynnr2 = '0303'.
    WHEN 'SO'.
      gv_dynnr2 = '0304'.
    WHEN 'MO'.
      gv_dynnr2 = '0305'.
  ENDCASE.

  IF gs_hdet-prtyp <> 'IM'.
    CALL SCREEN 302 STARTING AT 10 10.
  ENDIF.

  CLEAR: gt_mitem, gt_sitem, gt_pitem, gs_phead, gs_shead, gs_mhead.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form reset_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM reset_0200 .
  CLEAR: gs_hnew, gt_inew, gt_pitem, gt_sitem, gt_mitem.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form order_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM order_0200 .
  PERFORM get_header_data USING gs_hnew
                          CHANGING gs_phead gs_shead gs_mhead gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM get_item_data USING gs_hnew
                        CHANGING gt_mitem gt_sitem gt_pitem gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  CLEAR: gv_dynnr2.
  CASE gs_hnew-prtyp.
    WHEN 'PR'.
      gv_dynnr2 = '0303'.
    WHEN 'SO'.
      gv_dynnr2 = '0304'.
    WHEN 'MO'.
      gv_dynnr2 = '0305'.
  ENDCASE.

  IF gs_hdet-prtyp <> 'IM'.
    CALL SCREEN 302 STARTING AT 10 10.
  ENDIF.

  CLEAR: gt_mitem, gt_sitem, gt_pitem, gs_phead, gs_shead, gs_mhead.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_pp_header_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_MITEM_DOCNM
*&      <-- LS_PHEAD
*&---------------------------------------------------------------------*


FORM get_pp_header_info  USING    VALUE(p_podid) TYPE zta3pp0005-podid
                         CHANGING VALUE(cs_phead) TYPE zta3pp0005.
  SELECT SINGLE podid plaid cstat prdnr
    FROM zta3pp0005
    INTO CORRESPONDING FIELDS OF cs_phead
   WHERE podid = p_podid.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_inven_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_PITEM_RAWNR
*&      --> CS_HNEW_PLAID
*&      <-- LT_INVEN2
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_inven_info  USING    VALUE(p_matid) TYPE zta3mm0001-matid
                              VALUE(p_plaid) TYPE zta3mm0006-plaid
                     CHANGING ct_inven TYPE tt_inven
                              VALUE(cv_subrc) TYPE sy-subrc.
  SELECT matid batid plaid stoid labst scrap
    FROM zta3mm0002
    INTO CORRESPONDING FIELDS OF TABLE ct_inven
   WHERE matid = p_matid
     AND plaid = p_plaid.
  IF sy-subrc <> 0.
    cv_subrc = 4.
    MESSAGE i009(zmcn11603) WITH p_plaid p_matid INTO gv_messg. " & 자재 재고가 부족합니다.
    RETURN.
  ENDIF.
ENDFORM.
