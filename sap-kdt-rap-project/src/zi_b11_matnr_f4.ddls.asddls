@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 자재 Search Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
define view entity zi_b11_matnr_f4 as select from ztb11mara
association [0..*] to ztb11mara_t as _MaraText on $projection.MatUuid = _MaraText.mat_uuid
{
    @UI.hidden: true
    key mat_uuid as MatUuid,
    @ObjectModel.text.element: [ 'Maktx' ]
    matnr as Matnr,
    @UI.hidden: true
    mtart as Mtart,
    _MaraText[1: spras = $session.system_language].maktx as Maktx
}
