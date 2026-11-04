*&---------------------------------------------------------------------*
*& Include          MZA3MM6001F01
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

  SET HANDLER lcl_handler=>on_hotspot_click FOR po_alv.

ENDFORM.

FORM display_alv  TABLES   t_fcat STRUCTURE lvc_s_fcat
                           t_sort STRUCTURE lvc_s_sort
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
      it_sort                       = t_sort[]


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

FORM set_layout_0100  CHANGING VALUE(cs_layo) TYPE lvc_s_layo.
  CLEAR cs_layo.

  cs_layo-cwidth_opt = 'X'.
  cs_layo-sel_mode = 'A'.
  cs_layo-excp_fname = 'LIGHT'.
  cs_layo-excp_led = 'X'.
  cs_layo-zebra = 'X'.
ENDFORM.

FORM set_fcat_0100  TABLES   t_fcat STRUCTURE lvc_s_fcat.
  CLEAR t_fcat[].

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'ERZET' '',
                    TABLES t_fcat
                    USING 'NO_OUT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'AEZET' '',
                    TABLES t_fcat
                    USING 'NO_OUT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'BKTXT' '',
                    TABLES t_fcat
                    USING 'NO_OUT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'DFLAG' '',
                    TABLES t_fcat
                    USING 'NO_OUT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'MATID' '',
                    TABLES t_fcat
                    USING 'NO_OUT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'PLAID' '',
                    TABLES t_fcat
                    USING 'NO_OUT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'EREID' '',
                    TABLES t_fcat
                    USING 'NO_OUT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'AEEID' '',
                    TABLES t_fcat
                    USING 'NO_OUT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'LIGHT' '',
                    TABLES t_fcat
                    USING 'COLTEXT' '배치관리상태'(t01) 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'BATID' '',
                    TABLES t_fcat
                    USING 'HOTSPOT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'MTEXT' '',
                    TABLES t_fcat
                    USING 'HOTSPOT' 'X' 'X'.

  PERFORM set_fcat: TABLES t_fcat
                    USING 'FIELDNAME' 'PNAME' '',
                    TABLES t_fcat
                    USING 'HOTSPOT' 'X' 'X'.
ENDFORM.

FORM set_default  CHANGING VALUE(cs_cond) TYPE zsa3mm6001.
  CLEAR cs_cond.

  cs_cond-erdat_s = sy-datum.
  cs_cond-matid = 'M20080000000001'.
  cs_cond-plaid = 'P000000001'.

  gs_atbar = 'NEXT'.
  APPEND gs_atbar TO gt_atbar.
  CLEAR gs_atbar.
ENDFORM.

FORM search_0100 .
  PERFORM check_condition USING gs_cond
                          CHANGING gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM get_mtext USING gs_cond-matid
                    CHANGING gs_cond-mtext gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM get_pname USING gs_cond-plaid
                    CHANGING gs_cond-pname gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM get_list USING gs_cond
                   CHANGING gt_list gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  CLEAR gs_ucond.
  gs_ucond = gs_cond.

ENDFORM.

FORM search_list  USING    VALUE(ps_cond) TYPE zsa3mm6001
                        pt_erange LIKE gt_range
                        pt_arange LIKE gt_range
               CHANGING ct_list LIKE gt_list
                        VALUE(cv_subrc) TYPE sy-subrc.
  SELECT a~batid a~matid plaid stoid labst scrap
         a~erdat a~aedat c~meins b~dflag
    FROM zta3mm0002 AS a
   INNER JOIN zta3mm0003 AS b
      ON a~matid = b~matid
     AND a~batid = b~batid
   INNER JOIN zta3mm0001 AS c
      ON a~matid = c~matid
    INTO CORRESPONDING FIELDS OF TABLE ct_list
   WHERE a~erdat IN pt_erange
     AND a~aedat IN pt_arange
     AND a~matid = ps_cond-matid.

  IF ps_cond-plaid IS NOT INITIAL.
    DELETE ct_list WHERE plaid <> ps_cond-plaid.
  ENDIF.

  IF ps_cond-stoid IS NOT INITIAL.
    DELETE ct_list WHERE stoid <> ps_cond-stoid.
  ENDIF.

  IF ps_cond-batid IS NOT INITIAL.
    DELETE ct_list WHERE batid <> ps_cond-batid.
  ENDIF.

  IF ct_list IS INITIAL.
    cv_subrc = 4.
    MESSAGE i001(zmcn11601) INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.

  PERFORM at_loop CHANGING ct_list cv_subrc.
ENDFORM.

FORM set_erange  USING    VALUE(p_erdat_s) TYPE zsa3mm6001-erdat_s
                          VALUE(p_erdat_e) TYPE zsa3mm6001-erdat_e
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

