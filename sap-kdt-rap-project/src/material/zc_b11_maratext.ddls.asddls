@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 자재 Text Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity zc_b11_maratext as projection on ZI_B11_MARATEXT
{
    key MatUuid,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_spras_f4', element: 'Spras'} }]
    key Spras,
    @Search.defaultSearchElement: true
    Maktx,
    /* Associations */
    _Mara: redirected to parent zc_b11_mara
}
