*&---------------------------------------------------------------------*
*& Report ZRA3MM6001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*



include zra3mm6001top.    " Global Data

include zra3mm6001o01.  " PBO-Modules
include zra3mm6001i01.  " PAI-Modules
include zra3mm6001f01.  " FORM-Routines

INITIALIZATION.
  PERFORM set_default TABLES so_matid.
AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.
  PERFORM check_matid USING so_matid[]
                      CHANGING gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'E'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM set_cflag USING so_matid[] so_plaid[] so_batid[]
                    CHANGING gv_cflag.
START-OF-SELECTION.
  PERFORM check_cond USING so_hsdat
                     CHANGING gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'S'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  PERFORM get_list_data USING so_matid[] so_plaid[] so_batid[] so_hsdat[] gv_cflag
                        CHANGING gt_list gv_subrc.
  IF gv_subrc <> 0.
    gv_messt = 'I'.
    PERFORM show_message CHANGING gv_messg gv_messt gv_subrc.
    RETURN.
  ENDIF.

  CALL SCREEN 100.



*GUI Texts
*----------------------------------------------------------
* T100 --> [도우라운지] 재고 집계 정보

*Text elements
*----------------------------------------------------------
* F01 구매수량
* I01 자재번호는 필수값 입니다.
* I02 입력한 조건을 기준으로 집계된 데이터가 보여집니다.
* I03 자재번호만 입력하고 검색시 자재별 구매한 수량도 함께 집계됨니다.
* T01 메인 검색 조건
* T02 서브 검색 조건
* T03 재고 집계 조회 프로그램 설명


*Selection texts
*----------------------------------------------------------
* SO_BATID         배치번호
* SO_HSDAT         생산일자
* SO_MATID         자재번호
* SO_PLAID         플랜트 번호


*Messages
*----------------------------------------------------------
*
* Message class: ZMCN11601
*000   & & & &
*002   & 없는 자재입니다.
*003   & 없는 플랜트입니다.
*004   & 없는 배치번호 입니다.
*023   오늘 이후 날짜는 입력할 수 없습니다.
*
* Message class: ZMCN11603
*001   자재번호는 필수값 입니다.
*002   해당 조건으로 검색된 값이 없습니다.