FORM at_loop  CHANGING ct_list LIKE gt_list
                       VALUE(cv_subrc) TYPE sy-subrc.
  DATA ls_list LIKE LINE OF gt_list.

  LOOP AT ct_list INTO ls_list.
    PERFORM get_mtext USING ls_list-matid
                      CHANGING ls_list-mtext cv_subrc.
    IF cv_subrc <> 0.
      EXIT.
    ENDIF.
    PERFORM get_pname USING ls_list-plaid
                      CHANGING ls_list-pname cv_subrc.
    IF cv_subrc <> 0.
      EXIT.
    ENDIF.
    PERFORM set_light USING ls_list-dflag
                      CHANGING ls_list-light.

    MODIFY ct_list FROM ls_list.
    CLEAR ls_list.
  ENDLOOP.

  PERFORM show_message USING gv_messg gv_messt cv_subrc.
ENDFORM.

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
    MESSAGE i002(zmcn11601) WITH gs_cond-matid INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.
ENDFORM.

FORM get_pname  USING    VALUE(p_plaid) TYPE zsa3mm6002-plaid
                CHANGING VALUE(cv_pname) TYPE zsa3mm6002-pname
                         VALUE(cv_subrc) TYPE sy-subrc.
  CLEAR cv_pname.

  IF p_plaid IS INITIAL.
    RETURN.
  ENDIF.

  call function 'ZFA3MM6003'
    EXPORTING
      iv_plaid = p_plaid
      iv_spras = '3'
    IMPORTING
      ev_pname = cv_pname
      ev_subrc = cv_subrc.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i003(zmcn11601) WITH gs_cond-plaid INTO gv_messg.
    gv_messt = 'I'.
  ENDIF.
ENDFORM.

FORM show_message  CHANGING cv_messg LIKE gv_messg
                            cv_messt LIKE gv_messt
                            cv_subrc TYPE sy-subrc.
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

FORM set_light  USING    VALUE(p_dflag) TYPE zsa3mm6002-dflag
                CHANGING VALUE(cv_light) TYPE zsa3mm6002-light.
  IF p_dflag = 'X'.
    cv_light = '1'.
  ELSE.
    cv_light = '3'.
  ENDIF.
ENDFORM.

FORM show_bat_info  USING    VALUE(ps_list) TYPE zsa3mm6002
                    CHANGING VALUE(cs_binfo) TYPE zsa3mm6003
                             VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE matid batid hsdat qualt dflag bktxt
    FROM zta3mm0003
    INTO CORRESPONDING FIELDS OF cs_binfo
   WHERE matid = ps_list-matid
     AND batid = ps_list-batid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i004(zmcn11601) WITH ps_list-batid.
    RETURN.
  ENDIF.

  PERFORM get_mtext USING ps_list-matid
                    CHANGING cs_binfo-mtext cv_subrc.
  IF cv_subrc <> 0.
    MESSAGE i002(zmcn11601) WITH ps_list-matid INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.

  PERFORM get_domain_text USING 'ZDA3_MM_QUALT' cs_binfo-qualt
                          CHANGING cs_binfo-qualt_t.
ENDFORM.

FORM show_mat_info  USING    VALUE(ps_list) TYPE zsa3mm6002
                    CHANGING VALUE(cs_minfo) TYPE zsa3mm6004
                             VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE matid mtype matgr stway meins maqua
    FROM zta3mm0001
    INTO CORRESPONDING FIELDS OF cs_minfo
   WHERE matid = ps_list-matid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i002(zmcn11601) WITH ps_list-matid.
    RETURN.
  ENDIF.

  PERFORM get_mtext USING ps_list-matid
                    CHANGING cs_minfo-mtext cv_subrc.
  IF cv_subrc <> 0.
    MESSAGE i002(zmcn11601) WITH ps_list-matid INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.

  PERFORM get_domain_text USING 'ZDA3_MM_MTYPE' cs_minfo-mtype
                          CHANGING cs_minfo-mtype_t.

  PERFORM get_domain_text USING 'ZDA3_MM_MATGR' cs_minfo-matgr
                          CHANGING cs_minfo-matgr_t.

  PERFORM get_domain_text USING 'ZDA3_MM_STWAY' cs_minfo-stway
                          CHANGING cs_minfo-stway_t.
ENDFORM.

FORM get_domain_text  USING    VALUE(p_domname)
                               p_value
                      CHANGING cv_ddtext TYPE ddtext.
  DATA: lv_domname TYPE dd07v-domname,
        lv_value   TYPE dd07v-domvalue_l.

  lv_domname = p_domname.
  lv_value = p_value.

  call function 'ZFA3MM6001'
    EXPORTING
      iv_domname = lv_domname
      iv_value   = lv_value
    IMPORTING
      ev_ddtext  = cv_ddtext.

