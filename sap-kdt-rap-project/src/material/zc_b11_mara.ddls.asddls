@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 자재마스터 Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: [ 'Matnr' ]
define root view entity zc_b11_mara
  as projection on zr_b11_mara
{
  key MatUuid,
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'Matkx' ]
      Matnr,
      @ObjectModel.text.element: [ 'MaterialTypeName' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_mtart_f4', element: 'MaterialType'} }]
      Mtart,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_bklas_f4', element: 'Bklas'} }]
      Bklas,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_meins_f4', element: 'Msehi'} }]
      Meins,
      @Semantics.amount.currencyCode: 'Waers'
      Stprs,
      Peinh,
      Waers,
      @ObjectModel.text.element: [ 'PlantName' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_werks_f4', element: 'Werks'} }]
      Werks,
      @ObjectModel.text.element: [ 'StorageName' ]
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'ZI_B11_LGORT_F4', element: 'Lgort' },
        additionalBinding: [{ localElement: 'Werks', element: 'Werks', usage: #FILTER_AND_RESULT }]
      }]
      Lgort,
      Ersda,
      Matfi,
      Lvorm,
      CreatedBy,
      CreatedAt,
      ChangedBy,
      ChangedAt,
      LocChangedAt,
      @Search: { defaultSearchElement: true, fuzzinessThreshold: 0.8 }
      _MaraText[1: Spras = $session.system_language].Maktx                         as Matkx,
      _MaterialType._Text[1: Language = $session.system_language].MaterialTypeName as MaterialTypeName,
      _Plant.PlantName                                                             as PlantName,
      _Storage.StorageName                                                         as StorageName,
      /* Associations */
      _MaraText : redirected to composition child zc_b11_maratext
}
