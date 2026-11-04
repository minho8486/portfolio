*&---------------------------------------------------------------------*
*& Include          ZRA3MM6001F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form create_container_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GO_CON
*&      --> GO_ALV
*&---------------------------------------------------------------------*


FORM create_container_0100  USING    po_dock TYPE REF TO cl_gui_docking_container
                                     po_alv TYPE REF TO cl_gui_alv_grid.
  IF po_dock IS NOT INITIAL.
    RETURN.
  ENDIF.

  CREATE OBJECT po_dock
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


*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.


  ENDIF.

  PERFORM create_alv USING po_dock po_alv.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form create_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PO_DOCK
*&      --> PO_ALV
*&---------------------------------------------------------------------*


FORM create_alv  USING    po_dock TYPE REF TO cl_gui_docking_container
                          po_alv TYPE REF TO cl_gui_alv_grid.
  CREATE OBJECT po_alv
    EXPORTING


*     i_shellstyle      = 0
*     i_lifetime        =


      i_parent          = po_dock


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


*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.


  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_FCAT
*&      --> GO_ALV
*&      --> P_
*&      --> GT_LIST
*&      --> GS_LAYO
*&---------------------------------------------------------------------*


FORM display_alv  TABLES   t_fcat STRUCTURE lvc_s_fcat
                  USING    po_alv TYPE REF TO cl_gui_alv_grid
                           VALUE(p_sname)
                           pt_list
                           ps_layo TYPE lvc_s_layo.
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


*   Implement suitable error handling here


  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_layo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_LAYO
*&---------------------------------------------------------------------*


FORM set_layo  CHANGING VALUE(cs_layo) TYPE lvc_s_layo.
  cs_layo-cwidth_opt = 'X'.
  cs_layo-zebra = 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_FCAT
*&---------------------------------------------------------------------*


FORM set_fcat  TABLES   t_fcat STRUCTURE lvc_s_fcat.
  CLEAR t_fcat[].

  DATA: lt_field LIKE gt_field,
        ls_field LIKE gs_field,
        ls_fcat LIKE lvc_s_fcat.

  PERFORM set_field CHANGING lt_field.

  LOOP AT lt_field INTO ls_field.

    PERFORM set_field_catalog: TABLES t_fcat
                               USING 'FIELDNAME' ls_field '',
                               TABLES t_fcat
                               USING 'NO_OUT' 'X' 'X'.

    CLEAR ls_field.
  ENDLOOP.

  READ TABLE t_fcat[] WITH KEY fieldname = 'POQUA' INTO ls_fcat.
  IF sy-subrc <> 0.
    PERFORM set_field_catalog: TABLES t_fcat
                               USING 'FIELDNAME' 'POQUA' '',
                               TABLES t_fcat
                               USING 'COLTEXT' '구매수량'(f01) 'X'.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_field_catalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> T_FCAT
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*


FORM set_field_catalog  TABLES   t_fcat STRUCTURE lvc_s_fcat
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
*& Form set_field
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LT_FIELD
*&---------------------------------------------------------------------*


FORM set_field  CHANGING ct_field LIKE gt_field.
  IF so_batid[] IS INITIAL AND so_plaid[] IS INITIAL.
    APPEND 'PLAID' TO ct_field.
    APPEND 'PNAME' TO ct_field.
    APPEND 'BATID' TO ct_field.
    APPEND 'HSDAT' TO ct_field.
  ELSEIF so_batid[] IS INITIAL.
    APPEND 'BATID' TO ct_field.
    APPEND 'HSDAT' TO ct_field.
    APPEND 'POQUA' TO ct_field.
  ELSEIF so_plaid[] IS INITIAL.
    APPEND 'PLAID' TO ct_field.
    APPEND 'PNAME' TO ct_field.
    APPEND 'POQUA' TO ct_field.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_default
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SO_MATID
*&---------------------------------------------------------------------*