ENDFORM.

FORM show_plant_info  USING    VALUE(ps_list) TYPE zsa3mm6002
                      CHANGING VALUE(cs_pinfo) TYPE zsa3mm6005
                               VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE plaid empid ptlno cityc npost stras
                faxno pflag
    FROM zta3mm0006
    INTO CORRESPONDING FIELDS OF cs_pinfo
   WHERE plaid = ps_list-plaid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i003(zmcn11601) WITH ps_list-plaid INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.

  PERFORM get_pname USING ps_list-plaid
                    CHANGING cs_pinfo-pname cv_subrc.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i003(zmcn11601) WITH ps_list-plaid INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.

  PERFORM get_empnm USING cs_pinfo-empid
                    CHANGING cs_pinfo-empnm cv_subrc.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i005(zmcn11601) WITH cs_pinfo-empid INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.

  PERFORM get_ctext USING cs_pinfo-cityc
                    CHANGING cs_pinfo-ctext cv_subrc.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i006(zmcn11601) WITH cs_pinfo-cityc INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.
ENDFORM.

FORM get_empnm  USING    VALUE(p_empid) TYPE zta3hr0002-empid
                CHANGING VALUE(cv_empnm) TYPE zta3hr0002-empnm
                         VALUE(cv_subrc) TYPE sy-subrc.
  call function 'ZFA3MM6004'
    EXPORTING
      iv_empid = p_empid
    IMPORTING
      ev_empnm = cv_empnm
      ev_subrc = cv_subrc.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
  ENDIF.
ENDFORM.

FORM get_ctext  USING    VALUE(p_cityc) TYPE zta3hr0003-cityc
                CHANGING VALUE(cv_ctext) TYPE zta3hr0003_t-ctext
                         VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE ctext
    FROM zta3hr0003_t
    INTO cv_ctext
   WHERE cityc = p_cityc.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    RETURN.
  ENDIF.
ENDFORM.

FORM enter_0100 .
  PERFORM get_mtext USING gs_cond-matid
                    CHANGING gs_cond-mtext gv_subrc.
  IF gv_subrc <> 0.
    CLEAR gv_subrc.
    MESSAGE i002(zmcn11601) WITH gs_cond-matid.
    RETURN.
  ENDIF.

  PERFORM get_pname USING gs_cond-plaid
                    CHANGING gs_cond-pname gv_subrc.
  IF gv_subrc <> 0.
    CLEAR gv_subrc.
    MESSAGE i003(zmcn11601) WITH gs_cond-plaid.
    RETURN.
  ENDIF.

ENDFORM.

FORM get_list  USING    VALUE(ps_cond) TYPE zsa3mm6001
               CHANGING ct_list LIKE gt_list
                        VALUE(cv_subrc) TYPE sy-subrc.
  CLEAR ct_list.

  DATA: lt_erange TYPE RANGE OF zsa3hr0001-erdat,
        lt_arange TYPE RANGE OF zsa3hr0001-aedat.

  PERFORM set_erange USING ps_cond-erdat_s ps_cond-erdat_e
                     CHANGING lt_erange.
  PERFORM set_arange USING ps_cond-aedat_s ps_cond-aedat_e
                     CHANGING lt_arange.

  PERFORM search_list USING ps_cond lt_erange lt_arange
                      CHANGING ct_list cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.
ENDFORM.

FORM check_condition  USING    VALUE(ps_cond) TYPE zsa3mm6001
                      CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  PERFORM check_erdat USING ps_cond-erdat_s ps_cond-erdat_e
                      CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  PERFORM check_aedat USING ps_cond-aedat_s ps_cond-aedat_e
                      CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  PERFORM check_plant_stoid USING ps_cond-plaid ps_cond-stoid
                            CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.
ENDFORM.

FORM check_erdat  USING    VALUE(p_erdat_s) TYPE zsa3mm6001-erdat_s
                           VALUE(p_erdat_e) TYPE zsa3mm6001-erdat_e
                  CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_erdat TYPE datum.

  IF p_erdat_s > sy-datum OR p_erdat_e > sy-datum.
    cv_subrc = 4.
    MESSAGE i023(zmcn11601) INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.

  lv_erdat = '20180101'.

  IF p_erdat_s < lv_erdat.
    cv_subrc = 4.
    MESSAGE i024(zmcn11601) INTO gv_messg.
    gv_messt = 'I'.
  ENDIF.

  IF p_erdat_e IS NOT INITIAL.

    IF p_erdat_e < lv_erdat.
      cv_subrc = 4.
      MESSAGE i024(zmcn11601) INTO gv_messg.
      gv_messt = 'I'.
    ENDIF.

    lv_erdat = p_erdat_s + 14.

    IF p_erdat_s > p_erdat_e.
      cv_subrc = 4.
      MESSAGE i007(zmcn11601) INTO gv_messg.
      gv_messt = 'I'.
      RETURN.
    ENDIF.

    IF lv_erdat < p_erdat_e.
      cv_subrc = 4.
      MESSAGE i008(zmcn11601) INTO gv_messg.
      gv_messt = 'I'.
      RETURN.
    ENDIF.

  ENDIF.
