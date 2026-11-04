CLASS lhc_piritem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR PIRItem RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR PIRItem RESULT result.

    METHODS SetPlantName FOR DETERMINE ON MODIFY
      IMPORTING keys FOR PIRItem~SetPlantName.

    METHODS SetPrdat FOR DETERMINE ON MODIFY
      IMPORTING keys FOR PIRItem~SetPrdat.

    METHODS SetWaers FOR DETERMINE ON MODIFY
      IMPORTING keys FOR PIRItem~SetWaers.

    METHODS SetMeins FOR DETERMINE ON MODIFY
      IMPORTING keys FOR PIRItem~SetMeins.

    METHODS SetNetpr FOR DETERMINE ON SAVE
      IMPORTING keys FOR PIRItem~SetNetpr.

    METHODS CheckPlant FOR VALIDATE ON SAVE
      IMPORTING keys FOR PIRItem~CheckPlant.

    METHODS CheckPrdat FOR VALIDATE ON SAVE
      IMPORTING keys FOR PIRItem~CheckPrdat.

    METHODS SetBlocked FOR MODIFY
      IMPORTING keys FOR ACTION PIRItem~SetBlocked.

    METHODS CheckAplfz FOR VALIDATE ON SAVE
      IMPORTING keys FOR PIRItem~CheckAplfz.

    METHODS CheckBstma FOR VALIDATE ON SAVE
      IMPORTING keys FOR PIRItem~CheckBstma.

    METHODS CheckMinbm FOR VALIDATE ON SAVE
      IMPORTING keys FOR PIRItem~CheckMinbm.

    METHODS CheckNetpr FOR VALIDATE ON SAVE
      IMPORTING keys FOR PIRItem~CheckNetpr.

ENDCLASS.


