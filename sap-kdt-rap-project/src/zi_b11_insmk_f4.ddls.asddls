@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 재고타입 Search Help View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.resultSet.sizeCategory: #XS
define view entity zi_b11_insmk_f4
  as select from I_DomainFixedValue
{
      @UI.hidden: true
  key SAPDataDictionaryDomain,
      @ObjectModel.text.element: [ 'DomainText' ]
      @UI.textArrangement: #TEXT_LAST
  key DomainValue,
      _DomainFixedValueText[1: Language = $session.system_language].DomainText as DomainText
}
where
       SAPDataDictionaryDomain = 'MB_INSMK'
  and(
       DomainValue             = ''
    or DomainValue             = 'X'
    or DomainValue             = 'S'
  )