FORM set_default  TABLES   so_matid STRUCTURE so_matid.
  so_matid-sign = 'I'.
  so_matid-option = 'BT'.
  so_matid-low = 'M20080000000001'.
  so_matid-high = 'M20080000000009'.
  APPEND so_matid.

  CONCATENATE icon_information TEXT-i01
    INTO gv_info1 SEPARATED BY space.
  CONCATENATE icon_information TEXT-i02
    INTO gv_info2 SEPARATED BY space.
  CONCATENATE icon_information TEXT-i03
    INTO gv_info3 SEPARATED BY space.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_cond
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SO_MATID
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM check_matid  USING    po_matid LIKE so_matid[]
                 CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  IF po_matid IS INITIAL.
    cv_subrc = 4.
    MESSAGE i001(zmcn11603) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_list_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SO_MATID
*&      --> SO_PLAID
*&      --> SO_BATID
*&      --> SO_HSDAT
*&      <-- GT_LIST
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM get_list_data  USING    pt_matid LIKE so_matid[]
                             pt_plaid LIKE so_plaid[]
                             pt_batid LIKE so_batid[]
                             pt_hsdat LIKE so_hsdat[]
                             VALUE(p_cflag) LIKE gv_cflag
                    CHANGING ct_list LIKE gt_list
                             VALUE(cv_subrc) TYPE sy-subrc.
  DATA: lt_binfo LIKE gt_binfo,
        lt_poqua LIKE gt_poqua.

  CASE p_cflag.
    WHEN 'M'.
      PERFORM get_when_m USING pt_matid pt_hsdat
                         CHANGING ct_list cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.

      PERFORM get_poqua CHANGING lt_poqua.
    WHEN 'B'.
      PERFORM get_when_b USING pt_matid pt_batid pt_hsdat
                         CHANGING ct_list cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.
    WHEN 'P'.
      PERFORM get_when_p USING pt_matid pt_plaid pt_hsdat
                         CHANGING ct_list cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.
    WHEN 'D'.
      PERFORM get_when_d USING pt_matid pt_plaid pt_batid pt_hsdat
                         CHANGING ct_list cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.
  ENDCASE.

  PERFORM loop_at_list USING    lt_poqua p_cflag
                       CHANGING ct_list cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_hsdat_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PT_HSDAT
*&      <-- LT_BINFO
*&---------------------------------------------------------------------*


FORM get_hsdat_info  USING    pt_matid LIKE so_matid[]
                              pt_hsdat LIKE so_hsdat[]
                     CHANGING ct_binfo LIKE gt_binfo
                              VALUE(cv_subrc) TYPE sy-subrc.
  IF pt_hsdat IS INITIAL.
    RETURN.
  ENDIF.

  SELECT matid batid hsdat
    FROM zta3mm0003
    INTO CORRESPONDING FIELDS OF TABLE ct_binfo
   WHERE matid IN pt_matid
     AND hsdat IN pt_hsdat.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i002(zmcn11603) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_inventory_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PT_MATID
*&      --> PT_PLAID
*&      --> PT_BATID
*&      <-- CT_LIST
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_when_d  USING    pt_matid LIKE so_matid[]
                          pt_plaid LIKE so_plaid[]
                          pt_batid LIKE so_batid[]
                          pt_hsdat LIKE so_hsdat[]
                 CHANGING ct_list LIKE gt_list
                          VALUE(cv_subrc) TYPE sy-subrc.

  SELECT a~matid a~plaid a~batid SUM( labst ) AS labst SUM( scrap ) AS scrap
    FROM zta3mm0002 AS a
   INNER JOIN zta3mm0001 AS b
      ON a~matid = b~matid
   INNER JOIN zta3mm0003 AS c
      ON a~matid = c~matid
     AND a~batid = c~batid
    INTO CORRESPONDING FIELDS OF TABLE ct_list
   WHERE a~matid IN pt_matid
     AND a~plaid IN pt_plaid
     AND a~batid IN pt_batid
     AND c~hsdat IN pt_hsdat
   GROUP BY a~matid a~batid a~plaid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i002(zmcn11603) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form compare_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_BINFO
*&      <-- CT_LIST
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM compare_info  USING    pt_binfo LIKE gt_binfo
                   CHANGING ct_list LIKE gt_list
                            VALUE(cv_subrc) TYPE sy-subrc.
  DATA: ls_binfo LIKE gs_binfo,
        ls_list  LIKE gs_list.

  LOOP AT ct_list INTO ls_list.
    READ TABLE pt_binfo WITH KEY matid = ls_list-matid batid = ls_list-batid
                        TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      DELETE ct_list.
    ENDIF.
  ENDLOOP.

  IF ct_list IS INITIAL.
    cv_subrc = 4.
    MESSAGE i002(zmcn11603) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_cflag
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SO_MATID[]
*&      --> SO_PLAID[]
*&      --> SO_BATID[]
*&      <-- GV_CFLAG
*&---------------------------------------------------------------------*