CLASS lhc_piritem IMPLEMENTATION.

  METHOD get_instance_authorizations.

  ENDMETHOD.


  METHOD get_instance_features.

    " Item 조회
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_item).

    LOOP AT result_item INTO DATA(ls_item).

      APPEND VALUE #(
        %tky = ls_item-%tky
      ) TO result ASSIGNING FIELD-SYMBOL(<ls_result>).

      " Active Item 확인
      SELECT SINGLE inf_uuid
        FROM ztb11eine
        WHERE inf_uuid = @ls_item-InfUuid
          AND werks    = @ls_item-Werks
        INTO @DATA(lv_active_item).

      IF sy-subrc <> 0.

        <ls_result>-%action-SetBlocked = if_abap_behv=>fc-o-disabled.
        <ls_result>-%delete = if_abap_behv=>fc-o-enabled.

      ELSE.

        <ls_result>-%delete = if_abap_behv=>fc-o-disabled.

        IF ls_item-Loekz = 'X'.
          <ls_result>-%action-SetBlocked = if_abap_behv=>fc-o-disabled.
        ELSE.
          <ls_result>-%action-SetBlocked = if_abap_behv=>fc-o-enabled.
        ENDIF.

      ENDIF.

      " 기존 Item 확인
      SELECT SINGLE inf_uuid
        FROM ztb11eine
        WHERE inf_uuid = @ls_item-InfUuid
          AND werks    = @ls_item-Werks
        INTO @DATA(lv_infuuid).

      IF sy-subrc = 0.
        <ls_result>-%field-Loekz = if_abap_behv=>fc-f-unrestricted.
      ELSE.
        <ls_result>-%field-Loekz = if_abap_behv=>fc-f-read_only.
      ENDIF.

      " 수정 불가
      <ls_result>-%field-Waers = if_abap_behv=>fc-f-read_only.
      <ls_result>-%field-Meins = if_abap_behv=>fc-f-read_only.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetPlantName.

    " 플랜트명 설정
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRItem
      FIELDS ( Werks )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      SELECT SINGLE PlantName
        FROM zi_b11_werks_f4
        WHERE Werks = @ls_item-Werks
        INTO @DATA(lv_pname).

      IF sy-subrc = 0.

        MODIFY ENTITIES OF zr_b11_eina IN LOCAL MODE
          ENTITY PIRItem
          UPDATE FIELDS ( PlantName )
          WITH VALUE #(
            (
              %tky      = ls_item-%tky
              PlantName = lv_pname
            )
          ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetPrdat.

    " 유효종료일 기본값
    MODIFY ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRItem
      UPDATE FIELDS ( Prdat )
      WITH VALUE #(
        FOR key IN keys
        (
          %tky  = key-%tky
          Prdat = '99991231'
        )
      ).

  ENDMETHOD.


  METHOD SetWaers.

    " 통화 기본값
    MODIFY ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRItem
      UPDATE FIELDS ( Waers )
      WITH VALUE #(
        FOR key IN keys
        (
          %tky  = key-%tky
          Waers = 'KRW'
        )
      ).

  ENDMETHOD.


  METHOD SetMeins.

    " Header 단위 조회
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRHeader
      FIELDS ( Meins )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    IF lt_header IS NOT INITIAL.

      LOOP AT lt_header INTO DATA(ls_header).

        MODIFY ENTITIES OF zr_b11_eina IN LOCAL MODE
          ENTITY PIRItem
          UPDATE FIELDS ( Meins )
          WITH VALUE #(
            FOR key IN keys
            (
              %tky  = key-%tky
              Meins = ls_header-Meins
            )
          ).

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD SetNetpr.

    " Item 조회
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRItem
      FIELDS ( InfUuid Netpr Minbm )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    " Header 조회
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRItem BY \_PIRHeader
      FIELDS ( MaterialUuid VendorUuid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    LOOP AT lt_item INTO DATA(ls_item).

      " Header 연결
      READ TABLE lt_header INTO DATA(ls_header)
        WITH KEY InfUuid = ls_item-InfUuid.

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      DATA(lv_netpr) = ls_item-Netpr.

      " 단가 없으면 표준가격
      IF lv_netpr IS INITIAL.

        SELECT SINGLE stprs
          FROM ztb11mara
          WHERE mat_uuid = @ls_header-MaterialUuid
          INTO @DATA(lv_stprs).

        IF sy-subrc <> 0 OR lv_stprs IS INITIAL.
          CONTINUE.
        ENDIF.

        lv_netpr = lv_stprs.

      ENDIF.

      DATA lv_minbm LIKE ls_item-Minbm.

      " 최소주문수량 계산
      IF ls_header-VendorUuid IS NOT INITIAL AND ls_item-Minbm IS INITIAL.

        SELECT SINGLE minbw
          FROM ztb11lfa1
          WHERE lif_uuid = @ls_header-VendorUuid
          INTO @DATA(lv_minbw).

        IF sy-subrc = 0
          AND lv_minbw IS NOT INITIAL
          AND lv_netpr IS NOT INITIAL.

          lv_minbm = ceil( lv_minbw / lv_netpr ).

        ENDIF.

      ENDIF.

      MODIFY ENTITIES OF zr_b11_eina IN LOCAL MODE
        ENTITY PIRItem
        UPDATE FIELDS ( Netpr Minbm )
        WITH VALUE #(
          (
            %tky  = ls_item-%tky
            Netpr = lv_netpr
            Minbm = lv_minbm
          )
        ).

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckPlant.

    " 플랜트 확인
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_item).

      IF ls_item-Werks IS INITIAL.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-piritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '033'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Werks = if_abap_behv=>mk-on
        ) TO reported-piritem.

      ELSE.

        SELECT SINGLE Werks
          FROM zi_b11_werks_f4
          WHERE Werks = @ls_item-Werks
          INTO @DATA(lv_werks).

        IF sy-subrc <> 0.

          APPEND VALUE #(
            %tky = ls_item-%tky
          ) TO failed-piritem.

          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '004'
              severity = if_abap_behv_message=>severity-error
            )
            %element-Werks = if_abap_behv=>mk-on
          ) TO reported-piritem.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckPrdat.

    " 유효종료일 확인
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_item).

      IF ls_item-Prdat IS INITIAL.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-piritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '034'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Prdat = if_abap_behv=>mk-on
        ) TO reported-piritem.

      ELSEIF ls_item-Prdat < sy-datum.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-piritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '035'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Prdat = if_abap_behv=>mk-on
        ) TO reported-piritem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetBlocked.

    " Item 조회
    READ ENTITIES OF zr_b11_eina
      ENTITY PIRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_item).

    LOOP AT result_item INTO DATA(ls_item).

      IF ls_item-Loekz = 'X'.

        " 이미 취소
        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '038'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Prdat = if_abap_behv=>mk-on
        ) TO reported-piritem.

        RETURN.

      ELSE.

        " 취소 처리
        MODIFY ENTITIES OF zr_b11_eina
          ENTITY PIRItem
          UPDATE FIELDS ( Loekz Prdat )
          WITH VALUE #(
            FOR key IN keys
            (
              %tky  = ls_item-%tky
              Loekz = 'X'
              Prdat = sy-datum
            )
          )
          FAILED DATA(lt_failed).

        IF lt_failed IS NOT INITIAL.

          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '039'
              severity = if_abap_behv_message=>severity-error
            )
            %element-Prdat = if_abap_behv=>mk-on
          ) TO reported-piritem.

        ELSE.

          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '040'
              severity = if_abap_behv_message=>severity-success
            )
            %element-Prdat = if_abap_behv=>mk-on
          ) TO reported-piritem.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckAplfz.

    " 예정배송일 확인
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_item).

    LOOP AT result_item INTO DATA(ls_item).

      IF ls_item-Aplfz < 0.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-piritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '064'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Aplfz = if_abap_behv=>mk-on
        ) TO reported-piritem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckBstma.

    " 최대수량 확인
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_item).

    LOOP AT result_item INTO DATA(ls_item).

      IF ls_item-Bstma < 0.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-piritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '061'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Bstma = if_abap_behv=>mk-on
        ) TO reported-piritem.

      ELSEIF ls_item-Minbm IS NOT INITIAL
        AND ls_item-Minbm >= ls_item-Bstma.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-piritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '065'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Bstma = if_abap_behv=>mk-on
        ) TO reported-piritem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckMinbm.

    " 최소수량 확인
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_item).

    LOOP AT result_item INTO DATA(ls_item).

      IF ls_item-Minbm < 0.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-piritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '061'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Minbm = if_abap_behv=>mk-on
        ) TO reported-piritem.

      ELSEIF ls_item-Bstma IS NOT INITIAL
        AND ls_item-Minbm >= ls_item-Bstma.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-piritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '065'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Minbm = if_abap_behv=>mk-on
        ) TO reported-piritem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckNetpr.

    " 단가 확인
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_item).

    LOOP AT result_item INTO DATA(ls_item).

      IF ls_item-Netpr < 0.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-piritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '058'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Netpr = if_abap_behv=>mk-on
        ) TO reported-piritem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.



