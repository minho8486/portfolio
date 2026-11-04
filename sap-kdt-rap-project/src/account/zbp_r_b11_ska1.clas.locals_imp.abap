CLASS lhc_accounttext DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS CheckText FOR VALIDATE ON SAVE
      IMPORTING keys FOR AccountText~CheckText.

ENDCLASS.

CLASS lhc_accounttext IMPLEMENTATION.

  METHOD CheckText.

    READ ENTITIES OF zr_b11_ska1
    ENTITY AccountText
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_accounttext).

      SELECT SINGLE COUNT( * )
          FROM ztb11ska1_t
         WHERE sak_uuid = @ls_accounttext-SakUuid
           AND spras = @ls_accounttext-Spras.

      IF sy-subrc = 0.

        APPEND VALUE #(
            %tky = ls_accounttext-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '017'
              severity = if_abap_behv_message=>severity-error
            )

            %element-Spras = if_abap_behv=>mk-on

        ) TO reported-accounttext.

        APPEND VALUE #(
          %tky = ls_accounttext-%tky
        ) TO failed-accounttext.

        RETURN.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_Account DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Account RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR account RESULT result.

    METHODS checksaknr FOR VALIDATE ON SAVE
      IMPORTING keys FOR account~checksaknr.
    METHODS checkaccounttype FOR VALIDATE ON SAVE
      IMPORTING keys FOR account~checkaccounttype.
    METHODS setremoved FOR MODIFY
      IMPORTING keys FOR ACTION account~setremoved.

ENDCLASS.

CLASS lhc_Account IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zr_b11_ska1 IN LOCAL MODE
      ENTITY Account
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_account).

    LOOP AT result_account INTO DATA(ls_account).

      APPEND VALUE #(
        %tky = ls_account-%tky
      ) TO result ASSIGNING FIELD-SYMBOL(<ls_result>).

      <ls_result>-%delete = if_abap_behv=>fc-o-disabled.
      IF ls_account-Xloev = 'X'.
        <ls_result>-%action-SetRemoved = if_abap_behv=>fc-o-disabled.
      ELSE.
        <ls_result>-%action-SetRemoved = if_abap_behv=>fc-o-enabled.
      ENDIF.

      SELECT SINGLE COUNT( * )
        FROM ztb11ska1
        WHERE sak_uuid = @ls_account-SakUuid.

      IF sy-subrc = 0.
        <ls_result>-%field-Xloev = if_abap_behv=>fc-f-unrestricted.
      ELSE.
        <ls_result>-%field-Xloev = if_abap_behv=>fc-f-read_only.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD CheckSaknr.

    READ ENTITIES OF zr_b11_ska1
    ENTITY Account
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_account).

      IF ls_account-Saknr IS INITIAL.

        APPEND VALUE #(
            %tky = ls_account-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '011'
              severity = if_abap_behv_message=>severity-error
            )

            %element-Saknr = if_abap_behv=>mk-on

        ) TO reported-account.

        APPEND VALUE #(
          %tky = ls_account-%tky
        ) TO failed-account.

        RETURN.

      ENDIF.

      SELECT SINGLE Saknr
        FROM ztb11ska1
       WHERE saknr = @ls_account-Saknr
        INTO @DATA(lv_saknr).

      IF sy-subrc = 0.

        APPEND VALUE #(
            %tky = ls_account-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '013'
              severity = if_abap_behv_message=>severity-error
            )

            %element-Saknr = if_abap_behv=>mk-on

        ) TO reported-account.

        APPEND VALUE #(
          %tky = ls_account-%tky
        ) TO failed-account.

        RETURN.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD CheckAccountType.

    READ ENTITIES OF zr_b11_ska1
    ENTITY Account
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_account).

      IF ls_account-Glact IS INITIAL.

        APPEND VALUE #(
            %tky = ls_account-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '014'
              severity = if_abap_behv_message=>severity-error
            )

            %element-Glact = if_abap_behv=>mk-on

        ) TO reported-account.

        APPEND VALUE #(
          %tky = ls_account-%tky
        ) TO failed-account.

        RETURN.

      ENDIF.

      SELECT SINGLE DomainValue
        FROM zi_b11_glact_f4
       WHERE DomainValue = @ls_account-Glact
        INTO @DATA(lv_glact).

      IF sy-subrc <> 0.

        APPEND VALUE #(
            %tky = ls_account-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '012'
              severity = if_abap_behv_message=>severity-error
            )

            %element-Glact = if_abap_behv=>mk-on

        ) TO reported-account.

        APPEND VALUE #(
          %tky = ls_account-%tky
        ) TO failed-account.

        RETURN.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD SetRemoved.

    READ ENTITIES OF zr_b11_ska1 IN LOCAL MODE
      ENTITY Account
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(result_account).

    LOOP AT result_account INTO DATA(ls_account).

      IF ls_account-Xloev = 'X'.

        APPEND VALUE #(
          %tky = ls_account-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '041'
            severity = if_abap_behv_message=>severity-error
          )
        ) TO reported-account.

        APPEND VALUE #(
          %tky = ls_account-%tky
        ) TO failed-account.

        CONTINUE.

      ENDIF.

      MODIFY ENTITIES OF zr_b11_ska1 IN LOCAL MODE
        ENTITY Account
          UPDATE FIELDS ( Xloev )
          WITH VALUE #(
            (
              %tky  = ls_account-%tky
              Xloev = 'X'
            )
          )
        FAILED DATA(lt_failed).

      IF lt_failed IS NOT INITIAL.

        APPEND VALUE #(
          %tky = ls_account-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '044'
            severity = if_abap_behv_message=>severity-error
          )
        ) TO reported-account.

        APPEND VALUE #(
          %tky = ls_account-%tky
        ) TO failed-account.

        CONTINUE.

      ENDIF.

      APPEND VALUE #(
        %tky = ls_account-%tky
        %msg = new_message(
          id       = 'ZMCB11'
          number   = '045'
          severity = if_abap_behv_message=>severity-success
        )
      ) TO reported-account.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
