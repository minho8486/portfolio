@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 공급업체 마스터 Root View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zr_b11_lfa1
  as select from ztb11lfa1
  association [0..1] to ZI_B11_FDGRV_F4 as _VendorGroup on $projection.Fdgrv = _VendorGroup.DomainValue
  association [0..1] to ZI_B11_AKONT_F4 as _Account     on $projection.AkontUuid = _Account.SakUuid
{
  key lif_uuid                as LifUuid,
      lifnr                   as Lifnr,
      name1                   as Name1,
      waers                   as Waers,
      @Semantics.amount.currencyCode: 'Waers'
      minbw                   as Minbw,
      fdgrv                   as Fdgrv,
      akont_uuid              as AkontUuid,
      loevm                   as Loevm,
      @Semantics.user.createdBy: true
      created_by              as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at              as CreatedAt,
      @Semantics.user.lastChangedBy: true
      changed_by              as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at              as ChangedAt,
      _Account.Saknr          as Saknr,
      _Account.Glact          as Glact,
      _VendorGroup,
      _Account
}
