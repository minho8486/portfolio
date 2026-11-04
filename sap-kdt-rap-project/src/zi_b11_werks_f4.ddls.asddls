@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 플랜트 Search Help View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
define view entity ZI_B11_WERKS_F4
  as select from t001w
  association [0..1] to t001k as _Company on $projection.Bwkey = _Company.bwkey
{
      @ObjectModel.text.element: [ 'PlantName' ]
  key werks as Werks,
      name1 as PlantName,
      @UI.hidden: true
      bwkey as Bwkey,
      @UI.hidden: true
      _Company.bukrs as Bukrs,    
      _Company
}
where
  _Company.bukrs = 'K200'
