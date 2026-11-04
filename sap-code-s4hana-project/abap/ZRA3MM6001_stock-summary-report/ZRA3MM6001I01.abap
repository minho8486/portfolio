*&---------------------------------------------------------------------*
*& Include          ZRA3MM6001I01
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

    WHEN OTHERS.

  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SET_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


MODULE set_alv_0100 OUTPUT.

  PERFORM create_container_0100 USING go_dock go_alv.
  PERFORM set_layo CHANGING gs_layo.
  PERFORM set_fcat TABLES gt_fcat.
  PERFORM display_alv TABLES gt_fcat
                      USING go_alv 'ZSA3MM6011' gt_list gs_layo.

ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


MODULE exit INPUT.
  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
