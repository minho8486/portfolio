@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 구매정보 레코드 Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: [ 'Infnr' ]
define root view entity zc_b11_eina
  as projection on zr_b11_eina
{
  key InfUuid,
      @Search.defaultSearchElement: true
      @UI.selectionField: [{ position: 30 }]
      Infnr,
      VendorUuid,
      MaterialUuid,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_meins_f4', element: 'Msehi'} }]
      Meins,
      Loekz,
      InfoText,
      @UI.selectionField: [{ position: 20 }]
      @ObjectModel.text.element: [ 'Maktx' ]
      @UI.textArrangement: #TEXT_LAST
      @Consumption.valueHelpDefinition: [
      {
        entity:{ name: 'zi_b11_matnr_f4', element: 'Matnr' },
        additionalBinding: [
                { localElement: 'Maktx', element: 'Maktx', usage: #RESULT },
                { localElement: 'MaterialUuid', element: 'MatUuid', usage: #RESULT }
            ]
      }]
      Matnr,
      @UI.selectionField: [{ position: 10 }]
      @ObjectModel.text.element: [ 'Name1' ]
      @UI.textArrangement: #TEXT_LAST
      @Consumption.valueHelpDefinition: [
      {
        entity:{ name: 'zi_b11_lifnr_f4', element: 'Lifnr' },
        additionalBinding: [
                { localElement: 'Name1', element: 'Name1', usage: #RESULT },
                { localElement: 'VendorUuid', element: 'LifUuid', usage: #RESULT }
            ]
      }]
      Lifnr,
      Maktx,
      Name1,
      CreatedBy,
      CreatedAt,
      ChangedBy,
      ChangedAt,
      LocChangedAt,
      /* Associations */
      _PIRItem : redirected to composition child zc_b11_eine
}