CLASS lhc_PIRHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR PIRHeader RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR pirheader RESULT result.

    METHODS setmeins FOR DETERMINE ON SAVE
      IMPORTING keys FOR pirheader~setmeins.

    METHODS setinfnf FOR DETERMINE ON SAVE
      IMPORTING keys FOR pirheader~setinfnf.

    METHODS checkmatnr FOR VALIDATE ON SAVE
      IMPORTING keys FOR pirheader~checkmatnr.

    METHODS checklifnr FOR VALIDATE ON SAVE
      IMPORTING keys FOR pirheader~checklifnr.

    METHODS setblocked FOR MODIFY
      IMPORTING keys FOR ACTION pirheader~setblocked.

    METHODS checksemantickeys FOR VALIDATE ON SAVE
      IMPORTING keys FOR pirheader~checksemantickeys.

    METHODS clearuuid FOR DETERMINE ON SAVE
      IMPORTING keys FOR pirheader~clearuuid.

ENDCLASS.


CLASS lhc_PIRHeader IMPLEMENTATION.

  METHOD get_instance_authorizations.

  ENDMETHOD.


  METHOD get_instance_features.

    " Header 조회
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRHeader
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_header).

    LOOP AT result_header INTO DATA(ls_header).

      APPEND VALUE #(
        %tky = ls_header-%tky
      ) TO result ASSIGNING FIELD-SYMBOL(<ls_result>).

      " Draft / Active 제어
      IF ls_header-%is_draft = if_abap_behv=>mk-on.

        <ls_result>-%action-SetBlocked = if_abap_behv=>fc-o-disabled.
        <ls_result>-%delete = if_abap_behv=>fc-o-enabled.

      ELSE.

        <ls_result>-%delete = if_abap_behv=>fc-o-disabled.
        IF ls_header-Loekz = 'X'.
          <ls_result>-%action-SetBlocked = if_abap_behv=>fc-o-disabled.
        ELSE.
          <ls_result>-%action-SetBlocked = if_abap_behv=>fc-o-enabled.
        ENDIF.

      ENDIF.

      " 기존 Header 확인
      SELECT SINGLE inf_uuid
        FROM ztb11eina
        WHERE inf_uuid = @ls_header-InfUuid
        INTO @DATA(lv_infuuid).

      IF sy-subrc = 0.

        <ls_result>-%field-Loekz = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Lifnr = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Matnr = if_abap_behv=>fc-f-read_only.

      ELSE.

        <ls_result>-%field-Loekz = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Lifnr = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Matnr = if_abap_behv=>fc-f-unrestricted.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetMeins.

    " 기본단위 설정
    READ ENTITIES OF zr_b11_eina
      ENTITY PIRHeader
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_header).

      IF ls_header-Meins IS INITIAL.

        SELECT SINGLE meins
          FROM ztb11mara
          WHERE mat_uuid = @ls_header-MaterialUuid
          INTO @DATA(lv_meins).

        MODIFY ENTITIES OF zr_b11_eina IN LOCAL MODE
          ENTITY PIRHeader
          UPDATE FIELDS ( Meins )
          WITH VALUE #(
            FOR key IN keys
            (
              %tky  = key-%tky
              Meins = lv_meins
            )
          ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetInfnf.

    DATA lv_num TYPE numc10.

    " Header 조회
    READ ENTITIES OF zc_b11_eina
      ENTITY zc_b11_eina
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_header).

    LOOP AT result_header INTO DATA(ls_header).

      IF ls_header-Infnr IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      " 구매정보번호 채번
      TRY.

          cl_numberrange_runtime=>number_get(
            EXPORTING
              object      = 'ZNRB1102'
              nr_range_nr = '01'
            IMPORTING
              number      = DATA(lv_number_raw)
              returncode  = DATA(lv_returncode)
          ).

        CATCH cx_number_ranges INTO DATA(lx_nr).

          APPEND VALUE #(
            %tky = ls_header-%tky
            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text     = lx_nr->get_text( )
            )
          ) TO reported-pirheader.

      ENDTRY.

      lv_num = lv_number_raw.

      MODIFY ENTITIES OF zr_b11_eina IN LOCAL MODE
        ENTITY PIRHeader
        UPDATE FIELDS ( Infnr )
        WITH VALUE #(
          (
            %tky  = ls_header-%tky
            Infnr = lv_num
          )
        )
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_reported).

      IF lt_failed IS NOT INITIAL.

        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '032'
            severity = if_abap_behv_message=>severity-error
          )
        ) TO reported-pirheader.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckMatnr.

    " 자재 확인
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRHeader
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_header).

      " 이전 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_header-%tky
        %state_area = 'CHECK_MATNR'
      ) TO reported-pirheader.

      IF ls_header-Matnr IS INITIAL.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-pirheader.

        APPEND VALUE #(
          %tky        = ls_header-%tky
          %state_area = 'CHECK_MATNR'
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '001'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Matnr = if_abap_behv=>mk-on
        ) TO reported-pirheader.

      ELSE.

        SELECT SINGLE matnr, lvorm
          FROM ztb11mara
          WHERE mat_uuid = @ls_header-MaterialUuid
          INTO @DATA(ls_material).

        IF sy-subrc <> 0.

          APPEND VALUE #(
            %tky = ls_header-%tky
          ) TO failed-pirheader.

          APPEND VALUE #(
            %tky        = ls_header-%tky
            %state_area = 'CHECK_MATNR'
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '031'
              severity = if_abap_behv_message=>severity-error
            )
            %element-Matnr = if_abap_behv=>mk-on
          ) TO reported-pirheader.

        ELSEIF ls_material-lvorm = 'X'.

          APPEND VALUE #(
            %tky = ls_header-%tky
          ) TO failed-pirheader.

          APPEND VALUE #(
            %tky        = ls_header-%tky
            %state_area = 'CHECK_MATNR'
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '050'
              severity = if_abap_behv_message=>severity-error
            )
            %element-Matnr = if_abap_behv=>mk-on
          ) TO reported-pirheader.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckLifnr.

    " 공급업체 확인
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRHeader
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_header).

      " 이전 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_header-%tky
        %state_area = 'CHECK_LIFNR'
      ) TO reported-pirheader.

      IF ls_header-Lifnr IS INITIAL.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-pirheader.

        APPEND VALUE #(
          %tky        = ls_header-%tky
          %state_area = 'CHECK_LIFNR'
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '036'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Lifnr = if_abap_behv=>mk-on
        ) TO reported-pirheader.

      ELSE.

        SELECT SINGLE lif_uuid, loevm
          FROM ztb11lfa1
          WHERE lif_uuid = @ls_header-VendorUuid
          INTO @DATA(ls_vendor).

        IF sy-subrc <> 0.

          APPEND VALUE #(
            %tky = ls_header-%tky
          ) TO failed-pirheader.

          APPEND VALUE #(
            %tky        = ls_header-%tky
            %state_area = 'CHECK_LIFNR'
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '037'
              severity = if_abap_behv_message=>severity-error
            )
            %element-Lifnr = if_abap_behv=>mk-on
          ) TO reported-pirheader.

        ELSEIF ls_vendor-loevm = 'X'.

          APPEND VALUE #(
            %tky = ls_header-%tky
          ) TO failed-pirheader.

          APPEND VALUE #(
            %tky        = ls_header-%tky
            %state_area = 'CHECK_LIFNR'
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '049'
              severity = if_abap_behv_message=>severity-error
            )
            %element-Lifnr = if_abap_behv=>mk-on
          ) TO reported-pirheader.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetBlocked.

    " Header 조회
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRHeader
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_header).

    LOOP AT result_header INTO DATA(ls_header).

      DATA(lv_failed) = abap_false.

      " 이미 취소
      IF ls_header-Loekz = 'X'.

        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '038'
            severity = if_abap_behv_message=>severity-error
          )
        ) TO reported-pirheader.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-pirheader.

        CONTINUE.

      ENDIF.

      " Header 취소
      MODIFY ENTITIES OF zr_b11_eina IN LOCAL MODE
        ENTITY PIRHeader
        UPDATE FIELDS ( Loekz )
        WITH VALUE #(
          (
            %tky  = ls_header-%tky
            Loekz = 'X'
          )
        )
        FAILED DATA(lt_failed_header).

      IF lt_failed_header-pirheader IS NOT INITIAL.
        lv_failed = abap_true.
      ENDIF.

      " Item 취소
      IF lv_failed = abap_false.

        READ ENTITIES OF zr_b11_eina IN LOCAL MODE
          ENTITY PIRHeader BY \_PIRItem
          ALL FIELDS
          WITH VALUE #(
            (
              %tky = ls_header-%tky
            )
          )
          RESULT DATA(result_item).

        LOOP AT result_item INTO DATA(ls_item).

          IF ls_item-Loekz = 'X'.
            CONTINUE.
          ENDIF.

          MODIFY ENTITIES OF zr_b11_eina IN LOCAL MODE
            ENTITY PIRItem
            UPDATE FIELDS ( Loekz Prdat )
            WITH VALUE #(
              (
                %tky  = ls_item-%tky
                Loekz = 'X'
                Prdat = sy-datum
              )
            )
            FAILED DATA(lt_failed_item).

          IF lt_failed_item-piritem IS NOT INITIAL.
            lv_failed = abap_true.
            EXIT.
          ENDIF.

        ENDLOOP.

      ENDIF.

      " 처리 실패
      IF lv_failed = abap_true.

        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '039'
            severity = if_abap_behv_message=>severity-error
          )
        ) TO reported-pirheader.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-pirheader.

        CONTINUE.

      ENDIF.

      " 처리 성공
      APPEND VALUE #(
        %tky = ls_header-%tky
        %msg = new_message(
          id       = 'ZMCB11'
          number   = '040'
          severity = if_abap_behv_message=>severity-success
        )
      ) TO reported-pirheader.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckSemanticKeys.

    " 의미적 키 중복 확인
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRHeader
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_header).

      " 이전 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_header-%tky
        %state_area = 'CHECK_SEMANTIC_KEYS'
      ) TO reported-pirheader.

      SELECT SINGLE inf_uuid
        FROM ztb11eina
        WHERE material_uuid = @ls_header-MaterialUuid
          AND vendor_uuid   = @ls_header-VendorUuid
        INTO @DATA(ls_infuuid).

      IF sy-subrc = 0.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-pirheader.

        APPEND VALUE #(
          %tky        = ls_header-%tky
          %state_area = 'CHECK_SEMANTIC_KEYS'
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '063'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Matnr = if_abap_behv=>mk-on
          %element-Lifnr = if_abap_behv=>mk-on
        ) TO reported-pirheader.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD ClearUuid.

    " Header 조회
    READ ENTITIES OF zr_b11_eina IN LOCAL MODE
      ENTITY PIRHeader
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_header).

      " 공급업체 확인
      SELECT SINGLE lif_uuid
        FROM ztb11lfa1
        WHERE lifnr = @ls_header-Lifnr
        INTO @DATA(lv_lifuuid).

      IF sy-subrc <> 0 OR ls_header-Lifnr IS INITIAL.

        MODIFY ENTITIES OF zr_b11_eina IN LOCAL MODE
          ENTITY PIRHeader
          UPDATE FIELDS ( VendorUuid )
          WITH VALUE #(
            (
              %tky       = ls_header-%tky
              VendorUuid = VALUE #( )
            )
          ).

      ENDIF.

      " 자재 확인
      SELECT SINGLE mat_uuid
        FROM ztb11mara
        WHERE matnr = @ls_header-Matnr
        INTO @DATA(lv_matuuid).

      IF sy-subrc <> 0 OR ls_header-Matnr IS INITIAL.

        MODIFY ENTITIES OF zr_b11_eina IN LOCAL MODE
          ENTITY PIRHeader
          UPDATE FIELDS ( MaterialUuid )
          WITH VALUE #(
            (
              %tky         = ls_header-%tky
              MaterialUuid = VALUE #( )
            )
          ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