FORM set_cflag  USING    pt_matid LIKE so_matid[]
                         pt_plaid LIKE so_plaid[]
                         pt_batid LIKE so_batid[]
                CHANGING VALUE(cv_cflag) LIKE gv_cflag.
  CLEAR cv_cflag.

  IF so_batid[] IS INITIAL AND so_plaid[] IS INITIAL.
    cv_cflag = 'M'.
  ELSEIF so_batid[] IS INITIAL.
    cv_cflag = 'P'.
  ELSEIF so_plaid[] IS INITIAL.
    cv_cflag = 'B'.
  ELSE.
    cv_cflag = 'D'.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_when_m
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PT_MATID
*&      --> PT_HSDAT
*&      <-- CT_LIST
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_when_m  USING    pt_matid LIKE so_matid[]
                          pt_hsdat LIKE so_hsdat[]
                 CHANGING ct_list LIKE gt_list
                          VALUE(cv_subrc) TYPE sy-subrc.

  SELECT a~matid SUM( labst ) AS labst SUM( scrap ) AS scrap
    FROM zta3mm0002 AS a
   INNER JOIN zta3mm0003 AS c
      ON a~matid = c~matid
     AND a~batid = c~batid
    INTO CORRESPONDING FIELDS OF TABLE ct_list
   WHERE a~matid IN pt_matid
     AND c~hsdat IN pt_hsdat
   GROUP BY a~matid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i002(zmcn11603) INTO gv_messg.
    RETURN.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_when_b
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PT_MATID
*&      --> PT_BATID
*&      --> PT_HSDAT
*&      <-- CT_LIST
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_when_b  USING    pt_matid LIKE so_matid[]
                          pt_batid LIKE so_batid[]
                          pt_hsdat LIKE so_hsdat[]
                 CHANGING ct_list LIKE gt_list
                          VALUE(cv_subrc) TYPE sy-subrc.

  SELECT a~matid a~batid SUM( labst ) AS labst SUM( scrap ) AS scrap
    FROM zta3mm0002 AS a
   INNER JOIN zta3mm0001 AS b
      ON a~matid = b~matid
   INNER JOIN zta3mm0003 AS c
      ON a~matid = c~matid
     AND a~batid = c~batid
    INTO CORRESPONDING FIELDS OF TABLE ct_list
   WHERE a~matid IN pt_matid
     AND a~batid IN pt_batid
     AND c~hsdat IN pt_hsdat
   GROUP BY a~matid a~batid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i002(zmcn11603) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_when_p
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PT_MATID
*&      --> PT_PLAID
*&      --> PT_HSDAT
*&      <-- CT_LIST
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_when_p  USING    pt_matid LIKE so_matid[]
                          pt_plaid LIKE so_plaid[]
                          pt_hsdat LIKE so_hsdat[]
                 CHANGING ct_list LIKE gt_list
                          VALUE(cv_subrc) TYPE sy-subrc.

  SELECT a~matid a~plaid SUM( labst ) AS labst SUM( scrap ) AS scrap
    FROM zta3mm0002 AS a
   INNER JOIN zta3mm0001 AS b
      ON a~matid = b~matid
   INNER JOIN zta3mm0003 AS c
      ON a~matid = c~matid
     AND a~batid = c~batid
    INTO CORRESPONDING FIELDS OF TABLE ct_list
   WHERE a~matid IN pt_matid
     AND a~plaid IN pt_plaid
     AND c~hsdat IN pt_hsdat
   GROUP BY a~matid a~plaid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i002(zmcn11603) INTO gv_messg.
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


