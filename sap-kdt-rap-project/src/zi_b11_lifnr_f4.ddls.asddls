@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 공급업체 Search Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
define view entity zi_b11_lifnr_f4 as select from ztb11lfa1
{
    @UI.hidden: true
    key lif_uuid as LifUuid,
    @ObjectModel.text.element: [ 'Name1' ]
    lifnr as Lifnr,
    name1 as Name1,
    @UI.hidden: true
    waers as Waers
}
