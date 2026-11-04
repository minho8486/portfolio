@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 구매오더 Header Root View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zr_b11_ekko
  as select from ztb11ekko
  composition [0..*] of zi_b11_ekpo     as _POItem
  association [0..1] to zi_b11_lifnr_f4 as _Vendor on $projection.LifUuid = _Vendor.LifUuid
{
  key ebeln_uuid     as EbelnUuid,
      ebeln          as Ebeln,
      lif_uuid       as LifUuid,
      _Vendor.Lifnr  as Lifnr,
      _Vendor.Name1  as VendorName,
      waers          as Waers,
      loekz          as Loekz,
      bedat          as Bedat,
      podesc         as Podesc,
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
      _POItem,
      _Vendor
}
