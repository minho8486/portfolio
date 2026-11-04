@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 구매정보 레코드 Root View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zr_b11_eina
  as select from ztb11eina
  composition [0..*] of zi_b11_eine as _PIRItem
  association [0..*] to zr_b11_mara as _Material on $projection.MaterialUuid = _Material.MatUuid
  association [0..*] to zr_b11_lfa1 as _Vendor   on $projection.VendorUuid = _Vendor.LifUuid
{
  key inf_uuid                  as InfUuid,
      infnr                     as Infnr,
      vendor_uuid               as VendorUuid,
      material_uuid             as MaterialUuid,
      meins                     as Meins,
      loekz                     as Loekz,
      info_text                 as InfoText,
      _Material.Matnr           as Matnr,
      _Vendor.Lifnr             as Lifnr,
      _Material._MaraText.Maktx as Maktx,
      _Vendor.Name1             as Name1,
      @Semantics.user.createdBy: true
      created_by                as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                as CreatedAt,
      @Semantics.user.lastChangedBy: true
      changed_by                as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at                as ChangedAt,
      @Semantics.systemDate.localInstanceLastChangedAt: true
      loc_changed_at            as LocChangedAt,
      _PIRItem,
      _Material,
      _Vendor
}
