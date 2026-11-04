@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 자재타입 Search Help View'
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_B11_MTART_F4
  as select from I_MaterialType
{
      @ObjectModel.text.element: [ 'MaterialTypeName' ]
  key MaterialType,
      _Text[1: Language = $session.system_language].MaterialTypeName as MaterialTypeName,
      /* Associations */
      _Text
}
where
     MaterialType = 'ROH'
  or MaterialType = 'HALB'
  or MaterialType = 'FERT'
  or MaterialType = 'HAWA'
  or MaterialType = 'VERP'
  or MaterialType = 'HIBE'
