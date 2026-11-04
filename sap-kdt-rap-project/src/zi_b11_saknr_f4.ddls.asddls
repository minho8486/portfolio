@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 계정 번호 Search Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
define view entity ZI_B11_SAKNR_F4 as select from ztb11ska1
association [0..*] to ztb11ska1_t as _AccountText on $projection.SakUuid = _AccountText.sak_uuid
{
    @UI.hidden: true
    key sak_uuid as SakUuid,
    @ObjectModel.text.element: [ 'AccountText' ]
    saknr as Saknr,
    @UI.hidden: true
    glact as Glact,
    _AccountText[1: spras = $session.system_language].txt20 as AccountText
}
