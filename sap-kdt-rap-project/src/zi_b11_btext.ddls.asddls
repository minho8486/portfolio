@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 이동유형 Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_B11_BTEXT
  as select from t156t
{
  key spras as Spras,
  @ObjectModel.text.element: [ 'Btext' ]
  @UI.textArrangement: #TEXT_LAST
  key bwart as Bwart,
  key sobkz as Sobkz,
  key kzbew as Kzbew,
  key kzzug as Kzzug,
  key kzvbr as Kzvbr,
      btext as Btext
}
where
      sobkz = ''
  and kzzug = ''
  and kzvbr = ''
  and (
       ( bwart = '101' and kzbew = 'B' )
    or ( bwart = '102' and kzbew = 'B' )
    or ( bwart = '311' and kzbew = ''  )
    or ( bwart = '511' and kzbew = ''  )
    or ( bwart = '601' and kzbew = 'L' )
    or ( bwart = '602' and kzbew = 'L' )
  )
