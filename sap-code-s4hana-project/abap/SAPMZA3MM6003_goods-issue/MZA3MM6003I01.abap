*&---------------------------------------------------------------------*
*& Include          MZA3MM6003I01
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
    WHEN 'CHECK'.
      PERFORM check_0100.
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
  MOVE-CORRESPONDING zsa3mm6012 TO gs_cond.
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
      PERFORM enter_0200.
    WHEN 'PRTYP'.
      PERFORM prtyp_0200.
    WHEN 'OINFO'.
      PERFORM oinfo_0200.
    WHEN 'INSERT'.
      PERFORM insert_0200.
    WHEN 'NEXT'.
      PERFORM next_0200.
    WHEN 'CHECP'.
      PERFORM checp_0200.
    WHEN 'ERDET'.
      PERFORM erdet_0200.
    WHEN 'PDATA'.
      PERFORM pdata_0200.
    WHEN 'RESET'.
      PERFORM reset_0200.
    WHEN 'ORDER'.
      PERFORM order_0200.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  MOVE_TO_PROGRAM_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE move_to_program_0200 INPUT.
  MOVE-CORRESPONDING zsa3mm6014 TO gs_hnew.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  SET_SEARCH_HELP_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE set_odrid_f4_0200 INPUT.
  " 오더번호 Search Help 만들어주기
  PERFORM set_odrid_f4_0200.
  IF gv_subrc <> 0.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
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
      PERFORM enter_0300.
    WHEN 'USAVE'.
      PERFORM update_0300.
    WHEN 'PDATA'.
      PERFORM pdata_0300.
    WHEN 'ORDER'.
      PERFORM order_0300.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  MOVE_TO_PROGRAM_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE move_to_program_0300 INPUT.
  MOVE-CORRESPONDING zsa3mm6014 TO gs_hupt.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0301  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE user_command_0301 INPUT.
  CASE ok_code.
    WHEN 'ENTER'.
      PERFORM enter_0301.
  ENDCASE.
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
      PERFORM enter_0400.
    WHEN 'ERDET'.
      PERFORM erdet_0400.
    WHEN 'PDATA'.
      PERFORM pdata_0400.
    WHEN 'ORDER'.
      PERFORM order_0400.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  MOVE_TO_PROGRAM_0400  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE move_to_program_0400 INPUT.
  MOVE-CORRESPONDING zsa3mm6014 TO gs_hdet.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0401  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE user_command_0401 INPUT.
  CASE ok_code.
    WHEN 'ENTER'.
      PERFORM enter_0401.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0203  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE user_command_0203 INPUT.
  CASE ok_code.
    WHEN 'ENTER'.
      PERFORM enter_0203.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  MOVE_TO_PROGRAM_0204  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE move_to_program_0204 INPUT.
  MOVE-CORRESPONDING zsa3mm6024 TO gs_emp.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  MOVE_TO_PROGRAM_0205  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE move_to_program_0205 INPUT.
  MOVE-CORRESPONDING zsa3mm6005 TO gs_plant.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE user_command_0101 INPUT.
  CASE ok_code.
    WHEN 'ENTER'.
      PERFORM enter_0101.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  MOVE_TO_PROGRAM_0206  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE move_to_program_0206 INPUT.
  MOVE-CORRESPONDING zsa3mm6004 TO gs_mat.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  MOVE_TO_PROGRAM_0302  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE move_to_program_0302 INPUT.
  MOVE-CORRESPONDING zsa3mm6039 TO gs_phead.
  MOVE-CORRESPONDING zsa3mm6040 TO gs_shead.
  MOVE-CORRESPONDING zsa3mm6041 TO gs_mhead.
ENDMODULE.
