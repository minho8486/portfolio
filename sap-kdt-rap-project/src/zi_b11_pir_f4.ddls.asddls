@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 구매정보 레코드 Search Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
define view entity zi_b11_pir_f4 as select from zr_b11_eina
{
    @UI.hidden: true
    key InfUuid,
    Infnr,
    @UI.hidden: true
    VendorUuid,
    @UI.hidden: true
    MaterialUuid,
    _PIRItem.Werks as Werks,
    _PIRItem.PlantName as PlantName,
    @UI.hidden: true
    @Semantics.quantity.unitOfMeasure: 'Meins'
    _PIRItem.Minbm as Minimum,
    @UI.hidden: true
    Meins,
    Matnr,
    Maktx,
    @UI.hidden: true
    @Semantics.amount.currencyCode: 'Waers'
    _PIRItem.Netpr as Netpr,
    @UI.hidden: true
    _PIRItem.Waers as Waers
}
