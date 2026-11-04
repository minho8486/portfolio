@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 계정마스터 Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: [ 'Saknr' ]
define root view entity zc_b11_ska1
  as projection on zr_b11_ska1
{
  key SakUuid,
      @ObjectModel.text.element: [ 'Txt20' ]
      @Search: { defaultSearchElement: true }
      Saknr,
      @ObjectModel.text.element: [ 'AccountTypeText' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_glact_f4', element: 'DomainValue'} }]
      Glact,
      Xloev,
      CreatedBy,
      CreatedAt,
      ChangedBy,
      ChangedAt,
      _AccountText[1: Spras = $session.system_language].Txt20         as Txt20,
      _AccountType[1: Language = $session.system_language].DomainText as AccountTypeText,
      /* Associations */
      _AccountText : redirected to composition child zc_b11_ska1text
}
