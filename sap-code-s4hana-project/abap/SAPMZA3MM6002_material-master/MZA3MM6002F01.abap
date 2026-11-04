*&---------------------------------------------------------------------*
*& Include          MZA3MM6002F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form create_container
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GO_CON
*&      --> GO_ALV
*&      --> P_
*&---------------------------------------------------------------------*


FORM create_container  USING    po_con TYPE REF TO cl_gui_custom_container
                                po_alv TYPE REF TO cl_gui_alv_grid
                                VALUE(p_cname).
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
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_layout_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_LAYO
*&---------------------------------------------------------------------*


FORM set_layout_0100  CHANGING VALUE(cs_layo) TYPE lvc_s_layo.
  CLEAR cs_layo.

  cs_layo-cwidth_opt = 'X'.
  cs_layo-sel_mode = 'A'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_FCAT
*&      --> P_
*&      --> GO_ALV
*&      --> GT_LIST
*&      --> GS_LAYO
*&---------------------------------------------------------------------*


FORM display_alv  TABLES   t_fcat STRUCTURE lvc_s_fcat
                  USING    VALUE(p_sname)
                           po_alv TYPE REF TO cl_gui_alv_grid
                           pt_list
                           VALUE(ps_layo) TYPE lvc_s_layo.
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
      it_fieldcatalog               = t_fcat[]


*     it_sort                       =
*     it_filter                     =


    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.


* Implement suitable error handling here


  ENDIF.
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
                    USING 'FIELDNAME' 'MTYPE_T' '',
                    TABLES t_fcat
                    USING 'COLTEXT' '자재타입명'(t01) 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'MATGR_T' '',
                    TABLES t_fcat
                    USING 'COLTEXT' '자재그룹명'(t02) 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'STWAY_T' '',
                    TABLES t_fcat
                    USING 'COLTEXT' '보관방법명'(t01) 'X'.
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
    IF screen-group1 = 'Y'.
      IF gs_cond-condb = 'X'.
        screen-input = '1'.
      ELSE.
        screen-input = '0'.
      ENDIF.
    ENDIF.

    IF screen-group1 = 'N'.
      IF gs_cond-condb = 'X'.
        screen-input = '0'.
      ELSE.
        screen-input = '1'.
      ENDIF.
    ENDIF.

    MODIFY SCREEN.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_default
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_COND
*&---------------------------------------------------------------------*


FORM set_default  CHANGING VALUE(cs_cond) TYPE zsa3mm6007
                           ct_atbar LIKE gt_atbar.
  cs_cond-condb = 'X'.
  cs_cond-matid = 'M20080000000001'.
  cs_cond-mtype = 'F01'.

  gs_atbar = 'NEXT'.
  APPEND gs_atbar TO gt_atbar.
  CLEAR gs_atbar.
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
                        VALUE(p_aflag).
  DATA lv_fcat(30).
  FIELD-SYMBOLS <fs_fcat>.

  lv_fcat = 'T_FCAT-' && p_fname.
  ASSIGN (lv_fcat) TO <fs_fcat>.

  <fs_fcat> = p_value.

  IF p_aflag = 'X'.
    APPEND t_fcat.
    CLEAR t_fcat.
  ENDIF.
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
  PERFORM check_cond USING gs_cond
                     CHANGING gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM get_list_data USING gs_cond
                        CHANGING gt_list gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_list_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_COND
*&      <-- GT_LIST
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_list_data  USING    VALUE(ps_cond) TYPE zsa3mm6007
                    CHANGING ct_list LIKE gt_list
                             VALUE(cv_subrc) TYPE sy-subrc.
  IF zsa3mm6007-condb = 'X'.
    PERFORM get_list_by_matid USING ps_cond
                              CHANGING ct_list cv_subrc.
  ELSE.
    PERFORM get_list_by_other USING ps_cond
                              CHANGING ct_list cv_subrc.
  ENDIF.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  PERFORM at_loop CHANGING ct_list cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_list_by_matid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_COND
*&      <-- CT_LIST
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_list_by_matid  USING    VALUE(ps_cond) TYPE zsa3mm6007
                        CHANGING ct_list LIKE gt_list
                                 VALUE(cv_subrc) TYPE sy-subrc.

  SELECT matid mtype matgr stway meins maqua
    FROM zta3mm0001
    INTO CORRESPONDING FIELDS OF TABLE ct_list
   WHERE matid = ps_cond-matid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i002(zmcn11602) WITH ps_cond-matid INTO gv_messg.
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


