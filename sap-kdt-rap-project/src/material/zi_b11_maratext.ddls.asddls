@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 자재 Text Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_B11_MARATEXT as select from ztb11mara_t
association to parent zr_b11_mara as _Mara on $projection.MatUuid = _Mara.MatUuid
{
    key mat_uuid as MatUuid,
    key spras as Spras,
    maktx as Maktx,
    _Mara
}
