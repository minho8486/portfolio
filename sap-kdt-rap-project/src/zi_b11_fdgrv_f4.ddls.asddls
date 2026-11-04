@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 공급업체 그룹 Search Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_B11_FDGRV_F4
  as select from I_DomainFixedValueText
{
      @UI.hidden: true
  key SAPDataDictionaryDomain,
      @ObjectModel.text.element: [ 'DomainText' ]
      @UI.textArrangement: #TEXT_LAST
  key DomainValue,
      @UI.hidden: true
  key Language,
      DomainText,
      /* Associations */
      _Language
}
where
      SAPDataDictionaryDomain = 'ZDB11FDGRV'
  and Language                = $session.system_language
