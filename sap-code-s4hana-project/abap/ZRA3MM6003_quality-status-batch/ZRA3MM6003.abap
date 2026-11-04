*&---------------------------------------------------------------------*
*& Report ZRA3MM6003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*



include zra3mm6003top.    " Global Data

include zra3mm6003o01.  " PBO-Modules
include zra3mm6003i01.  " PAI-Modules
include zra3mm6003f01.  " FORM-Routines

INITIALIZATION.
  PERFORM set_default USING pa_datum.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.

START-OF-SELECTION.

  PERFORM get_data CHANGING gt_list gv_subrc.
  IF gv_subrc <> 0.
    RETURN.
  ENDIF.

  PERFORM make_list_data CHANGING gt_list gt_inven gv_subrc.
  IF gv_subrc <> 0.
    RETURN.
  ENDIF.

  PERFORM make_inventory_data CHANGING gt_list gt_inven gv_subrc.
  IF gv_subrc <> 0.
    RETURN.
  ENDIF.

  IF sy-batch = 'X'.
    PERFORM loop_update_batch USING gt_list
                            CHANGING gv_subrc.
    IF gv_subrc <> 0.
      RETURN.
    ENDIF.

    PERFORM loop_insert_log USING gt_list
                            CHANGING gv_subrc.
    IF gv_subrc <> 0.
      RETURN.
    ENDIF.

    PERFORM loop_update_inventory USING gt_inven gt_list
                                  CHANGING gv_subrc.
    IF gv_subrc <> 0.
      RETURN.
    ENDIF.
  ELSE.
    CALL SCREEN 100.
  ENDIF.



*GUI Texts
*----------------------------------------------------------
* T100 --> [도우라운지] 품질상태 업데이트

*Text elements
*----------------------------------------------------------
* F01 업데이트 여부