ENDFORM.

FORM check_aedat  USING    VALUE(p_aedat_s) TYPE zsa3mm6001-aedat_s
                           VALUE(p_aedat_e) TYPE zsa3mm6001-aedat_e
                  CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_aedat TYPE datum.

  IF p_aedat_s > sy-datum OR p_aedat_s > sy-datum.
    cv_subrc = 4.
    MESSAGE i023(zmcn11601) INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.

  lv_aedat = '20180101'.

  IF p_aedat_s IS NOT INITIAL AND p_aedat_s < lv_aedat.
    cv_subrc = 4.
    MESSAGE i024(zmcn11601) INTO gv_messg.
    gv_messt = 'I'.
  ENDIF.

  IF p_aedat_e IS NOT INITIAL AND p_aedat_e < lv_aedat.
    cv_subrc = 4.
    MESSAGE i024(zmcn11601) INTO gv_messg.
    gv_messt = 'I'.
  ENDIF.

  lv_aedat = p_aedat_s + 14.

  IF p_aedat_s IS NOT INITIAL AND p_aedat_e IS NOT INITIAL.
    IF p_aedat_s > p_aedat_e.
      cv_subrc = 1.
      MESSAGE i007(zmcn11601) INTO gv_messg.
      gv_messt = 'I'.
      RETURN.
    ENDIF.
    IF lv_aedat < p_aedat_e.
      cv_subrc = 2.
      MESSAGE i008(zmcn11601) INTO gv_messg.
      gv_messt = 'I'.
      RETURN.
    ENDIF.
  ELSEIF p_aedat_e IS NOT INITIAL.
    cv_subrc = 1.
    MESSAGE i007(zmcn11601) INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.

ENDFORM.

FORM check_plant_stoid  USING    VALUE(p_plaid) TYPE zta3mm0006-plaid
                                 VALUE(p_stoid) TYPE zta3mm0007-stoid
                        CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  IF p_plaid IS INITIAL AND p_stoid IS NOT INITIAL.
    cv_subrc = 4.
    MESSAGE i009(zmcn11601) INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.
ENDFORM.

FORM new_0100 .
  PERFORM set_for_next_mode.
  CALL SCREEN 200.
  CLEAR: gs_new.
ENDFORM.

FORM get_selected_row  USING    pt_list LIKE gt_list
                                po_alv TYPE REF TO cl_gui_alv_grid
                       CHANGING VALUE(cs_list) LIKE gs_list
                                VALUE(cv_subrc) TYPE sy-subrc.

  call function 'ZFA3MM6002'
    EXPORTING
      it_data  = pt_list
      io_alv   = po_alv
    IMPORTING
      es_data  = cs_list
      ev_subrc = cv_subrc.

ENDFORM.

FORM update_0100 .
  DATA ls_list LIKE LINE OF gt_list.

  PERFORM get_selected_row USING gt_list go_alv
                           CHANGING ls_list gv_subrc.
  IF gv_subrc <> 0.
    CLEAR gv_subrc.
    MESSAGE i016(zmcn11601).
    RETURN.
  ENDIF.

  PERFORM check_data USING ls_list
                     CHANGING gv_subrc.
  IF gv_subrc <> 0.
    CLEAR gv_subrc.
    MESSAGE i017(zmcn11601).
    RETURN.
  ENDIF.

  PERFORM get_inventory_data USING ls_list
                             CHANGING gs_update gv_subrc.
  IF gv_subrc <> 0.
    CLEAR gv_subrc.
    RETURN.
  ENDIF.

  CALL SCREEN 300.
  CLEAR gs_update.
ENDFORM.

FORM insert_0200 .
  PERFORM check_insert_info USING gs_new
                            CHANGING gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM ask_again USING TEXT-q01
                    CHANGING gv_answer.
  IF gv_answer <> '1'.
    CLEAR gv_answer.
    RETURN.
  ENDIF.
  CLEAR gv_answer.

  PERFORM get_mtext USING gs_new-matid
                    CHANGING gs_new-mtext gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM get_meins USING gs_new-matid
                    CHANGING gs_new-meins_l gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM get_pname USING gs_new-plaid
                    CHANGING gs_new-pname gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM insert_entity CHANGING gs_new
                                 gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  IF gs_ucond IS NOT INITIAL.
    PERFORM get_list USING gs_ucond
                     CHANGING gt_list gv_subrc.
    IF gv_subrc <> 0.
      PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
      RETURN.
    ENDIF.
  ENDIF.

