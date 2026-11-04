CLASS lhc_Vendor DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Vendor RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR vendor RESULT result.

    METHODS setcurrency FOR DETERMINE ON MODIFY
      IMPORTING keys FOR vendor~setcurrency.

    METHODS setlifnr FOR DETERMINE ON SAVE
      IMPORTING keys FOR vendor~setlifnr.

    METHODS setdelation FOR MODIFY
      IMPORTING keys FOR ACTION vendor~setdelation.

    METHODS checkrequired FOR VALIDATE ON SAVE
      IMPORTING keys FOR vendor~checkrequired.

    METHODS checkaccount FOR VALIDATE ON SAVE
      IMPORTING keys FOR vendor~checkaccount.

    METHODS checkfdgrv FOR VALIDATE ON SAVE
      IMPORTING keys FOR vendor~checkfdgrv.

    METHODS checkminbw FOR VALIDATE ON SAVE
      IMPORTING keys FOR vendor~checkminbw.
    METHODS clearsakuuid FOR DETERMINE ON SAVE
      IMPORTING keys FOR vendor~clearsakuuid.

ENDCLASS.


CLASS lhc_Vendor IMPLEMENTATION.


  METHOD get_instance_authorizations.

  ENDMETHOD.


  METHOD get_instance_features.

    " 벤더 조회
    READ ENTITIES OF zr_b11_lfa1 IN LOCAL MODE
      ENTITY Vendor
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(result_vendor).

    LOOP AT result_vendor INTO DATA(ls_vendor).

      APPEND VALUE #(
        %tky = ls_vendor-%tky
      ) TO result ASSIGNING FIELD-SYMBOL(<ls_result>).

      " Draft 상태
      IF ls_vendor-%is_draft = if_abap_behv=>mk-on.
        <ls_result>-%action-SetDelation = if_abap_behv=>fc-o-disabled.
        <ls_result>-%delete = if_abap_behv=>fc-o-enabled.
      ELSE.
        " Active 상태
        <ls_result>-%delete = if_abap_behv=>fc-o-disabled.
        IF ls_vendor-Loevm = 'X'.
          <ls_result>-%action-SetDelation = if_abap_behv=>fc-o-disabled.
        ELSE.
          <ls_result>-%action-SetDelation = if_abap_behv=>fc-o-enabled.
        ENDIF.
      ENDIF.

      " 기존 벤더 확인
      SELECT SINGLE COUNT( * )
        FROM ztb11lfa1
        WHERE lif_uuid = @ls_vendor-LifUuid.

      IF sy-subrc = 0.
        <ls_result>-%field-Fdgrv = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Loevm = if_abap_behv=>fc-f-unrestricted.
      ELSE.
        <ls_result>-%field-Fdgrv = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Loevm = if_abap_behv=>fc-f-read_only.
      ENDIF.

      " 통화 수정 불가
      <ls_result>-%field-Waers = if_abap_behv=>fc-f-read_only.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetCurrency.

    " 통화 기본값 설정
    MODIFY ENTITIES OF zr_b11_lfa1 IN LOCAL MODE
      ENTITY Vendor
        UPDATE FIELDS ( Waers )
        WITH VALUE #(
          FOR key IN keys
          (
            %tky  = key-%tky
            Waers = 'KRW'
          )
        ).

  ENDMETHOD.


  METHOD SetLifnr.

    DATA: lv_num  TYPE n LENGTH 9,
          lv_nrnr TYPE nrnr.

    " 벤더 조회
    READ ENTITIES OF zr_b11_lfa1 IN LOCAL MODE
      ENTITY Vendor
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(result_vendor).

    LOOP AT result_vendor INTO DATA(ls_vendor).

      " 기존 번호가 있으면 제외
      IF ls_vendor-Lifnr IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      " 계정그룹별 Number Range
      CASE ls_vendor-Fdgrv.
        WHEN 'A1'.
          lv_nrnr = '01'.
        WHEN 'A2'.
          lv_nrnr = '02'.
        WHEN 'A3'.
          lv_nrnr = '03'.
        WHEN 'A4'.
          lv_nrnr = '04'.
        WHEN 'A5'.
          lv_nrnr = '05'.
        WHEN 'A6'.
          lv_nrnr = '06'.
      ENDCASE.

      " Number Range 채번
      TRY.

          cl_numberrange_runtime=>number_get(
            EXPORTING
              object      = 'ZNRB1101'
              nr_range_nr = lv_nrnr
            IMPORTING
              number      = DATA(lv_num_raw)
              returncode  = DATA(lv_returncode)
          ).

        CATCH cx_number_ranges INTO DATA(lx_nr).

          APPEND VALUE #(
            %tky = ls_vendor-%tky

            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text     = lx_nr->get_text( )
            )

          ) TO reported-vendor.

          RETURN.

      ENDTRY.

      " 벤더번호 생성
      lv_num = lv_num_raw.

      DATA(lv_lifnr) = |V{ lv_num }|.

      " 벤더번호 저장
      MODIFY ENTITIES OF zr_b11_lfa1 IN LOCAL MODE
        ENTITY Vendor
          UPDATE FIELDS ( Lifnr )
          WITH VALUE #(
            (
              %tky  = ls_vendor-%tky
              Lifnr = lv_lifnr
            )
          )
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_reported).

      " 저장 실패
      IF lt_failed IS NOT INITIAL.

        APPEND VALUE #(
          %tky = ls_vendor-%tky

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '032'
            severity = if_abap_behv_message=>severity-error
          )

        ) TO reported-vendor.

        RETURN.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetDelation.

    " 벤더 조회
    READ ENTITIES OF zr_b11_lfa1
      ENTITY Vendor
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(result_vendor).

    LOOP AT result_vendor INTO DATA(ls_vendor).

      " 이미 삭제된 벤더
      IF ls_vendor-Loevm = 'X'.

        APPEND VALUE #(
          %tky = ls_vendor-%tky

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '018'
            severity = if_abap_behv_message=>severity-error
          )

        ) TO reported-vendor.

        RETURN.

      ENDIF.

      " 삭제 플래그 설정
      MODIFY ENTITIES OF zr_b11_lfa1
        ENTITY Vendor
          UPDATE FIELDS ( Loevm )
          WITH VALUE #(
            (
              %tky  = ls_vendor-%tky
              Loevm = 'X'
            )
          )
        FAILED DATA(lt_failed).

      " 삭제 실패
      IF lt_failed IS NOT INITIAL.

        APPEND VALUE #(
          %tky = ls_vendor-%tky

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '019'
            severity = if_abap_behv_message=>severity-error
          )

        ) TO reported-vendor.

      ELSE.

        " 삭제 성공
        APPEND VALUE #(
          %tky = ls_vendor-%tky

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '020'
            severity = if_abap_behv_message=>severity-success
          )

        ) TO reported-vendor.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckRequired.

    " 벤더 조회
    READ ENTITIES OF zr_b11_lfa1
      ENTITY Vendor
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_vendor).

      " 기존 상태 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_vendor-%tky
        %state_area = 'CHECK_REQUIRED'
      ) TO reported-vendor.

      " 계정그룹 필수값 확인
      IF ls_vendor-Fdgrv IS INITIAL.

        APPEND VALUE #(
          %tky = ls_vendor-%tky
        ) TO failed-vendor.

        APPEND VALUE #(
          %tky        = ls_vendor-%tky
          %state_area = 'CHECK_REQUIRED'

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '021'
            severity = if_abap_behv_message=>severity-error
          )

          %element-Fdgrv = if_abap_behv=>mk-on

        ) TO reported-vendor.

      ENDIF.

      " 벤더명 필수값 확인
      IF ls_vendor-Name1 IS INITIAL.

        APPEND VALUE #(
          %tky = ls_vendor-%tky
        ) TO failed-vendor.

        APPEND VALUE #(
          %tky        = ls_vendor-%tky
          %state_area = 'CHECK_REQUIRED'

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '022'
            severity = if_abap_behv_message=>severity-error
          )

          %element-Name1 = if_abap_behv=>mk-on

        ) TO reported-vendor.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckAccount.

    " 벤더 조회
    READ ENTITIES OF zr_b11_lfa1
      ENTITY Vendor
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_vendor).

      " 기존 상태 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_vendor-%tky
        %state_area = 'CHECK_ACCOUNT'
      ) TO reported-vendor.

      " 계정 확인
      SELECT SINGLE sak_uuid, xloev
        FROM ztb11ska1
        WHERE sak_uuid = @ls_vendor-AkontUuid
        INTO @DATA(ls_vendorinfo).

      IF sy-subrc <> 0.

        APPEND VALUE #(
          %tky = ls_vendor-%tky
        ) TO failed-vendor.

        " 존재하지 않는 계정
        APPEND VALUE #(
          %tky        = ls_vendor-%tky
          %state_area = 'CHECK_ACCOUNT'

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '023'
            severity = if_abap_behv_message=>severity-error
          )

          %element-Saknr = if_abap_behv=>mk-on

        ) TO reported-vendor.

      ELSEIF ls_vendorinfo-xloev = 'X'.

        APPEND VALUE #(
          %tky = ls_vendor-%tky
        ) TO failed-vendor.

        " 삭제된 계정
        APPEND VALUE #(
          %tky        = ls_vendor-%tky
          %state_area = 'CHECK_ACCOUNT'

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '062'
            severity = if_abap_behv_message=>severity-error
          )

          %element-Saknr = if_abap_behv=>mk-on

        ) TO reported-vendor.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckFdgrv.

    " 벤더 조회
    READ ENTITIES OF zr_b11_lfa1
      ENTITY Vendor
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_vendor).

      " 기존 상태 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_vendor-%tky
        %state_area = 'CHECK_FDGRV'
      ) TO reported-vendor.

      " 계정그룹 유효성 확인
      SELECT SINGLE COUNT( * )
        FROM zi_b11_fdgrv_f4
        WHERE DomainValue = @ls_vendor-Fdgrv.

      IF sy-subrc <> 0.

        APPEND VALUE #(
          %tky = ls_vendor-%tky
        ) TO failed-vendor.

        APPEND VALUE #(
          %tky        = ls_vendor-%tky
          %state_area = 'CHECK_FDGRV'

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '024'
            severity = if_abap_behv_message=>severity-error
          )

          %element-Fdgrv = if_abap_behv=>mk-on

        ) TO reported-vendor.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckMinbw.

    " 최소주문금액 조회
    READ ENTITIES OF zr_b11_lfa1
      ENTITY Vendor
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_vendor).

      " 기존 상태 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_vendor-%tky
        %state_area = 'CHECK_MINBW'
      ) TO reported-vendor.

      " 음수 입력 방지
      IF ls_vendor-Minbw < 0.

        APPEND VALUE #(
          %tky = ls_vendor-%tky
        ) TO failed-vendor.

        APPEND VALUE #(
          %tky        = ls_vendor-%tky
          %state_area = 'CHECK_MINBW'

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '058'
            severity = if_abap_behv_message=>severity-error
          )

          %element-Minbw = if_abap_behv=>mk-on

        ) TO reported-vendor.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD ClearSakUuid.

    READ ENTITIES OF zr_b11_lfa1 IN LOCAL MODE
      ENTITY Vendor
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_vendor).

      " 공급업체 확인
      SELECT SINGLE sak_uuid FROM ztb11ska1
        WHERE saknr = @ls_vendor-Saknr
        INTO @DATA(lv_sakuuid).

      IF sy-subrc <> 0 OR ls_vendor-Saknr IS INITIAL.
        MODIFY ENTITIES OF zr_b11_lfa1 IN LOCAL MODE
          ENTITY Vendor
          UPDATE FIELDS ( AkontUuid )
          WITH VALUE #( ( %tky = ls_vendor-%tky AkontUuid = VALUE #( ) ) ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