FORM show_message  CHANGING VALUE(cv_messg) TYPE string
                            VALUE(cv_messt) TYPE char1
                            VALUE(cv_subrc) TYPE sy-subrc.
  CLEAR cv_subrc.

  CASE cv_messt.
    WHEN 'S'.
      MESSAGE s000(zmcn11602) WITH cv_messg.
    WHEN 'I'.
      MESSAGE i000(zmcn11602) WITH cv_messg.
  ENDCASE.

  CLEAR: cv_messg, cv_messt.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_list_by_other
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_COND
*&      <-- CT_LIST
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_list_by_other  USING    VALUE(ps_cond) TYPE zsa3mm6007
                        CHANGING ct_list LIKE gt_list
                                 VALUE(cv_subrc) TYPE sy-subrc.
  DATA ls_list TYPE zsa3mm6008.

  SELECT matid mtype matgr stway meins maqua
    FROM zta3mm0001
    INTO CORRESPONDING FIELDS OF TABLE ct_list
   WHERE mtype = ps_cond-mtype.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i001(zmcn11602) INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.

  IF ps_cond-matgr IS NOT INITIAL.
    DELETE ct_list WHERE matgr <> ps_cond-matgr.
  ENDIF.

  IF ps_cond-stway IS NOT INITIAL.
    DELETE ct_list WHERE stway <> ps_cond-stway.
  ENDIF.

  LOOP AT ct_list INTO ls_list.
    PERFORM get_mtext USING ls_list-matid
                      CHANGING ls_list-mtext cv_subrc.
    IF cv_subrc <> 0.
      MESSAGE i002(zmcn11602) WITH ls_list-matid INTO gv_messg.
      gv_messt = 'I'.
      RETURN.
    ENDIF.

    MODIFY ct_list FROM ls_list.
    CLEAR ls_list.
  ENDLOOP.

  IF ps_cond-mtext IS NOT INITIAL.
    DELETE ct_list WHERE mtext NP ps_cond-mtext.
  ENDIF.

  IF ct_list IS INITIAL.
    cv_subrc = 4.
    MESSAGE i001(zmcn11602) INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_mtext
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_LIST_MATID
*&      <-- LS_LIST_MTEXT
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_mtext  USING    VALUE(p_matid) TYPE zta3mm0001-matid
                CHANGING VALUE(cv_mtext) TYPE zta3mm0001_t-mtext
                         VALUE(cv_subrc) TYPE sy-subrc.
  CLEAR cv_mtext.

  SELECT SINGLE mtext
    FROM zta3mm0001_t
    INTO cv_mtext
   WHERE matid = p_matid
     AND spras = sy-langu.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form at_loop
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- CT_LIST
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM at_loop  CHANGING ct_list LIKE gt_list
                       VALUE(cv_subrc) TYPE sy-subrc.
  DATA ls_list TYPE zsa3mm6008.

  LOOP AT ct_list INTO ls_list.
    PERFORM get_domain_value USING 'ZDA3_MM_MTYPE' ls_list-mtype
                             CHANGING ls_list-mtype_t.
    PERFORM get_domain_value USING 'ZDA3_MM_MATGR' ls_list-matgr
                             CHANGING ls_list-matgr_t.
    PERFORM get_domain_value USING 'ZDA3_MM_STWAY' ls_list-stway
                             CHANGING ls_list-stway_t.

    PERFORM get_mtext USING ls_list-matid
                      CHANGING ls_list-mtext cv_subrc.
    IF cv_subrc <> 0.
      MESSAGE i002(zmcn11602) WITH ls_list-matid INTO gv_messg.
      gv_messt = 'I'.
      RETURN.
    ENDIF.

    MODIFY ct_list FROM ls_list.
    CLEAR ls_list.
  ENDLOOP.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_domain_value
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> LS_LIST_MTYPE
*&      <-- LS_LIST_MTYPE_T
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
*& Form check_cond
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_COND
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM check_cond  USING    VALUE(ps_cond) TYPE zsa3mm6007
                 CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  IF ps_cond-condb = 'X'.
    PERFORM check_matid USING ps_cond-matid
                        CHANGING cv_subrc.
    IF cv_subrc <> 0.
      MESSAGE i003(zmcn11602) INTO gv_messg.
      gv_messt = 'I'.
      RETURN.
    ENDIF.
  ELSE.
    PERFORM check_mtype USING ps_cond-mtype
                        CHANGING cv_subrc.
    IF cv_subrc <> 0.
      MESSAGE i003(zmcn11602) INTO gv_messg.
      gv_messt = 'I'.
      RETURN.
    ENDIF.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_matid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_COND_MATID
