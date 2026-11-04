@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 구매오더 Item Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity zc_b11_ekpo
  as projection on zi_b11_ekpo
{
  key EbelnUuid,
  key Ebelp,
      MatUuid,
      @Search.defaultSearchElement: true
      Txz01,
      Mtart,
      InfUuid,
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'zi_b11_pir_f4', element: 'Infnr' },
        additionalBinding: [{ localElement: 'VendorUuid', element: 'VendorUuid', usage: #FILTER },
                            { localElement: 'InfUuid', element: 'InfUuid', usage: #RESULT },
                            { localElement: 'MatUuid', element: 'MaterialUuid', usage: #RESULT }]
      }]
      Infnr,
      @ObjectModel.text.element: [ 'PlantName' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_werks_f4', element: 'Werks'} }]
      Werks,
      @ObjectModel.text.element: [ 'StorageName' ]
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'ZI_B11_LGORT_F4', element: 'Lgort' },
        additionalBinding: [{ localElement: 'Werks', element: 'Werks', usage: #FILTER_AND_RESULT }]
      }]
      Lgort,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      Menge,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_meins_f4', element: 'Msehi'} }]
      Meins,
      @Semantics.amount.currencyCode: 'Waers'
      Netpr,
      @Semantics.booleanIndicator: true
      Loekz,
      Elikz,
      Erekz,
      Waers,
      VendorUuid,
      @ObjectModel.text.element: [ 'Txz01' ]
      @UI.textArrangement: #TEXT_LAST
      @Consumption.valueHelpDefinition: [
      {
        entity:{ name: 'zi_b11_matnr_f4', element: 'Matnr' },
        additionalBinding: [
                { localElement: 'Txz01', element: 'Maktx', usage: #RESULT },
                { localElement: 'MatUuid', element: 'MatUuid', usage: #RESULT },
                { localElement: 'Mtart', element: 'Mtart', usage: #RESULT }
            ]
      }]
      Matnr,
      _Storage.PlantName   as PlantName,
      _Storage.StorageName as StorageName,
      CreatedBy,
      CreatedAt,
      ChangedBy,
      ChangedAt,
      /* Associations */
      _Material,
      _POHeader : redirected to parent zc_b11_ekko
}
