*&---------------------------------------------------------------------*
*& Include          ZRA3MM6003F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_default
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PA_DATUM
*&---------------------------------------------------------------------*


FORM set_default  USING    pa_datum LIKE pa_datum.
  pa_datum = sy-datum.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- CT_LIST
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_data  CHANGING ct_list LIKE gt_list
                        VALUE(cv_subrc) TYPE sy-subrc.
  SELECT b~matid b~batid b~hsdat b~qualt AS besta b~dflag m~matgr m~maqua m~meins
    FROM zta3mm0003 AS b
   INNER JOIN zta3mm0001 AS m
      ON b~matid = m~matid
    INTO CORRESPONDING FIELDS OF TABLE ct_list
   WHERE b~qualt <> 300
     AND b~dflag <> 'X'.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_inventory_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_INVEN
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM make_list_data  CHANGING Ct_list LIKE gt_list
                              ct_inven LIKE gt_inven
                              VALUE(cv_subrc) TYPE sy-subrc.
  DATA: ls_list   TYPE zsa3mm6022,
        lv_datum  TYPE dats,
        lv_fdatum TYPE dats,
        lv_fmaqua TYPE zta3mm0001-maqua.

  LOOP AT ct_list INTO ls_list.
    PERFORM get_inventory_data USING ls_list
                               CHANGING ct_inven cv_subrc.
    IF cv_subrc <> 0.
      RETURN.
    ENDIF.

    PERFORM calc_date USING ls_list-hsdat '0' '0' ls_list-maqua '+'
                      CHANGING lv_datum.
    IF ls_list-matgr = 'FRU'.
      lv_fmaqua = 2 * ls_list-maqua.
      PERFORM calc_date USING ls_list-hsdat '0' '0' lv_fmaqua '+'
                      CHANGING lv_fdatum.
    ENDIF.

    IF ls_list-matgr = 'FRU'.
      IF sy-datum > lv_fdatum.
        ls_list-afsta = '300'.
        ls_list-uflag = 'X'.
      ELSEIF sy-datum > lv_datum AND sy-datum <= lv_fdatum.
        IF ls_list-besta <> '101'.
          ls_list-afsta = '101'.
          ls_list-uflag = 'X'.
        ENDIF.
      ENDIF.
    ENDIF.

    IF sy-datum > lv_datum AND ls_list-matgr <> 'FRU'.
      ls_list-afsta = '300'.
      ls_list-uflag = 'X'.
    ENDIF.

    IF ls_list-afsta = '300'.
      ls_list-dflag = 'X'.
    ENDIF.

    MODIFY ct_list FROM ls_list.
    CLEAR ls_list.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_inv_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_LIST
*&      <-- CT_INVEN
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM get_inventory_data  USING    ps_list TYPE zsa3mm6022
                         CHANGING ct_inven LIKE gt_inven
                                  VALUE(cv_subrc) TYPE sy-subrc.
  DATA: lt_inven LIKE gt_inven.

  SELECT matid batid plaid stoid labst scrap
    FROM zta3mm0002
    INTO CORRESPONDING FIELDS OF TABLE  lt_inven
   WHERE matid = ps_list-matid
     AND batid = ps_list-batid
     AND stoid <> 'SL05'.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    RETURN.
  ENDIF.

  APPEND LINES OF lt_inven TO ct_inven.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form calc_date
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_LIST_HSDAT
*&      --> LS_LIST_MAQUA
*&      --> P_
*&      --> P_
*&      <-- LV_DATUM
*&---------------------------------------------------------------------*


FORM calc_date  USING    VALUE(p_date)
                         VALUE(p_year)
                         VALUE(p_month)
                         VALUE(p_day)
                         VALUE(p_sign)
                CHANGING VALUE(cv_datum).
  DATA: lv_day TYPE t5a4a-dlydy.
  lv_day = p_day.

  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = p_date
      days      = lv_day
      months    = p_month
      signum    = p_sign
      years     = p_year
    IMPORTING
      calc_date = cv_datum.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form make_inventory_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_LIST