*&      --> PS_COND_CONDB
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM check_matid  USING    VALUE(p_matid) TYPE zta3mm0001-matid
                  CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  IF p_matid IS INITIAL.
    cv_subrc = 4.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_mtype
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_COND_MTYPE
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM check_mtype  USING    VALUE(p_mtype) TYPE zta3mm0001-mtype
                  CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  IF p_mtype IS INITIAL.
    cv_subrc = 4.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form create_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM create_0100 .
  CALL SCREEN 0200.
  CLEAR gs_new.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form isave_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM isave_0200 .
  DATA lv_num(10) TYPE n.

  PERFORM get_number_range USING 'ZNRA3MM61' '01'
                           CHANGING lv_num gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM set_matid USING lv_num
                    CHANGING gs_new-matid.

  PERFORM insert_mat_data USING gs_new
                          CHANGING gv_subrc.
  IF gv_subrc <> 0.
    CLEAR gv_subrc.
    RETURN.
  ENDIF.

  PERFORM insert_mtext_data USING gs_new
                            CHANGING gv_subrc.
  IF gv_subrc <> 0.
    CLEAR gv_subrc.
    MESSAGE e006(zmcn11602).
    RETURN.
  ENDIF.

  COMMIT WORK.
  MESSAGE s005(zmcn11602).

  PERFORM set_for_next_mode.
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
  PERFORM set_for_insert_mode.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_number_range
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_NUM
*&      <-- GV_SUBRC
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
    MESSAGE i004(zmcn11602) INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_matid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_NUM
*&      <-- GS_NUM_MATID
*&---------------------------------------------------------------------*


FORM set_matid  USING    VALUE(p_num)
                CHANGING VALUE(cv_matid) TYPE zta3mm0001-matid.
  DATA lv_year(4) TYPE n.
  lv_year = sy-datum+0(4).

  cv_matid = 'M' && lv_year && p_num.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form insert_mat_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_NEW
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM insert_mat_data  USING    VALUE(ps_new) TYPE zsa3mm6009
                      CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA ls_zta3mm0001 TYPE zta3mm0001.

  ls_zta3mm0001-matid = ps_new-matid.
  ls_zta3mm0001-mtype = ps_new-mtype.
  ls_zta3mm0001-matgr = ps_new-matgr.
  ls_zta3mm0001-stway = ps_new-stway.
  ls_zta3mm0001-meins = ps_new-meins.
  ls_zta3mm0001-maqua = ps_new-maqua.
  ls_zta3mm0001-erdat = sy-datum.
  ls_zta3mm0001-erzet = sy-uzeit.
  ls_zta3mm0001-aedat = sy-datum.
  ls_zta3mm0001-aezet = sy-uzeit.

  PERFORM get_mapping_id USING sy-uname
                         CHANGING ls_zta3mm0001-ereid.
  PERFORM get_mapping_id USING sy-uname
                         CHANGING ls_zta3mm0001-aeeid.

  INSERT zta3mm0001 FROM ls_zta3mm0001.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    ROLLBACK WORK.
    MESSAGE e006(zmcn11602).
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form insert_mtext_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_NEW
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM insert_mtext_data  USING    VALUE(ps_data) TYPE zsa3mm6009
                        CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA ls_zta3mm0001_t TYPE zta3mm0001_t.

  ls_zta3mm0001_t-matid = ps_data-matid.
  ls_zta3mm0001_t-spras = sy-langu.
  ls_zta3mm0001_t-mtext = ps_data-mtext.

  INSERT zta3mm0001_t FROM ls_zta3mm0001_t.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    ROLLBACK WORK.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_for_next_mode
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM set_for_next_mode .
  CLEAR: gv_dynnr, gt_atbar.

  gv_dynnr = '0202'.

  gs_atbar = 'ISAVE'.
  APPEND gs_atbar TO gt_atbar.
  CLEAR gs_atbar.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_for_insert_mode
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM set_for_insert_mode .
  CLEAR: gv_dynnr, gt_atbar, gs_new.

  gv_dynnr = '0201'.

  gs_atbar = 'NEXT'.
  APPEND gs_atbar TO gt_atbar.
  CLEAR gs_atbar.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form matgr_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM matgr_0200 .
  CASE gs_new-matgr.
    WHEN 'FRU'.
      gs_new-maqua = 5.
    WHEN 'DAI'.
      gs_new-maqua = 7.
    WHEN 'POW'.
      gs_new-maqua = 365.
    WHEN 'PAC'.
      gs_new-maqua = 9999.
    WHEN 'KNE'.
      gs_new-maqua = 180.
    WHEN 'BEV'.
      gs_new-maqua = 30.
  ENDCASE.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_mtype_matgr
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSA3MM6009_MTYPE
*&      --> ZSA3MM6009_MATGR
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM check_mtype_matgr  USING    VALUE(p_mtype) TYPE zta3mm0001-mtype
                                 VALUE(p_matgr) TYPE zta3mm0001-matgr
                        CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  CASE p_mtype.
    WHEN 'F01'.
      IF p_matgr <> 'FRU' AND p_matgr <> 'DAI' AND p_matgr <> 'POW'.
        cv_subrc = 4.
        RETURN.
      ENDIF.
    WHEN 'F02'.

    WHEN 'F03'.
      IF p_matgr <> 'KNE' AND p_matgr <> 'BEV'.
        cv_subrc = 4.
        RETURN.
      ENDIF.
    WHEN 'P01'.
      IF p_matgr <> 'PAC'.
        cv_subrc = 4.
        RETURN.
      ENDIF.
  ENDCASE.
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
  DATA ls_list TYPE zsa3mm6008.

  PERFORM get_selected_row USING gt_list go_alv
                           CHANGING ls_list gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  MOVE-CORRESPONDING ls_list TO gs_upt.
  CALL SCREEN 300.
  CLEAR gs_upt.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_selected_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_LIST
