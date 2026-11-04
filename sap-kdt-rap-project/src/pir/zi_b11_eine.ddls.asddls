@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 구매정보 레코드 Item Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_b11_eine
  as select from ztb11eine
  association        to parent zr_b11_eina as _PIRHeader on $projection.InfUuid = _PIRHeader.InfUuid
  association [0..*] to ZI_B11_WERKS_F4    as _Plant     on $projection.Werks = _Plant.Werks
{
  key inf_uuid         as InfUuid,
  key werks            as Werks,
      @Semantics.amount.currencyCode: 'Waers'
      netpr            as Netpr,
      waers            as Waers,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      bstma            as Bstma,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      minbm            as Minbm,
      prdat            as Prdat,
      aplfz            as Aplfz,
      loekz            as Loekz,
      _PIRHeader.Meins as Meins,
      _PIRHeader.Infnr as Infnr,
      _Plant.PlantName as PlantName,
      @Semantics.user.createdBy: true
      created_by       as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at       as CreatedAt,
      @Semantics.user.lastChangedBy: true
      changed_by       as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at       as ChangedAt,
      _PIRHeader,
      _Plant
}
