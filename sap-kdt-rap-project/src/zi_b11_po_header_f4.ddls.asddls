@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 구매오더 Header Search Help View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
define view entity zi_b11_po_header_f4
  as select from zr_b11_ekko
{
      @UI.hidden: true
  key EbelnUuid,
      Ebeln,
      @UI.hidden: true
      LifUuid,
      @ObjectModel.text.element: [ 'VendorName' ]
      @UI.textArrangement: #TEXT_LAST
      Lifnr,
      VendorName,
      @UI.hidden: true
      Waers,
      @UI.hidden: true
      Loekz,
      Podesc,
      /* Associations */
      _POItem,
      _Vendor
}
where
  Loekz <> 'X'
