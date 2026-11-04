*&---------------------------------------------------------------------*
*& Include          MZA3MM6001I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE exit INPUT.
  CASE sy-ucomm.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.
      PERFORM enter_0100.
    WHEN 'SEARCH'.
      PERFORM search_0100.
    WHEN 'NEW'.
      PERFORM new_0100.
    WHEN 'UPDATE'.
      PERFORM update_0100.
    WHEN 'DETAIL'.
      PERFORM detail_0100.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  MOVE_TO_PROGRAM_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE move_to_program_0100 INPUT.
  MOVE-CORRESPONDING zsa3mm6001 TO gs_cond.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE user_command_0101 INPUT.
  CASE ok_code.
    WHEN 'ENTER'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0102  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE user_command_0102 INPUT.
  CASE ok_code.
    WHEN 'ENTER'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0103  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE user_command_0103 INPUT.
  CASE ok_code.
    WHEN 'ENTER'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE user_command_0200 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.
      PERFORM enter.
    WHEN 'INSERT'.
      PERFORM insert_0200.
    WHEN 'NEXT'.
      PERFORM next_0200.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  MOVE_TO_PROGRAM_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE move_to_program_0200 INPUT.
  MOVE-CORRESPONDING zsa3mm6006 TO gs_new.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  MOVE_TO_PROGRAM_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE move_to_program_0101 INPUT.
  MOVE-CORRESPONDING zsa3mm6003 TO gs_binfo.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  MOVE_TO_PROGRAM_0102  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE move_to_program_0102 INPUT.
  MOVE-CORRESPONDING zsa3mm6004 TO gs_minfo.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  MOVE_TO_PROGRAM_0103  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE move_to_program_0103 INPUT.
  MOVE-CORRESPONDING zsa3mm6005 TO gs_pinfo.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  CHECK_MATID_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE check_matid_0200 INPUT.
  IF ok_code = 'INSERT'.
    PERFORM check_matid USING zsa3mm6006-matid
                        CHANGING gv_subrc.
    IF gv_subrc <> 0.
      gv_messt = 'E'.
      PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
      RETURN.
    ENDIF.
  ENDIF.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  CHECK_PLAID_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE check_plaid_0200 INPUT.
  IF ok_code = 'INSERT'.
    PERFORM check_plaid USING zsa3mm6006-plaid
                        CHANGING gv_subrc.
    IF gv_subrc <> 0.
      gv_messt = 'E'.
      PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
      RETURN.
    ENDIF.
  ENDIF.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  CHECK_STOID_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE check_stoid_0200 INPUT.
  IF ok_code = 'INSERT'.
    PERFORM check_stoid USING zsa3mm6006-plaid zsa3mm6006-stoid
                        CHANGING gv_subrc.
    IF gv_subrc <> 0.
      gv_messt = 'E'.
      PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
      RETURN.
    ENDIF.
  ENDIF.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  CHECK_BATID_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE check_batid_0200 INPUT.
  IF ok_code = 'INSERT'.
    PERFORM check_batid USING zsa3mm6006-matid zsa3mm6006-batid
                        CHANGING gv_subrc.
    IF gv_subrc <> 0.
      gv_messt = 'E'.
      PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
      RETURN.
    ENDIF.
  ENDIF.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  CHECK_INVENTORY_KEY_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE check_inventory_key_0200 INPUT.
  IF ok_code = 'INSERT'.
    PERFORM check_inventory_key USING zsa3mm6006-matid zsa3mm6006-batid
                                      zsa3mm6006-plaid zsa3mm6006-stoid
                                CHANGING gv_subrc.
    IF gv_subrc <> 0.
      gv_messt = 'E'.
      PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
      RETURN.
    ENDIF.

    PERFORM check_storage_type USING zsa3mm6006-matid zsa3mm6006-batid
                                     zsa3mm6006-plaid zsa3mm6006-stoid
                               CHANGING gv_subrc.
    IF gv_subrc <> 0.
      gv_messt = 'E'.
      PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
      RETURN.
    ENDIF.
  ENDIF.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE user_command_0300 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.

    WHEN 'USAVE'.
      PERFORM usave_0300.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  MOVE_TO_PROGRAM_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE move_to_program_0300 INPUT.
  MOVE-CORRESPONDING zsa3mm6006 TO gs_update.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0400  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE user_command_0400 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.

  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  MOVE_TO_PROGRAM_0400  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE move_to_program_0400 INPUT.
  MOVE-CORRESPONDING zsa3mm6006 TO gs_detail.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  CHECK_QUANTITY_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE check_quantity_0200 INPUT.
  IF ok_code = 'INSERT'.
    PERFORM check_quantity USING zsa3mm6006-matid zsa3mm6006-batid
                                 zsa3mm6006-labst zsa3mm6006-scrap
                           CHANGING gv_subrc.
    IF gv_subrc <> 0.
      gv_messt = 'E'.
      PERFORM show_message USING gv_messg gv_messt gv_subrc.
      RETURN.
    ENDIF.
  ENDIF.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  CHECK_REQUIRED_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE check_required_0200 INPUT.
  IF ok_code = 'INSERT'.
    PERFORM check_required USING zsa3mm6006-labst zsa3mm6006-scrap
                           CHANGING gv_subrc.
    IF gv_subrc <> 0.
      gv_messt = 'E'.
      PERFORM show_message USING gv_messg gv_messt gv_subrc.
      RETURN.
    ENDIF.
  ENDIF.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  CHECK_QUANTITY_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE check_quantity_0300 INPUT.
  IF ok_code = 'USAVE'.
    PERFORM check_quantity USING zsa3mm6006-matid zsa3mm6006-batid
                                 zsa3mm6006-labst zsa3mm6006-scrap
                           CHANGING gv_subrc.
    IF gv_subrc <> 0.
      gv_messt = 'E'.
      PERFORM show_message USING gv_messg gv_messt gv_subrc.
      RETURN.
    ENDIF.
  ENDIF.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  CHECK_REQUIRED_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE check_required_0300 INPUT.


*  IF ok_code = 'USAVE'.
*    PERFORM check_required USING zsa3mm6006-labst zsa3mm6006-scrap
*                           CHANGING gv_subrc.
*    IF gv_subrc <> 0.
*      gv_messt = 'E'.
*      PERFORM show_message USING gv_messg gv_messt gv_subrc.
*      RETURN.
*    ENDIF.
*  ENDIF.


ENDMODULE.