*&      <-- GT_INVEN
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM make_inventory_data  CHANGING ct_list LIKE gt_list
                                   ct_inven LIKE gt_inven
                                   VALUE(cv_subrc) TYPE sy-subrc.
  DATA: ls_inven TYPE zsa3mm6023,
        ls_list  TYPE zsa3mm6022,
        lv_quant TYPE zta3mm0002-labst.

  LOOP AT ct_inven INTO ls_inven.
    READ TABLE ct_list INTO ls_list WITH KEY matid = ls_inven-matid
                                             batid = ls_inven-batid
                                             uflag = 'X'.
    IF sy-subrc = 0.
      IF ls_list-afsta = '300'.
        CLEAR lv_quant.
        lv_quant = ls_inven-labst.

        ls_inven-labst = 0.
        ls_inven-scrap += lv_quant.
        ls_inven-uflag = 'X'.
        ls_inven-stoid = 'SL05'.

        ls_list-chqua += lv_quant.
        MODIFY ct_list FROM ls_list INDEX sy-tabix.
      ENDIF.
    ELSE.
      CONTINUE.
    ENDIF.

    MODIFY ct_inven FROM ls_inven.
    CLEAR: ls_inven, ls_list.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_batch
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_LIST
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM loop_update_batch  USING    pt_list LIKE gt_list
                        CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA: ls_list TYPE zsa3mm6022.

  LOOP AT pt_list INTO ls_list.
    IF ls_list-uflag = 'X'.
      PERFORM update_batch USING ls_list
                           CHANGING cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form insert_log
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_LIST
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM loop_insert_log  USING    pt_list LIKE gt_list
                      CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA: ls_list   TYPE zsa3mm6022,
        lv_num(8) TYPE n,
        lv_logid  TYPE zta3mm0015-logid.

  LOOP AT pt_list INTO ls_list.
    IF ls_list-uflag = 'X'.
      PERFORM get_number_range USING 'ZNRA3MM63' '01'
                               CHANGING lv_num cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.

      PERFORM set_logid USING lv_num
                        CHANGING lv_logid.

      PERFORM insert_log USING ls_list lv_logid
                         CHANGING cv_subrc.
      IF cv_subrc <> 0.
        RETURN.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_inventory
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_INVEN
*&      <-- GV_SUBRC
*&---------------------------------------------------------------------*


FORM loop_update_inventory  USING    pt_inven LIKE gt_inven
                                     pt_list LIKE gt_list
                            CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA: ls_inven TYPE zsa3mm6023,
        ls_list TYPE zsa3mm6022,
        lv_scrap TYPE zta3mm0002-scrap.


  LOOP AT pt_inven INTO ls_inven.
    IF ls_inven-uflag = 'X'.

      SELECT SINGLE scrap
        FROM zta3mm0002
        INTO lv_scrap
       WHERE matid = ls_inven-matid
         AND batid = ls_inven-batid
         AND plaid = ls_inven-plaid
         AND stoid = ls_inven-stoid.
      IF sy-subrc = 0.
        ls_inven-scrap = ls_inven-scrap + lv_scrap.

        PERFORM update_inventory USING ls_inven
                                 CHANGING cv_subrc.
        IF cv_subrc <> 0.
          RETURN.
        ENDIF.
      ELSE.
        PERFORM insert_inventory USING ls_inven
                                 CHANGING cv_subrc.
        IF cv_subrc <> 0.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_batch
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_LIST
*&      <-- CV_SUBNC
*&---------------------------------------------------------------------*


FORM update_batch  USING    VALUE(ps_list) TYPE zsa3mm6022
                   CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA: lv_aeeid TYPE zsa3mm6006-aeeid.

  PERFORM get_mapping_id USING sy-uname
                         CHANGING lv_aeeid.

  UPDATE zta3mm0003 SET qualt = ps_list-afsta
                        dflag = ps_list-dflag
                        aedat = sy-datum
                        aezet = sy-uzeit
                        aeeid = lv_aeeid
                    WHERE matid = ps_list-matid
                      AND batid = ps_list-batid.
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
*& Form insert_log
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_LIST
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM insert_log  USING    VALUE(ps_list) TYPE zsa3mm6022
                          VALUE(p_logid) TYPE zta3mm0015-logid
                 CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA: ls_zta3mm0015 TYPE zta3mm0015.

  ls_zta3mm0015-logid = p_logid.
  ls_zta3mm0015-matid = ps_list-matid.
  ls_zta3mm0015-batid = ps_list-batid.
  ls_zta3mm0015-cdate = sy-datum.
  ls_zta3mm0015-besta = ps_list-besta.
  ls_zta3mm0015-afsta = ps_list-afsta.
  ls_zta3mm0015-chqua = ps_list-chqua.
  ls_zta3mm0015-erdat = sy-datum.
  ls_zta3mm0015-aedat = sy-datum.
  ls_zta3mm0015-erzet = sy-uzeit.
  ls_zta3mm0015-aezet = sy-uzeit.
  ls_zta3mm0015-bktxt = ps_list-matid && '자재' && ps_list-batid && '배치' &&
                        ps_list-besta && 'TO' && ps_list-afsta && '상태변경'.

  PERFORM get_mapping_id USING sy-uname
                         CHANGING ls_zta3mm0015-ereid.
  PERFORM get_mapping_id USING sy-uname
                         CHANGING ls_zta3mm0015-aeeid.

  INSERT zta3mm0015 FROM ls_zta3mm0015.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    ROLLBACK WORK.
    RETURN.
  ENDIF.
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
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_logid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_NUM
*&      <-- LV_LOGID
*&---------------------------------------------------------------------*


