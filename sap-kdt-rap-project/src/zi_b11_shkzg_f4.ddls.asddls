@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 차대변 Search Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_B11_SHKZG_F4 as select from I_DomainFixedValue
{
    @UI.hidden: true
    key SAPDataDictionaryDomain,
    @ObjectModel.text.element: [ 'DomainText' ]
    key DomainValue,
    _DomainFixedValueText[1: Language = $session.system_language].DomainText as DomainText
} where SAPDataDictionaryDomain = 'SHKZG'
