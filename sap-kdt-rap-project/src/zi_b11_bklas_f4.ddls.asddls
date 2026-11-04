@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 평가클래스 Search Help View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_B11_BKLAS_F4
  as select from t025
  association [0..*] to t025t as _ClassText on $projection.Bklas = _ClassText.bklas
{
      @ObjectModel.text.element: [ 'Bkbez' ]
  key bklas                                                 as Bklas,
      _ClassText[1: spras = $session.system_language].bkbez as Bkbez,
      _ClassText
}
where
     bklas = '3000'
  or bklas = '3300'
  or bklas = '7900'
  or bklas = '7920'
