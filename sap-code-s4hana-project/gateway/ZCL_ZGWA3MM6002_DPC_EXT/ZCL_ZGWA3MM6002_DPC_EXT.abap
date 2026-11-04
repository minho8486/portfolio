**************************************************************************
*   Class attributes.                                                    *
**************************************************************************


Instantiation: Public
Message class:
State: Implemented
Final Indicator:
R/3 Release: 758



**************************************************************************
*   Public section of class.                                             *
**************************************************************************


class ZCL_ZGWA3MM6002_DPC_EXT definition
  public
  inheriting from ZCL_ZGWA3MM6002_DPC
  create public .

public section.



**************************************************************************
*   Private section of class.                                            *
**************************************************************************


private section.



**************************************************************************
*   Protected section of class.                                          *
**************************************************************************


protected section.

  methods ESBATSET_GET_ENTITYSET
    redefinition .
  methods ESINVENSET_GET_ENTITYSET
    redefinition .
  methods ESMATSET_GET_ENTITYSET
    redefinition .
  methods ESPLASET_GET_ENTITYSET
    redefinition .
  methods ESSTOCKADJSET_GET_ENTITYSET
    redefinition .
  methods ESSTOSET_GET_ENTITYSET
    redefinition .
  methods ESSTOCKADJSET_CREATE_ENTITY
    redefinition .



**************************************************************************
*   Types section of class.                                              *
**************************************************************************
*"* dummy include to reduce generation dependencies between
*"* class ZCL_ZGWA3MM6002_DPC_EXT and it's users.
*"* touched if any type reference has been changed


*Messages
*----------------------------------------------------------
*
* Message class: ZMCN11601
*015   없는 재고정보 입니다.
*030   자재번호, 배치번호, 플랜트, 저장공간은 필수입니다.
*031   조정수량은 0보다 커야 합니다.
*032   현재 재고보다 감소 수량이 큽니다.
*033   조정구분이 올바르지 않습니다. A 또는 S를 입력하세요.
*034   재고 수정 중 오류가 발생했습니다.
*035   입출고 Header 생성 중 오류가 발생했습니다.
*036   입출고 Item 생성 중 오류가 발생했습니다.
*037   재고 조정이 완료되었습니다.
*
* Message class: ZMCN11602
*004   채번에 실패 했습니다.
