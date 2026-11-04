@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 저장위치 Search Help View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
define view entity ZI_B11_LGORT_F4
  as select from t001l
  association [0..1] to ZI_B11_WERKS_F4 as _Plant on $projection.Werks = _Plant.Werks
{
  key t001l.werks      as Werks,
      @ObjectModel.text.element: [ 'StorageName' ]
  key t001l.lgort      as Lgort,
      _Plant.PlantName as PlantName,
      lgobe            as StorageName,
      _Plant
} where _Plant.Bukrs = 'K200'
