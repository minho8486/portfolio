@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 이동유형 Search Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_B11_BWART_F4
  as select from t156
  association [0..*] to ZI_B11_BTEXT as _MovementTypeText on $projection.Bwart = _MovementTypeText.Bwart
{
      @ObjectModel.text.element: [ 'Btext' ]
      @UI.textArrangement: #TEXT_LAST
  key bwart                                                        as Bwart,
      _MovementTypeText[1: Spras = $session.system_language].Btext as Btext,
      _MovementTypeText

}
where
      bwart                   = '101'
  or  bwart                   = '102'
  or  bwart                   = '311'
  or  bwart                   = '511'
  or  bwart                   = '601'
  or  bwart                   = '602'