FORM set_logid  USING    VALUE(p_num) TYPE numc08
                CHANGING VALUE(cv_logid) TYPE zta3mm0015-logid.
  DATA: lv_year(4) TYPE n.

  lv_year = sy-datum+0(4).

  cv_logid = 'LOG' && lv_year && p_num.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form update_inventory
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_INVEN
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM update_inventory  USING    VALUE(ps_inven) TYPE zsa3mm6023
                       CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA: lv_aeeid TYPE zsa3mm6006-aeeid.

  PERFORM get_mapping_id USING sy-uname
                         CHANGING lv_aeeid.

  UPDATE zta3mm0002 SET labst = ps_inven-labst
                        scrap = ps_inven-scrap
                        aedat = sy-datum
                        aezet = sy-uzeit
                        aeeid = lv_aeeid
                    WHERE matid = ps_inven-matid
                      AND batid = ps_inven-batid
                      AND plaid = ps_inven-plaid
                      AND stoid = ps_inven-stoid.
  IF sy-subrc <> 0.
    ROLLBACK WORK.
    cv_subrc = sy-subrc.
    RETURN.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form create_object_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM create_object_0100 .
  CREATE OBJECT go_dock
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
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CREATE OBJECT go_split
    EXPORTING


*     link_dynnr        =
*     link_repid        =
*     shellstyle        =
*     left              =
*     top               =
*     width             =
*     height            =
*     metric            = cntl_metric_dynpro
*     align             = 15


      parent            = go_dock
      rows              = 2
      columns           = 1


*     no_autodef_progid_dynnr =
*     name              =


    EXCEPTIONS
      cntl_error        = 1
      cntl_system_error = 2
      OTHERS            = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL METHOD go_split->get_container
    EXPORTING
      row       = 1
      column    = 1
    RECEIVING
      container = go_ucon.

  CALL METHOD go_split->get_container
    EXPORTING
      row       = 2
      column    = 1
    RECEIVING
      container = go_dcon.

  CREATE OBJECT go_ualv
    EXPORTING


*     i_shellstyle      = 0
*     i_lifetime        =


      i_parent          = go_ucon


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

  CREATE OBJECT go_dalv
    EXPORTING


*     i_shellstyle      = 0
*     i_lifetime        =


      i_parent          = go_dcon


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
*& Form set_layo_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM set_layo_0100 .
  CLEAR gs_layo.

  gs_layo-cwidth_opt = 'X'.
  gs_layo-zebra = 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_fcat_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM set_fcat_0100 .
  CLEAR: gt_ufcat[], gt_dfcat[].

  PERFORM set_fcat: TABLES gt_ufcat
                    USING 'FIELDNAME' 'UFLAG' '',
                    TABLES gt_ufcat
                    USING 'COLTEXT' '업데이트 여부'(f01) '',
                    TABLES gt_ufcat
                    USING 'CHECKBOX' 'X' 'X'.

  PERFORM set_fcat: TABLES gt_ufcat
                    USING 'FIELDNAME' 'DFLAG' '',
                    TABLES gt_ufcat
                    USING 'CHECKBOX' 'X' 'X'.

  PERFORM set_fcat: TABLES gt_dfcat
                    USING 'FIELDNAME' 'UFLAG' '',
                    TABLES gt_dfcat
                    USING 'COLTEXT' '업데이트 여부'(f01) '',
                    TABLES gt_dfcat
                    USING 'CHECKBOX' 'X' 'X'.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_FCAT
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*


FORM set_fcat  TABLES   t_fcat STRUCTURE lvc_s_fcat
               USING    VALUE(p_fname)
                        VALUE(p_value)
                        VALUE(p_aflag).
  DATA: lv_fcat(30).
  FIELD-SYMBOLS: <fs_fcat>.

  lv_fcat = 'T_FCAT-' && p_fname.
  ASSIGN (lv_fcat) TO <fs_fcat>.

  <fs_fcat> = p_value.

  IF p_aflag = 'X'.
    APPEND t_fcat.
    CLEAR t_fcat.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form display_alv_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM display_alv_0100 .
  CALL METHOD go_ualv->set_table_for_first_display
    EXPORTING


