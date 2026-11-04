@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 입고 Header Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: [ 'Mblnr' ]
define root view entity zc_b11_mkpf as projection on zr_b11_mkpf
{
    key MblnrUuid,
    @Search.defaultSearchElement: true
    Mblnr,
    @Search.defaultSearchElement: true
    Mjahr,
    @Search.defaultSearchElement: true
    Bldat,
    Budat,
    Cpudt,
    Bktxt,
    CreatedBy,
    CreatedAt,
    ChangedBy,
    ChangedAt,
    LocChangedAt,
    /* Associations */
    _GRItem : redirected to composition child zc_b11_mseg
}