ENDFORM.

FORM check_insert_info  USING    VALUE(ps_new) TYPE zsa3mm6006
                        CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  PERFORM check_required USING ps_new-labst ps_new-scrap
                         CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  PERFORM check_matid USING ps_new-matid
                      CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  PERFORM check_plaid USING ps_new-plaid
                      CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  PERFORM check_stoid USING ps_new-plaid ps_new-stoid
                      CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  PERFORM check_batid USING ps_new-matid ps_new-batid
                      CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  PERFORM check_quantity USING ps_new-matid ps_new-batid
                               ps_new-labst ps_new-scrap
                         CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  PERFORM check_inventory_key USING ps_new-matid ps_new-batid
                                    ps_new-plaid ps_new-stoid
                              CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

  PERFORM check_storage_type USING ps_new-matid ps_new-batid
                                   ps_new-plaid ps_new-stoid
                             CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.
ENDFORM.

FORM enter.
  PERFORM get_mtext USING gs_new-matid
                    CHANGING gs_new-mtext gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM get_meins USING gs_new-matid
                    CHANGING gs_new-meins_l gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM get_pname USING gs_new-plaid
                    CHANGING gs_new-pname gv_subrc.
  IF gv_subrc <> 0.
    CLEAR gv_subrc.
    MESSAGE i003(zmcn11601) WITH gs_new-plaid.
    RETURN.
  ENDIF.
ENDFORM.

FORM check_matid  USING    VALUE(p_matid) TYPE zta3mm0001-matid
                  CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_matid TYPE zta3mm0001-matid.

  SELECT SINGLE matid
    FROM zta3mm0001
    INTO lv_matid
   WHERE matid = p_matid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i002(zmcn11601) WITH p_matid INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.

FORM check_plaid  USING    VALUE(p_plaid) TYPE zta3mm0006-plaid
                  CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_plaid TYPE zta3mm0006-plaid.

  SELECT SINGLE plaid
    FROM zta3mm0006
    INTO lv_plaid
   WHERE plaid = p_plaid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i003(zmcn11601) WITH p_plaid INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.

FORM check_stoid  USING    VALUE(p_plaid) TYPE zta3mm0006-plaid
                           VALUE(p_stoid) TYPE zta3mm0007-stoid
                  CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_stoid TYPE zta3mm0007-stoid.

  SELECT SINGLE stoid
    FROM zta3mm0007
    INTO lv_stoid
   WHERE plaid = p_plaid
     AND stoid = p_stoid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i010(zmcn11601) WITH p_plaid p_stoid INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.

FORM check_batid  USING    VALUE(p_matid) TYPE zta3mm0001-matid
                           VALUE(p_batid) TYPE zta3mm0003-batid
                  CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_batid TYPE zta3mm0003-batid.

  SELECT SINGLE batid
    FROM zta3mm0003
    INTO lv_batid
   WHERE matid = p_matid
     AND batid = p_batid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i011(zmcn11601) WITH p_matid p_batid INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.

FORM check_inventory_key  USING    VALUE(p_matid) TYPE zta3mm0001-matid
                                   VALUE(p_batid) TYPE zta3mm0003-batid
                                   VALUE(p_plaid) TYPE zta3mm0006-plaid
                                   VALUE(p_stoid) TYPE zta3mm0007-stoid
                          CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_batid TYPE zta3mm0003-batid.

  SELECT SINGLE batid
    FROM zta3mm0002
    INTO lv_batid
   WHERE matid = p_matid
     AND batid = p_batid
     AND plaid = p_plaid
     AND stoid = p_stoid.
  IF sy-subrc = 0.
    cv_subrc = 4.
    MESSAGE i012(zmcn11601) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.