*&      --> GO_ALV
*&      <-- LS_LIST
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_selected_row  USING    pt_list LIKE gt_list
                                po_alv TYPE REF TO cl_gui_alv_grid
                       CHANGING VALUE(cs_list) TYPE zsa3mm6008
                                VALUE(cv_subrc) TYPE sy-subrc.
  call function 'ZFA3MM6002'
    EXPORTING
      it_data  = pt_list
      io_alv   = po_alv
    IMPORTING
      es_data  = cs_list
      ev_subrc = cv_subrc.
  IF cv_subrc <> 0.
    MESSAGE i008(zmcn11602) INTO gv_messg.
    gv_messt = 'I'.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form usave_0300
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM usave_0300 .
  DATA lv_eflag(1).

  PERFORM update_mat_data USING gs_upt
                          CHANGING gv_subrc.
  IF gv_subrc <> 0.
    CLEAR gv_subrc.
    MESSAGE e019(zmcn11601).
    RETURN.
  ENDIF.

  PERFORM check_mtext USING gs_upt-matid
                      CHANGING lv_eflag.
  IF lv_eflag = 'X'.
    PERFORM insert_mtext_data USING gs_upt
                              CHANGING gv_subrc.
  ELSE.
    PERFORM update_mtext_data USING gs_upt
                              CHANGING gv_subrc.
  ENDIF.
  IF gv_subrc <> 0.
    CLEAR gv_subrc.
    MESSAGE e019(zmcn11601).
    RETURN.
  ENDIF.

  COMMIT WORK.
  MESSAGE s018(zmcn11601).
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_mtext
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_UPT_MTEXT
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM check_mtext  USING    VALUE(p_matid) TYPE zta3mm0001_t-matid
                  CHANGING VALUE(cv_eflag).
  DATA lv_mtext TYPE zTA3MM0001_T-mtext.

  SELECT SINGLE mtext
    FROM zta3mm0001_t
    INTO lv_mtext
   WHERE matid = p_matid
     AND spras = sy-langu.
  IF sy-subrc <> 0.
    cv_eflag = 'X'.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_mat_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_UPT
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM update_mat_data  USING    VALUE(ps_data) TYPE zsa3mm6009
                      CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_aeeid TYPE zsa3mm6006-aeeid.

  PERFORM get_mapping_id USING sy-uname
                         CHANGING lv_aeeid.

  UPDATE zta3mm0001 SET mtype = ps_data-mtype
                        matgr = ps_data-matgr
                        stway = ps_data-stway
                        meins = ps_data-meins
                        maqua = ps_data-maqua
                        aedat = sy-datum
                        aezet = sy-uzeit
                        aeeid = lv_aeeid
                    WHERE matid = ps_data-matid.
  IF sy-subrc <> 0.
    ROLLBACK WORK.
    cv_subrc = sy-subrc.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_mtext_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_UPT
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM update_mtext_data  USING    VALUE(ps_data) TYPE zsa3mm6009
                        CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  UPDATE zta3mm0001_t SET mtext = ps_data-mtext
                      WHERE matid = ps_data-matid
                      AND spras = sy-langu.
  IF sy-subrc <> 0.
    ROLLBACK WORK.
    cv_subrc = sy-subrc.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_mapping_id
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SY_UNAME
*&      <-- LS_ZTA3MM0002_EREID
*&---------------------------------------------------------------------*


FORM get_mapping_id  USING    VALUE(p_uname) TYPE sy-uname
                     CHANGING VALUE(cv_ereid) TYPE zsa3hr0001-ereid.
  SELECT SINGLE empid
    FROM zta3hr0002
    INTO cv_ereid
   WHERE mpgid = p_uname.
ENDFORM.
