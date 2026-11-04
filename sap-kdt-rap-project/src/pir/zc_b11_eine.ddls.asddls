@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 구매정보 레코드 Item Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity zc_b11_eine
  as projection on zi_b11_eine
{
  key InfUuid,
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'PlantName' ]
      @UI.textArrangement: #TEXT_LAST
      @Consumption.valueHelpDefinition: [
      {
        entity:{ name: 'zi_b11_werks_f4', element: 'Werks' },
        additionalBinding: [
                { localElement: 'PlantName', element: 'PlantName', usage: #RESULT }
            ]
      }]
  key Werks,
      @Semantics.amount.currencyCode: 'Waers'
      Netpr,
      Waers,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      Bstma,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      Minbm,
      Prdat,
      Aplfz,
      Loekz,
      Meins,
      Infnr,
      PlantName,
      CreatedBy,
      CreatedAt,
      ChangedBy,
      ChangedAt,
      /* Associations */
      _PIRHeader : redirected to parent zc_b11_eina
}