FORM insert_entity  CHANGING VALUE(cs_new) TYPE zsa3mm6006
                             VALUE(cv_subrc) TYPE sy-subrc.
  DATA ls_zta3mm0002 TYPE zta3mm0002.

  ls_zta3mm0002-batid = cs_new-batid.
  ls_zta3mm0002-matid = cs_new-matid.
  ls_zta3mm0002-plaid = cs_new-plaid.
  ls_zta3mm0002-stoid = cs_new-stoid.
  ls_zta3mm0002-labst = cs_new-labst.
  ls_zta3mm0002-scrap = cs_new-scrap.
  ls_zta3mm0002-erdat = sy-datum.
  ls_zta3mm0002-erzet = sy-uzeit.
  ls_zta3mm0002-aedat = sy-datum.
  ls_zta3mm0002-aezet = sy-uzeit.
  ls_zta3mm0002-bktxt = cs_new-bktxt.

  PERFORM get_mapping_id USING sy-uname
                         CHANGING ls_zta3mm0002-ereid.
  PERFORM get_mapping_id USING sy-uname
                         CHANGING ls_zta3mm0002-aeeid.

  INSERT zta3mm0002 FROM ls_zta3mm0002.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    ROLLBACK WORK.
    MESSAGE i014(zmcn11601) INTO gv_messg.
    gv_messt = 'E'.
    RETURN.
  ENDIF.

  COMMIT WORK.
  MESSAGE i013(zmcn11601) INTO gv_messg.
  gv_messt = 'S'.

  PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.

  MOVE-CORRESPONDING ls_zta3mm0002 TO cs_new.
  PERFORM set_for_ins_mode.
ENDFORM.

FORM get_meins  USING    VALUE(p_matid) TYPE zta3mm0001-matid
                CHANGING VALUE(cv_meins) TYPE zta3mm0001-meins
                         VALUE(cv_subrc) TYPE sy-subrc.
  IF p_matid IS INITIAL.
    RETURN.
  ENDIF.

  SELECT SINGLE meins
    FROM zta3mm0001
    INTO cv_meins
   WHERE matid = p_matid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    MESSAGE i002(zmcn11601) WITH gs_new-matid INTO gv_messg.
    gv_messt = 'I'.
    RETURN.
  ENDIF.
ENDFORM.

FORM set_for_ins_mode .
  CLEAR: gv_dynnr, gt_atbar.

  gv_dynnr = '0202'.

  gs_atbar = 'INSERT'.
  APPEND gs_atbar TO gt_atbar.
  CLEAR gs_atbar.
ENDFORM.

FORM next_0200 .
  PERFORM set_for_next_mode.
ENDFORM.

FORM set_for_next_mode .
  CLEAR: gv_dynnr, gt_atbar, gs_new.

  gv_dynnr = '0201'.

  gs_atbar = 'NEXT'.
  APPEND gs_atbar TO gt_atbar.
  CLEAR gs_atbar.
ENDFORM.

FORM get_mapping_id  USING    VALUE(p_uname) TYPE sy-uname
                     CHANGING VALUE(cv_ereid) TYPE zsa3hr0001-ereid.
  SELECT SINGLE empid
    FROM zta3hr0002
    INTO cv_ereid
   WHERE mpgid = p_uname.
ENDFORM.

FORM get_inventory_data  USING    VALUE(ps_list) TYPE zsa3mm6002
                         CHANGING VALUE(cs_data) TYPE zsa3mm6006
                                  VALUE(cv_subrc) TYPE sy-subrc.
  PERFORM search_inventory USING ps_list
                           CHANGING cs_data cv_subrc.
  IF cv_subrc <> 0.
    MESSAGE i015(zmcn11601).
    RETURN.
  ENDIF.

  PERFORM get_mtext USING ps_list-matid
                    CHANGING cs_data-mtext cv_subrc.
  IF cv_subrc <> 0.
    MESSAGE i002(zmcn11601) WITH ps_list-matid.
    RETURN.
  ENDIF.

  PERFORM get_pname USING ps_list-plaid
                    CHANGING cs_data-pname cv_subrc.
  IF cv_subrc <> 0.
    MESSAGE i003(zmcn11601) WITH ps_list-plaid.
    RETURN.
  ENDIF.

  PERFORM get_meins USING ps_list-matid
                    CHANGING cs_data-meins_l cv_subrc.
  IF gv_subrc <> 0.
    MESSAGE i002(zmcn11601) WITH ps_list-matid.
    RETURN.
  ENDIF.

ENDFORM.

FORM search_inventory  USING    VALUE(ps_list) TYPE zsa3mm6002
                       CHANGING VALUE(cs_data) TYPE zsa3mm6006
                                VALUE(cv_subrc) TYPE sy-subrc.
  SELECT SINGLE matid plaid stoid batid labst scrap bktxt
                erdat erzet ereid aedat aezet aeeid
    FROM zta3mm0002
    INTO CORRESPONDING FIELDS OF cs_data
   WHERE matid = ps_list-matid
     AND plaid = ps_list-plaid
     AND stoid = ps_list-stoid
     AND batid = ps_list-batid.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    RETURN.
  ENDIF.
ENDFORM.

