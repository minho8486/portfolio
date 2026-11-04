@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 계정 타입 Search Help View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_B11_GLACT_F4
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
      SAPDataDictionaryDomain = 'GLACCOUNT_TYPE'
  and Language                = $session.system_language
