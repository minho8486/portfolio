@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 입고 Item Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_b11_mseg
  as select from ztb11mseg
  association        to parent zr_b11_mkpf as _GRHeader     on  $projection.MblnrUuid = _GRHeader.MblnrUuid
  association [0..1] to ZI_B11_WERKS_F4    as _Plant        on  $projection.Werks = _Plant.Werks
  association [0..1] to ZI_B11_LGORT_F4    as _Location     on  $projection.Lgort = _Location.Lgort
                                                            and $projection.Werks = _Location.Werks
  association [0..1] to zi_b11_lifnr_f4    as _Vendor       on  $projection.LifUuid = _Vendor.LifUuid
  association [0..1] to zi_b11_matnr_f4    as _Material     on  $projection.MatUuid = _Material.MatUuid
  association [0..1] to zi_b11_pir_f4      as _PIRInfo      on  $projection.InfUuid = _PIRInfo.InfUuid
  association [0..1] to zi_b11_po_f4       as _POInfo       on  $projection.EbelnUuid = _POInfo.EbelnUuid
  association [0..1] to ZI_B11_BWART_F4    as _MovementType on  $projection.Bwart = _MovementType.Bwart
  association [0..1] to zi_b11_insmk_f4    as _StockType    on  $projection.Insmk = _StockType.DomainValue
{
  key mblnr_uuid      as MblnrUuid,
  key zeile           as Zeile,
      bwart           as Bwart,
      lif_uuid        as LifUuid,
      _Vendor.Lifnr   as Lifnr,
      _Vendor.Name1   as VendorName,
      mat_uuid        as MatUuid,
      _Material.Matnr as Matnr,
      txz01           as Txz01,
      mtart           as Mtart,
      inf_uuid        as InfUuid,
      _PIRInfo.Infnr  as Infnr,
      werks           as Werks,
      lgort           as Lgort,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      menge           as Menge,
      meins           as Meins,
      @Semantics.amount.currencyCode: 'Waers'
      dmbtr           as Dmbtr,
      waers           as Waers,
      insmk           as Insmk,
      sgtxt           as Sgtxt,
      ebeln_uuid      as EbelnUuid,
      _POInfo.Ebeln   as Ebeln,
      ebelp           as Ebelp,
      _POInfo.Podesc  as Podesc,
      @Semantics.user.createdBy: true
      created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      changed_by      as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at      as ChangedAt,
      _GRHeader,
      _Plant,
      _Location,
      _Material,
      _Vendor,
      _PIRInfo,
      _POInfo,
      _MovementType,
      _StockType
}
