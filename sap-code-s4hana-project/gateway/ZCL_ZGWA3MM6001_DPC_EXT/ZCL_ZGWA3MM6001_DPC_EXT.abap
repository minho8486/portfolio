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


class ZCL_ZGWA3MM6001_DPC_EXT definition
  public
  inheriting from ZCL_ZGWA3MM6001_DPC
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

  methods ESMATERIALSET_GET_ENTITYSET
    redefinition .
  methods ESMATSET_GET_ENTITYSET
    redefinition .
  methods ESPLASET_GET_ENTITYSET
    redefinition .
  methods ESMATDETAILSET_GET_ENTITY
    redefinition .



**************************************************************************
*   Types section of class.                                              *
**************************************************************************
*"* dummy include to reduce generation dependencies between
*"* class ZCL_ZGWA3MM6001_DPC_EXT and it's users.
*"* touched if any type reference has been changed


*Messages
*----------------------------------------------------------
*
* Message class: ZMCN11601
*002   & 없는 자재입니다.