FORM loop_at_list  USING    pt_poqua LIKE gt_poqua
                            VALUE(p_cflag) LIKE gv_cflag
                   CHANGING ct_list LIKE gt_list
                            cv_subrc TYPE sy-subrc.
  DATA: ls_list LIKE gs_list.

  LOOP AT ct_list INTO ls_list.
    IF p_cflag = 'M'.
      PERFORM set_poqua USING pt_poqua
                        CHANGING ct_list ls_list.
    ENDIF.

    PERFORM get_mat_info USING ls_list-matid
                         CHANGING ls_list-mtext ls_list-meins cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.

    PERFORM get_pname USING ls_list-plaid
                      CHANGING ls_list-pname cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.

    PERFORM get_hsdat USING ls_list-batid
                      CHANGING ls_list-hsdat cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.

    MODIFY ct_list FROM ls_list.
    CLEAR ls_list.
  ENDLOOP.
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


FORM get_mat_info  USING    VALUE(p_matid) TYPE zta3mm0001-matid
                   CHANGING VALUE(cv_mtext) TYPE zta3mm0001_t-mtext
                            VALUE(cv_meins) TYPE zta3mm0001-meins
                            VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE mtext
    FROM zta3mm0001_t
    INTO cv_mtext
   WHERE matid = p_matid
     AND spras = sy-langu.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i002(zmcn11601) WITH p_matid INTO gv_messg.
    RETURN.
  ENDIF.

  SELECT SINGLE meins
    FROM zta3mm0001
    INTO cv_meins
   WHERE matid = p_matid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i002(zmcn11601) WITH p_matid INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_pname
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_LIST_PLAID
*&      <-- LS_LIST_PNAME
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_pname  USING    VALUE(p_plaid) TYPE zta3mm0006-plaid
                CHANGING VALUE(cv_pname) TYPE zta3mm0006_t-pname
                         VALUE(cv_subrc) TYPE sy-subrc.
  IF p_plaid IS INITIAL.
    RETURN.
  ENDIF.

  SELECT SINGLE pname
    FROM zta3mm0006_t
    INTO cv_pname
   WHERE plaid = p_plaid
     AND spras = sy-langu.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i003(zmcn11601) WITH p_plaid INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_hsdat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_LIST_BATID
*&      <-- LS_LIST_HSDAT
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_hsdat  USING    VALUE(p_batid) TYPE zta3mm0003-batid
                CHANGING VALUE(cv_hsdat) TYPE zta3mm0003-hsdat
                         VALUE(cv_subrc) TYPE sy-subrc.
  IF p_batid IS INITIAL.
    RETURN.
  ENDIF.

  SELECT SINGLE hsdat
    FROM zta3mm0003
    INTO cv_hsdat
   WHERE batid = p_batid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i004(zmcn11601) WITH p_batid INTO gv_messg.
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


FORM show_message  CHANGING cv_messg LIKE gv_messg
                            cv_messt LIKE gv_messt
                            cv_subrc LIKE sy-subrc.
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


*&---------------------------------------------------------------------*
*& Form get_poqua
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_POQUA
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_poqua  CHANGING ct_poqua LIKE gt_poqua.
  SELECT a~matid SUM( orcnt ) AS poqua
    FROM zta3mm0009 AS a
   INNER JOIN zta3mm0008 AS b
      ON a~ordid = b~ordid
    INTO CORRESPONDING FIELDS OF TABLE ct_poqua
   WHERE b~bstat = 'B2'
   GROUP BY a~matid.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_poqua
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PT_POQUA
*&      <-- CT_LIST
*&---------------------------------------------------------------------*


FORM set_poqua  USING    pt_poqua LIKE gt_poqua
                CHANGING ct_list LIKE gt_list
                         VALUE(cs_list) LIKE gs_list.
  DATA: ls_poqua LIKE gs_poqua.

  READ TABLE pt_poqua WITH KEY matid = cs_list-matid INTO ls_poqua.
  IF sy-subrc = 0.
    cs_list-poqua = ls_poqua-poqua.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_cond
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SO_MATID
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM check_cond  USING    VALUE(ps_hsdat) LIKE so_hsdat
                 CHANGING VALUE(cv_subrc) TYPE sy-subrc.

  IF ps_hsdat-low > sy-datum or ps_hsdat-high > sy-datum.
    cv_subrc = 4.
    MESSAGE i023(zmcn11601) INTO gv_messg.
  ENDIF.
ENDFORM.