FORM detail_0100 .
  DATA ls_list LIKE LINE OF gt_list.

  PERFORM get_selected_row USING gt_list go_alv
                           CHANGING ls_list gv_subrc.
  IF gv_subrc <> 0.
    CLEAR gv_subrc.
    MESSAGE i016(zmcn11601).
    RETURN.
  ENDIF.

  PERFORM get_inventory_data USING ls_list
                             CHANGING gs_detail gv_subrc.
  IF gv_subrc <> 0.
    CLEAR gv_subrc.
    RETURN.
  ENDIF.

  CALL SCREEN 400.
  CLEAR gs_detail.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_LIST
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM check_data  USING    VALUE(ps_list) TYPE zsa3mm6002
                 CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  IF ps_list-dflag = 'X'.
    cv_subrc = 4.
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
  PERFORM check_chage_data USING gs_update
                           CHANGING gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM ask_again USING TEXT-q02
                    CHANGING gv_answer.
  IF gv_answer <> '1'.
    CLEAR gv_answer.
    RETURN.
  ENDIF.
  CLEAR gv_answer.

  PERFORM check_update_info USING gs_update
                            CHANGING gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM get_meins USING gs_update-matid
                    CHANGING gs_update-meins_l gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM update_data USING gs_update
                      CHANGING gv_subrc.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  COMMIT WORK.
  MESSAGE s018(zmcn11601).

  IF gs_ucond IS NOT INITIAL.
    PERFORM get_list USING gs_ucond
                     CHANGING gt_list gv_subrc.
    IF gv_subrc <> 0.
      PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
      RETURN.
    ENDIF.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_update_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_UPDATE
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM check_update_info  USING    VALUE(ps_update) TYPE zsa3mm6006
                        CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  PERFORM check_dflag USING ps_update-matid ps_update-batid
                      CHANGING cv_subrc.
  IF cv_subrc <> 0.
    RETURN.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_dflag
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_UPDATE_BATID
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM check_dflag  USING    VALUE(p_matid) TYPE zta3mm0001-matid
                           VALUE(p_batid) TYPE zta3mm0003-batid
                  CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_dflag TYPE zta3mm0003-dflag.

  SELECT SINGLE dflag
    FROM zta3mm0003
    INTO lv_dflag
   WHERE matid = p_matid
     AND batid = p_batid.

  IF lv_dflag = 'X'.
    cv_subrc = 4.
    MESSAGE i017(zmcn11601) INTO gv_messg.
    gv_messt = 'I'.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_UPDATE
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM update_data  USING    VALUE(ps_update) TYPE zsa3mm6006
                  CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_aeeid TYPE zsa3mm6006-aeeid.

  PERFORM get_mapping_id USING sy-uname
                         CHANGING lv_aeeid.

  UPDATE zta3mm0002 SET labst = ps_update-labst
                        scrap = ps_update-scrap
                        bktxt = ps_update-bktxt
                        aedat = sy-datum
                        aezet = sy-uzeit
                        aeeid = lv_aeeid
                    WHERE matid = ps_update-matid
                      AND plaid = ps_update-plaid
                      AND stoid = ps_update-stoid
                      AND batid = ps_update-batid.
  IF sy-subrc <> 0.
    ROLLBACK WORK.
    cv_subrc = sy-subrc.
    MESSAGE e019(zmcn11601) INTO gv_messg.
    gv_messt = 'E'.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_storage_type
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSA3MM6006_MATID
*&      --> ZSA3MM6006_BATID
*&      --> ZSA3MM6006_PLAID
*&      --> ZSA3MM6006_STOID
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM check_storage_type  USING    VALUE(p_matid) TYPE zta3mm0001-matid
                                  VALUE(p_batid) TYPE zta3mm0003-batid
                                  VALUE(p_plaid) TYPE zta3mm0006-plaid
                                  VALUE(p_stoid) TYPE zta3mm0007-stoid
                         CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA: lv_stype TYPE zta3mm0007-stype,
        lv_stway TYPE zta3mm0001-stway,
        lv_qualt TYPE zta3mm0003-qualt.

  SELECT SINGLE stype
    FROM zta3mm0007
    INTO lv_stype
   WHERE plaid = p_plaid
     AND stoid = p_stoid.

  SELECT SINGLE stway
    FROM zta3mm0001
    INTO lv_stway
   WHERE matid = p_matid.

  SELECT SINGLE qualt
    FROM zta3mm0003
    INTO lv_qualt
   WHERE matid = p_matid
     AND batid = p_batid.

  IF p_plaid <> 'P000000005' AND lv_qualt = 300 AND lv_stype <> 'S05'.
    cv_subrc = 4.
    MESSAGE i021(zmcn11601) INTO gv_messg.
    RETURN.
  ENDIF.

  IF lv_qualt <> 300 AND p_plaid = 'P000000005'.
    cv_subrc = 4.
    MESSAGE i025(zmcn11601) INTO gv_messg.
    RETURN.
  ENDIF.

  IF lv_qualt <> 300 AND lv_stype = 'S05'.
    cv_subrc = 4.
    MESSAGE i026(zmcn11601) INTO gv_messg.
    RETURN.
  ENDIF.

  IF lv_qualt = 300 AND lv_stype <> lv_stway AND p_plaid = 'P000000005'.
    cv_subrc = 4.
    MESSAGE i022(zmcn11601) INTO gv_messg.
    RETURN.
  ENDIF.

  IF lv_qualt <> 300 AND lv_stype <> lv_stway.
    cv_subrc = 4.
    MESSAGE i022(zmcn11601) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_quantity_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSA3MM6006_BATID
