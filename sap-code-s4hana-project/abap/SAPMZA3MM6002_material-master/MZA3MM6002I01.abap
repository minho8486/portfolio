*&---------------------------------------------------------------------*
*& Include          MZA3MM6002I01
*&---------------------------------------------------------------------*
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

    WHEN 'CONDC'.

    WHEN 'SEARCH'.
      PERFORM search_0100.
    WHEN 'CREATE'.
      PERFORM create_0100.
    WHEN 'UPDATE'.
      PERFORM update_0100.
  ENDCASE.
ENDMODULE.


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
*&      Module  MOVE_TO_PROGRAM_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE move_to_program_0100 INPUT.
  MOVE-CORRESPONDING zsa3mm6007 TO gs_cond.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  CHECK_MATID_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE check_matid_0100 INPUT.
  IF ok_code = 'SEARCH' AND zsa3mm6007-condb = 'X'.
    PERFORM check_matid USING zsa3mm6007-matid
                        CHANGING gv_subrc.
    IF gv_subrc <> 0.
      CLEAR gv_subrc.
      MESSAGE e003(zmcn11602).
      RETURN.
    ENDIF.
  ENDIF.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  CHECK_MTYPE_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE check_mtype_0100 INPUT.
  IF ok_code = 'SEARCH' AND zsa3mm6007-condb IS INITIAL.
    PERFORM check_mtype USING zsa3mm6007-mtype
                        CHANGING gv_subrc.
    IF gv_subrc <> 0.
      CLEAR gv_subrc.
      MESSAGE e003(zmcn11602).
      RETURN.
    ENDIF.
  ENDIF.
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

    WHEN 'ISAVE'.
      PERFORM isave_0200.
    WHEN 'NEXT'.
      PERFORM next_0200.
    WHEN 'MATGR'.
      PERFORM matgr_0200.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  MOVE_TO_PROGRAM_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE move_to_program_0200 INPUT.
  MOVE-CORRESPONDING zsa3mm6009 TO gs_new.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  CHECK_MTYPE_MATGR_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE check_mtype_matgr INPUT.
  PERFORM check_mtype_matgr USING zsa3mm6009-mtype zsa3mm6009-matgr
                            CHANGING gv_subrc.
  IF gv_subrc <> 0.
    CLEAR gv_subrc.
    MESSAGE e007(zmcn11602) WITH zsa3mm6009-matgr zsa3mm6009-mtype.
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
  MOVE-CORRESPONDING zsa3mm6009 TO gs_upt.
ENDMODULE.
