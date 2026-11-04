@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 구매오더 Item Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_b11_ekpo
  as select from ztb11ekpo
  association        to parent zr_b11_ekko as _POHeader     on  $projection.EbelnUuid = _POHeader.EbelnUuid
  association [0..1] to zi_b11_matnr_f4    as _Material     on  $projection.MatUuid = _Material.MatUuid
  association [0..1] to zi_b11_pir_f4      as _PurchaseInfo on  $projection.InfUuid = _PurchaseInfo.InfUuid
  association [0..1] to ZI_B11_LGORT_F4    as _Storage      on  $projection.Werks = _Storage.Werks
                                                            and $projection.Lgort = _Storage.Lgort
{
  key ebeln_uuid          as EbelnUuid,
  key ebelp               as Ebelp,
      mat_uuid            as MatUuid,
      txz01               as Txz01,
      mtart               as Mtart,
      inf_uuid            as InfUuid,
      werks               as Werks,
      lgort               as Lgort,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      menge               as Menge,
      meins               as Meins,
      @Semantics.amount.currencyCode: 'Waers'
      netpr               as Netpr,
      loekz               as Loekz,
      elikz               as Elikz,
      erekz               as Erekz,
      _Material.Matnr     as Matnr,
      _POHeader.Waers     as Waers,
      _POHeader.LifUuid   as VendorUuid,
      _PurchaseInfo.Infnr as Infnr,
      @Semantics.user.createdBy: true
      created_by          as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at          as CreatedAt,
      @Semantics.user.lastChangedBy: true
      changed_by          as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at          as ChangedAt,
      _POHeader,
      _Material,
      _PurchaseInfo,
      _Storage
}