*&      --> ZSA3MM6006_LABST
*&      --> ZSA3MM6006_SCRAP
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM check_quantity  USING    VALUE(p_matid) TYPE zta3mm0001-matid
                              VALUE(p_batid) TYPE zta3mm0003-batid
                              VALUE(p_labst) TYPE zta3mm0002-labst
                              VALUE(p_scrap) TYPE zta3mm0002-scrap
                     CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA lv_qualt TYPE zta3mm0003-qualt.

  SELECT SINGLE qualt
    FROM zta3mm0003
    INTO lv_qualt
   WHERE matid = p_matid
     AND batid = p_batid.

  IF lv_qualt = 300 AND p_labst IS NOT INITIAL.
    cv_subrc = 4.
    MESSAGE i027(zmcn11601) INTO gv_messg.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form check_required_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSA3MM6006_LABST
*&      --> ZSA3MM6006_SCRAP
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM check_required  USING    VALUE(p_labst) TYPE zta3mm0002-labst
                              VALUE(p_scrap) TYPE zta3mm0002-scrap
                     CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  IF p_labst IS INITIAL AND p_scrap IS INITIAL.
    cv_subrc = 4.
    MESSAGE i028(zmcn11601) INTO gv_messg.
    RETURN.
  ENDIF.
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
                    USING 'FIELDNAME' 'BATID' '',
                    TABLES t_sort
                    USING 'SPOS' '01' '',
                    TABLES t_sort
                    USING 'UP' 'X' 'X'.

  PERFORM set_sort: TABLES t_sort
                    USING 'FIELDNAME' 'PNAME' '',
                    TABLES t_sort
                    USING 'SPOS' '02' '',
                    TABLES t_sort
                    USING 'DOWN' 'X' 'X'.

  PERFORM set_sort: TABLES t_sort
                    USING 'FIELDNAME' 'ERDAT' '',
                    TABLES t_sort
                    USING 'SPOS' '03' '',
                    TABLES t_sort
                    USING 'UP' 'X' 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> T_FCAT
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*


FORM set_sort  TABLES   t_sort STRUCTURE lvc_s_sort
               USING    VALUE(p_fname)
                        VALUE(p_value)
                        VALUE(p_aflag).
  DATA lv_sort(30).
  FIELD-SYMBOLS <fs_sort>.

  lv_sort = 'T_SORT-' && p_fname.
  ASSIGN (lv_sort) TO <fs_sort>.

  <fs_sort> = p_value.

  IF p_aflag = 'X'.
    APPEND t_sort.
    CLEAR t_sort.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form ask_again
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM ask_again USING    VALUE(p_text) TYPE string
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
*& Form check_chage_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_UPDATE
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM check_chage_data  USING    VALUE(ps_update) TYPE zsa3mm6006
                       CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA: ls_update TYPE zsa3mm6006.

  SELECT SINGLE labst scrap bktxt
    FROM zta3mm0002
    INTO CORRESPONDING FIELDS OF ls_update
   WHERE batid = ps_update-batid
     AND matid = ps_update-matid
     AND plaid = ps_update-plaid
     AND stoid = ps_update-stoid.
  IF sy-subrc = 0.
    IF ls_update-labst = ps_update-labst
    AND ls_update-scrap = ps_update-scrap
    AND ls_update-bktxt = ps_update-bktxt.
      cv_subrc = 4.
      MESSAGE i029(zmcn11601) INTO gv_messg.
      RETURN.
    ENDIF.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form modify_screen_0300
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM modify_screen_0300 .
  LOOP AT SCREEN.
    IF screen-group1 = 'BDC'.
      IF sy-tcode = 'ZA3MM6001_300'.
        screen-input = '1'.
      ELSE.
        screen-input = '0'.
      ENDIF.
    ENDIF.

    MODIFY SCREEN.
    CLEAR screen.
  ENDLOOP.
ENDFORM.
