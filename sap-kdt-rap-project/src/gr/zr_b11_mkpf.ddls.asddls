@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 입고 Header Root View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zr_b11_mkpf
  as select from ztb11mkpf
  composition [0..*] of zi_b11_mseg as _GRItem
{
  key mblnr_uuid     as MblnrUuid,
      mblnr          as Mblnr,
      mjahr          as Mjahr,
      bldat          as Bldat,
      budat          as Budat,
      cpudt          as Cpudt,
      bktxt          as Bktxt,
      @Semantics.user.createdBy: true
      created_by     as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at     as CreatedAt,
      @Semantics.user.lastChangedBy: true
      changed_by     as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at     as ChangedAt,
      @Semantics.systemDate.localInstanceLastChangedAt: true
      loc_changed_at as LocChangedAt,
      _GRItem
}
