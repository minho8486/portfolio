@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 조정계정 Search Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_B11_AKONT_F4
  as select from ZI_B11_SAKNR_F4
  association [0..1] to ZI_B11_GLACT_F4 as _AccountType on $projection.Glact = _AccountType.DomainValue
{
      @UI.hidden: true
  key ZI_B11_SAKNR_F4.SakUuid,
      @ObjectModel.text.element: [ 'AccountText' ]
      @UI.textArrangement: #TEXT_LAST
      ZI_B11_SAKNR_F4.Saknr,
      @UI.hidden: true
      @ObjectModel.text.element: [ 'AccountTypeText' ]
      @UI.textArrangement: #TEXT_LAST
      ZI_B11_SAKNR_F4.Glact,
      ZI_B11_SAKNR_F4.AccountText,
      @UI.hidden: true
      _AccountType.DomainText as AccountTypeText,
      _AccountType
      
}
