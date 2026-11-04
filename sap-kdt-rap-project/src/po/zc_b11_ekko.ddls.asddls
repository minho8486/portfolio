@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 구매오더 Header Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: [ 'Ebeln' ]
define root view entity zc_b11_ekko
  as projection on zr_b11_ekko
{
  key EbelnUuid,
      @Search.defaultSearchElement: true
      Ebeln,
      LifUuid,
      Waers,
      @Semantics.booleanIndicator: true
      Loekz,
      Bedat,
      Podesc,
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
      CreatedBy,
      CreatedAt,
      ChangedBy,
      ChangedAt,
      LocChangedAt,
      /* Associations */
      _Vendor,
      _POItem : redirected to composition child zc_b11_ekpo
}
