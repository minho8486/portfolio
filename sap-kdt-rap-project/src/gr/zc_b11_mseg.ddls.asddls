@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 입고 Item Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity zc_b11_mseg
  as projection on zi_b11_mseg
{
  key MblnrUuid,
  key Zeile,
      @ObjectModel.text.element: [ 'Btext' ]
      @UI.textArrangement: #TEXT_LAST
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_bwart_f4', element: 'Bwart'} }]
      Bwart,
      _MovementType.Btext   as Btext,
      LifUuid,
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'VendorName' ]
      @UI.textArrangement: #TEXT_LAST
      @Consumption.valueHelpDefinition: [
      {
        entity:{ name: 'zi_b11_lifnr_f4', element: 'Lifnr' },
        additionalBinding: [
                { localElement: 'VendorName', element: 'Name1', usage: #RESULT },
                { localElement: 'LifUuid', element: 'LifUuid', usage: #RESULT }
            ]
      }]
      Lifnr,
      VendorName,
      MatUuid,
      @Search.defaultSearchElement: true
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
      Txz01,
      Mtart,
      InfUuid,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'zi_b11_pir_f4', element: 'Infnr' },
        additionalBinding: [{ localElement: 'LifUuid', element: 'VendorUuid', usage: #FILTER },
                            { localElement: 'InfUuid', element: 'InfUuid', usage: #RESULT },
                            { localElement: 'MatUuid', element: 'MaterialUuid', usage: #RESULT }]
      }]
      Infnr,
      @ObjectModel.text.element: [ 'PlantName' ]
      @UI.textArrangement: #TEXT_LAST
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_werks_f4', element: 'Werks'} }]
      Werks,
      @ObjectModel.text.element: [ 'StorageName' ]
      @UI.textArrangement: #TEXT_LAST
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'ZI_B11_LGORT_F4', element: 'Lgort' },
        additionalBinding: [{ localElement: 'Werks', element: 'Werks', usage: #FILTER_AND_RESULT }]
      }]
      Lgort,
      _Plant.PlantName      as PlantName,
      _Location.StorageName as StorageName,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      Menge,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_meins_f4', element: 'Msehi'} }]
      Meins,
      @Semantics.amount.currencyCode: 'Waers'
      Dmbtr,
      Waers,
      @ObjectModel.text.element: [ 'StockTypeText' ]
      @UI.textArrangement: #TEXT_LAST
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_insmk_f4', element: 'DomainValue'} }]
      Insmk,
      _StockType.DomainText as StockTypeText,
      Sgtxt,
      EbelnUuid,
      @Consumption.valueHelpDefinition: [
      {
        entity:{ name: 'zi_b11_po_header_f4', element: 'Ebeln' },
        additionalBinding: [
                { localElement: 'Lifnr', element: 'Lifnr', usage: #FILTER },
                { localElement: 'EbelnUuid', element: 'EbelnUuid', usage: #RESULT },
                { localElement: 'LifUuid', element: 'LifUuid', usage: #RESULT }
            ]
      }]
      Ebeln,
      @Consumption.valueHelpDefinition: [
      {
        entity:{ name: 'zi_b11_po_item_f4', element: 'Ebelp' },
        additionalBinding: [
                { localElement: 'EbelnUuid', element: 'EbelnUuid', usage: #FILTER_AND_RESULT },
                { localElement: 'MatUuid', element: 'MatUuid', usage: #RESULT },
                { localElement: 'InfUuid', element: 'InfUuid', usage: #RESULT }
            ]
      }]
      Ebelp,
      Podesc,
      CreatedBy,
      CreatedAt,
      ChangedBy,
      ChangedAt,
      /* Associations */
      _GRHeader : redirected to parent zc_b11_mkpf,
      _Location,
      _Material,
      _PIRInfo,
      _Plant,
      _POInfo,
      _Vendor,
      _MovementType,
      _StockType
}
