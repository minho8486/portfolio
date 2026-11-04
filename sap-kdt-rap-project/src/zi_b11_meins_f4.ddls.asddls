@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 단위 Search Help View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.resultSet.sizeCategory: #XS
define view entity zi_b11_meins_f4
  as select from t006
  association [0..*] to t006a as _UnitText on $projection.Msehi = _UnitText.msehi
{
      @ObjectModel.text.element: [ 'MeinsText' ]
  key msehi as Msehi,
      _UnitText[1: spras = $session.system_language].mseht as MeinsText,
      _UnitText
}
where
     msehi = 'BAG'
  or msehi = 'EA'
  or msehi = 'G'
  or msehi = 'KG'
