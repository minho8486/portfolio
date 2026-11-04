@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 구매오더 Item Search Help View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
define view entity zi_b11_po_item_f4
  as select from zi_b11_ekpo
{
      @UI.hidden: true
  key EbelnUuid,
  key Ebelp,
      @ObjectModel.text.element: [ 'VendorName' ]
      @UI.textArrangement: #TEXT_LAST
      _POHeader.Lifnr,
      _POHeader.VendorName,
      _POHeader.Podesc,
      @UI.hidden: true
      MatUuid,
      @UI.hidden: true
      Txz01,
      @UI.hidden: true
      Mtart,
      @UI.hidden: true
      InfUuid,
      @ObjectModel.text.element: [ 'PlantName' ]
      @UI.textArrangement: #TEXT_LAST
      Werks,
      _Storage.PlantName,
      @ObjectModel.text.element: [ 'StorageName' ]
      @UI.textArrangement: #TEXT_LAST
      Lgort,
      _Storage.StorageName,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      @UI.hidden: true
      Menge,
      @UI.hidden: true
      Meins,
      @Semantics.amount.currencyCode: 'Waers'
      @UI.hidden: true
      Netpr,
      @UI.hidden: true
      Matnr,
      @UI.hidden: true
      Waers,
      @UI.hidden: true
      VendorUuid,
      @UI.hidden: true
      Infnr,
      @UI.hidden: true
      Loekz,
      @UI.hidden: true
      Elikz,
      /* Associations */
      _Material,
      _POHeader,
      _PurchaseInfo,
      _Storage
}
where
      Loekz <> 'X'
  and Elikz <> 'X'