*     i_buffer_active               =
*     i_bypassing_buffer            =
*     i_consistency_check           =


      i_structure_name              = 'ZSA3MM6022'


*     is_variant                    =
*     i_save                        =
*     i_default                     = 'X'


      is_layout                     = gs_layo


*     is_print                      =
*     it_special_groups             =
*     it_toolbar_excluding          =
*     it_hyperlink                  =
*     it_alv_graphics               =
*     it_except_qinfo               =
*     ir_salv_adapter               =


    CHANGING
      it_outtab                     = gt_list
      it_fieldcatalog               = gt_ufcat[]
      it_sort                       = gt_usort[]


*     it_filter                     =


    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.


*   Implement suitable error handling here


  ENDIF.

  CALL METHOD go_dalv->set_table_for_first_display
    EXPORTING


*     i_buffer_active               =
*     i_bypassing_buffer            =
*     i_consistency_check           =


      i_structure_name              = 'ZSA3MM6023'


*     is_variant                    =
*     i_save                        =
*     i_default                     = 'X'


      is_layout                     = gs_layo


*     is_print                      =
*     it_special_groups             =
*     it_toolbar_excluding          =
*     it_hyperlink                  =
*     it_alv_graphics               =
*     it_except_qinfo               =
*     ir_salv_adapter               =


    CHANGING
      it_outtab                     = gt_inven
      it_fieldcatalog               = gt_dfcat[]
      it_sort                       = gt_dsort[]


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
*& Form set_sort_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM set_sort_0100 .
  CLEAR: gt_usort[], gt_dsort[].

  PERFORM set_sort: TABLES gt_usort
                    USING 'FIELDNAME' 'MATID' '',
                    TABLES gt_usort
                    USING 'SPOS' '1' '',
                    TABLES gt_usort
                    USING 'UP' 'X' 'X'.

  PERFORM set_sort: TABLES gt_usort
                    USING 'FIELDNAME' 'BATID' '',
                    TABLES gt_usort
                    USING 'SPOS' '2' '',
                    TABLES gt_usort
                    USING 'UP' 'X' 'X'.

  PERFORM set_sort: TABLES gt_dsort
                    USING 'FIELDNAME' 'MATID' '',
                    TABLES gt_dsort
                    USING 'SPOS' '1' '',
                    TABLES gt_dsort
                    USING 'UP' 'X' 'X'.

  PERFORM set_sort: TABLES gt_dsort
                    USING 'FIELDNAME' 'BATID' '',
                    TABLES gt_dsort
                    USING 'SPOS' '2' '',
                    TABLES gt_dsort
                    USING 'UP' 'X' 'X'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_USORT
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*


FORM set_sort  TABLES   t_sort STRUCTURE lvc_s_sort
               USING    VALUE(p_fname)
                        VALUE(p_value)
                        VALUE(p_aflag).
  DATA: lv_sort(30).
  FIELD-SYMBOLS: <fs_sort>.

  lv_sort = 'T_SORT-' && p_fname.
  ASSIGN (lv_sort) TO <fs_sort>.

  <fs_sort> = p_value.

  IF p_aflag = 'X'.
    APPEND t_sort.
    CLEAR t_sort.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form insert_inventory
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_INVEN
*&      <-- CV_SUBRC
*&---------------------------------------------------------------------*


FORM insert_inventory  USING    VALUE(ps_inven) TYPE zsa3mm6023
                       CHANGING VALUE(cv_subrc) TYPE sy-subrc.
  DATA: ls_zta3mm0002 TYPE zta3mm0002.

  ls_zta3mm0002-batid = ps_inven-batid.
  ls_zta3mm0002-matid = ps_inven-matid.
  ls_zta3mm0002-plaid = ps_inven-plaid.
  ls_zta3mm0002-stoid = ps_inven-stoid.
  ls_zta3mm0002-labst = ps_inven-labst.
  ls_zta3mm0002-scrap = ps_inven-scrap.
  ls_zta3mm0002-erdat = sy-datum.
  ls_zta3mm0002-aedat = sy-datum.
  ls_zta3mm0002-erzet = sy-uzeit.
  ls_zta3mm0002-aezet = sy-uzeit.

  PERFORM get_mapping_id USING sy-uname
                         CHANGING ls_zta3mm0002-ereid.
  PERFORM get_mapping_id USING sy-uname
                         CHANGING ls_zta3mm0002-aeeid.

  INSERT zta3mm0002 FROM ls_zta3mm0002.
  IF sy-subrc <> 0.
    cv_subrc = sy-subrc.
    ROLLBACK WORK.
    RETURN.
  ENDIF.

ENDFORM.
