@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 구매오더 Search Help View'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_b11_po_f4 as select from ztb11ekko
association [0..*] to ztb11ekpo as _POItem on $projection.EbelnUuid = _POItem.ebeln_uuid
{
    key ebeln_uuid as EbelnUuid,
    ebeln as Ebeln,
    lif_uuid as LifUuid,
    waers as Waers,
    loekz as Loekz,
    bedat as Bedat,
    podesc as Podesc,
    _POItem
}
