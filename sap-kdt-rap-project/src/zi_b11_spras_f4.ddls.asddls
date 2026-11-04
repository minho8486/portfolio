@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 언어 Search Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_B11_SPRAS_F4 as select from t002
association [0..*] to t002t as _LanguageText on $projection.Spras = _LanguageText.sprsl 
{
    @ObjectModel.text.element: [ 'sptxt' ]
    key spras as Spras,
    _LanguageText[1: spras = $session.system_language].sptxt,
    _LanguageText
} where t002.spras = '3'
    or t002.spras = 'E'
