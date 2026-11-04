@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 계정 Text Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity zc_b11_ska1text as projection on zi_b11_ska1text
{
    key SakUuid,
    @Search: { defaultSearchElement: true }
    @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_spras_f4', element: 'Spras'} }]
    key Spras,
    Txt20,
    /* Associations */
    _Account : redirected to parent zc_b11_ska1
}
