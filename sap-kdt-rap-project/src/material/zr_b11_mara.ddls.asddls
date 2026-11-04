@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 자재마스터 Root View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zr_b11_mara
  as select from ztb11mara
  composition [0..*] of ZI_B11_MARATEXT as _MaraText
  association [0..1] to ZI_B11_MTART_F4 as _MaterialType on  $projection.Mtart = _MaterialType.MaterialType
  association [0..1] to ZI_B11_WERKS_F4 as _Plant        on  $projection.Werks = _Plant.Werks
  association [0..1] to ZI_B11_LGORT_F4 as _Storage      on  $projection.Werks = _Storage.Werks
                                                         and $projection.Lgort = _Storage.Lgort
{
  key mat_uuid       as MatUuid,
      matnr          as Matnr,
      mtart          as Mtart,
      bklas          as Bklas,
      meins          as Meins,
      @Semantics.amount.currencyCode: 'Waers'
      stprs          as Stprs,
      peinh          as Peinh,
      waers          as Waers,
      lgort          as Lgort,
      werks          as Werks,
      ersda          as Ersda,
      matfi          as Matfi,
      lvorm          as Lvorm,
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
      _MaraText,
      _MaterialType,
      _Plant,
      _Storage
}
