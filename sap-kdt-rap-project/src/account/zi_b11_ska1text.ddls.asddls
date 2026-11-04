@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 계정마스터 Text Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_b11_ska1text as select from ztb11ska1_t
association to parent zr_b11_ska1 as _Account on $projection.SakUuid = _Account.SakUuid
{
    key sak_uuid as SakUuid,
    key spras as Spras,
    txt20 as Txt20,
    _Account
}
