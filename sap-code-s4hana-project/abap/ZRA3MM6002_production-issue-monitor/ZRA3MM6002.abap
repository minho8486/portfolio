*&---------------------------------------------------------------------*
*& Report ZRA3MM6002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*



include zra3mm6002top.    " Global Data

include zra3mm6002c01.
include zra3mm6002o01.  " PBO-Modules
include zra3mm6002i01.  " PAI-Modules
include zra3mm6002f01.  " FORM-Routines

INITIALIZATION.
  PERFORM set_default.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.

START-OF-SELECTION.

  CALL SCREEN 100.



*GUI Texts
*----------------------------------------------------------
* T100 --> [도우라운지] 생산오더 출고 현황 모니터링

*Text elements
*----------------------------------------------------------
* H01 출고 상태
* T01 검색 조건


*Messages
*----------------------------------------------------------
*
* Message class: ZMCN11601
*000   & & & &
*
* Message class: ZMCN11604
*001   미출고 상태의 생산오더가 없습니다.
*002   부분출고 상태의 생산오더가 없습니다.
*003   출고완료 상태의 생산오더가 없습니다.
*004   &는 없는 오더 번호 입니다.
