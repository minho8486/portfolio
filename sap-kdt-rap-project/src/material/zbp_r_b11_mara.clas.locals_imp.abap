CLASS lhc_maratext DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    " 자재 설명 언어 중복 검증
    METHODS CheckText FOR VALIDATE ON SAVE
      IMPORTING keys FOR MaraText~CheckText.

ENDCLASS.


CLASS lhc_maratext IMPLEMENTATION.

  METHOD CheckText.

    " 입력된 자재 설명 조회
    READ ENTITIES OF zr_b11_mara
      ENTITY MaraText
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_maratext).

      " 기존 상태 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_maratext-%tky
        %state_area = 'CHECK_TEXT'
      ) TO reported-maratext.

      " 동일 자재 + 언어 존재 여부 확인
      SELECT SINGLE COUNT( * )
        FROM ztb11mara_t
        WHERE mat_uuid = @ls_maratext-MatUuid
          AND spras    = @ls_maratext-Spras.

      IF sy-subrc = 0.

        " 저장 실패 처리
        APPEND VALUE #(
          %tky = ls_maratext-%tky
        ) TO failed-maratext.

        " 중복 언어 오류
        APPEND VALUE #(
          %tky        = ls_maratext-%tky
          %state_area = 'CHECK_TEXT'

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '016'
            severity = if_abap_behv_message=>severity-error
          )

          " 언어 필드 하이라이트
          %element-Spras = if_abap_behv=>mk-on

        ) TO reported-maratext.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.



CLASS lhc_Mara DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    " 인스턴스 권한 제어
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations
      FOR Mara RESULT result.

    " 필드 및 Action 동적 제어
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features
      FOR mara RESULT result.

    " 생성일 기본값 설정
    METHODS setcreateddate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR mara~setcreateddate.

    " 통화 기본값 설정
    METHODS setcurrencycode FOR DETERMINE ON MODIFY
      IMPORTING keys FOR mara~setcurrencycode.

    " 가격단위 기본값 설정
    METHODS setpriceunit FOR DETERMINE ON MODIFY
      IMPORTING keys FOR mara~setpriceunit.

    " 변경금지 플래그 설정
    METHODS setblocked FOR DETERMINE ON SAVE
      IMPORTING keys FOR mara~setblocked.

    " 자재번호 중복 검증
    METHODS checkmatnr FOR VALIDATE ON SAVE
      IMPORTING keys FOR mara~checkmatnr.

    " 플랜트 / 저장위치 검증
    METHODS checkplantstorage FOR VALIDATE ON SAVE
      IMPORTING keys FOR mara~checkplantstorage.

    " 생성일 검증
    METHODS checkdate FOR VALIDATE ON SAVE
      IMPORTING keys FOR mara~checkdate.

    " 자재유형 검증
    METHODS checkmtart FOR VALIDATE ON SAVE
      IMPORTING keys FOR mara~checkmtart.

    " 평가클래스 검증
    METHODS checkbklas FOR VALIDATE ON SAVE
      IMPORTING keys FOR mara~checkbklas.

    " 자재번호 자동채번
    METHODS setmatnr FOR DETERMINE ON SAVE
      IMPORTING keys FOR mara~setmatnr.

    " 삭제 플래그 Action
    METHODS setlvorm FOR MODIFY
      IMPORTING keys FOR ACTION mara~setlvorm.

    " 표준가격 검증
    METHODS checkstprs FOR VALIDATE ON SAVE
      IMPORTING keys FOR mara~checkstprs.

    " 가격단위 검증
    METHODS checkpeinh FOR VALIDATE ON SAVE
      IMPORTING keys FOR mara~checkpeinh.

ENDCLASS.



CLASS lhc_Mara IMPLEMENTATION.


  METHOD get_instance_authorizations.

    " 별도 인스턴스 권한 로직 없음

  ENDMETHOD.


  METHOD SetCreatedDate.

    " 신규 자재 생성일을 오늘 날짜로 설정
    MODIFY ENTITIES OF zr_b11_mara IN LOCAL MODE
      ENTITY Mara
        UPDATE FIELDS ( Ersda )
        WITH VALUE #(
          FOR key IN keys
          (
            %tky  = key-%tky
            Ersda = sy-datum
          )
        ).

  ENDMETHOD.


  METHOD SetCurrencyCode.

    " 통화 기본값을 KRW로 설정
    MODIFY ENTITIES OF zr_b11_mara IN LOCAL MODE
      ENTITY Mara
        UPDATE FIELDS ( Waers )
        WITH VALUE #(
          FOR key IN keys
          (
            %tky  = key-%tky
            Waers = 'KRW'
          )
        ).

  ENDMETHOD.


  METHOD SetPriceUnit.

    " 가격단위 기본값을 1로 설정
    MODIFY ENTITIES OF zr_b11_mara IN LOCAL MODE
      ENTITY Mara
        UPDATE FIELDS ( Peinh )
        WITH VALUE #(
          FOR key IN keys
          (
            %tky  = key-%tky
            Peinh = 1
          )
        ).

  ENDMETHOD.


  METHOD SetBlocked.

    " 변경금지 플래그 설정
    MODIFY ENTITIES OF zr_b11_mara IN LOCAL MODE
      ENTITY Mara
        UPDATE FIELDS ( Matfi )
        WITH VALUE #(
          FOR key IN keys
          (
            %tky  = key-%tky
            Matfi = 'X'
          )
        ).

  ENDMETHOD.


  METHOD get_instance_features.

    " 현재 자재 데이터 조회
    READ ENTITIES OF zr_b11_mara IN LOCAL MODE
      ENTITY Mara
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(result_mara).

    LOOP AT result_mara INTO DATA(ls_mara).

      APPEND VALUE #(
        %tky = ls_mara-%tky
      ) TO result ASSIGNING FIELD-SYMBOL(<ls_result>).

      " Draft / Active 제어
      IF ls_mara-%is_draft = if_abap_behv=>mk-on.
        <ls_result>-%action-SetLvorm = if_abap_behv=>fc-o-disabled.
        <ls_result>-%delete = if_abap_behv=>fc-o-enabled.
      ELSE.
        <ls_result>-%delete = if_abap_behv=>fc-o-disabled.
        IF ls_mara-Lvorm = 'X'.
          <ls_result>-%action-SetLvorm = if_abap_behv=>fc-o-disabled.
        ELSE.
          <ls_result>-%action-SetLvorm = if_abap_behv=>fc-o-enabled.
        ENDIF.
      ENDIF.

      " Active 자재 존재 여부 확인
      SELECT SINGLE mat_uuid
        FROM ztb11mara
        WHERE mat_uuid = @ls_mara-MatUuid
        INTO @DATA(lv_mat_uuid).

      IF sy-subrc = 0.
        " 기존 자재의 주요 기준정보 수정 제한
        <ls_result>-%field-Ersda = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Mtart = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Bklas = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Werks = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Lgort = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Lvorm = if_abap_behv=>fc-f-unrestricted.
      ELSE.
        " 신규 자재는 기준정보 입력 허용
        <ls_result>-%field-Ersda = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Mtart = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Bklas = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Werks = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Lgort = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Lvorm = if_abap_behv=>fc-f-read_only.
      ENDIF.

      " 통화는 항상 수정 불가
      <ls_result>-%field-Waers = if_abap_behv=>fc-f-read_only.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckMatnr.

    " 검증 대상 자재 조회
    READ ENTITIES OF zr_b11_mara
      ENTITY Mara
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_mara).

      " 기존 상태 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_mara-%tky
        %state_area = 'CHECK_MATNR'
      ) TO reported-mara.

      " 동일 자재번호 존재 여부 확인
      SELECT SINGLE matnr
        FROM ztb11mara
        WHERE matnr = @ls_mara-Matnr
        INTO @DATA(lv_matnr).

      IF sy-subrc = 0.

        " 저장 실패 처리
        APPEND VALUE #(
          %tky = ls_mara-%tky
        ) TO failed-mara.

        " 자재번호 중복 오류
        APPEND VALUE #(
          %tky        = ls_mara-%tky
          %state_area = 'CHECK_MATNR'

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '002'
            severity = if_abap_behv_message=>severity-error
          )

          " 자재번호 필드 하이라이트
          %element-Matnr = if_abap_behv=>mk-on

        ) TO reported-mara.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckPlantStorage.

    " 플랜트 / 저장위치 조회
    READ ENTITIES OF zr_b11_mara
      ENTITY Mara
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_mara).

      " 기존 상태 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_mara-%tky
        %state_area = 'CHECK_PLANT_STORAGE'
      ) TO reported-mara.

      " 플랜트 또는 저장위치 미입력
      IF ls_mara-Werks IS INITIAL
         OR ls_mara-Lgort IS INITIAL.

        " 저장 실패 처리
        APPEND VALUE #(
          %tky = ls_mara-%tky
        ) TO failed-mara.

        " 필수값 오류
        APPEND VALUE #(
          %tky        = ls_mara-%tky
          %state_area = 'CHECK_PLANT_STORAGE'

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '003'
            severity = if_abap_behv_message=>severity-error
          )

          " 미입력된 필드만 하이라이트
          %element-Werks = COND #(
            WHEN ls_mara-Werks IS INITIAL
            THEN if_abap_behv=>mk-on
          )

          %element-Lgort = COND #(
            WHEN ls_mara-Lgort IS INITIAL
            THEN if_abap_behv=>mk-on
          )

        ) TO reported-mara.

      ELSE.

        " 플랜트 유효성 확인
        SELECT SINGLE Werks
          FROM zi_b11_werks_f4
          WHERE Werks = @ls_mara-Werks
          INTO @DATA(lv_werks).

        IF sy-subrc <> 0.

          " 저장 실패 처리
          APPEND VALUE #(
            %tky = ls_mara-%tky
          ) TO failed-mara.

          " 플랜트 오류
          APPEND VALUE #(
            %tky        = ls_mara-%tky
            %state_area = 'CHECK_PLANT_STORAGE'

            %msg = new_message(
              id       = 'ZMCB11'
              number   = '004'
              severity = if_abap_behv_message=>severity-error
            )

            " 플랜트 필드 하이라이트
            %element-Werks = if_abap_behv=>mk-on

          ) TO reported-mara.

        ELSE.

          " 플랜트에 해당하는 저장위치 확인
          SELECT SINGLE Lgort
            FROM zi_b11_lgort_f4
            WHERE Werks = @ls_mara-Werks
              AND Lgort = @ls_mara-Lgort
            INTO @DATA(lv_lgort).

          IF sy-subrc <> 0.

            " 저장 실패 처리
            APPEND VALUE #(
              %tky = ls_mara-%tky
            ) TO failed-mara.

            " 저장위치 오류
            APPEND VALUE #(
              %tky        = ls_mara-%tky
              %state_area = 'CHECK_PLANT_STORAGE'

              %msg = new_message(
                id       = 'ZMCB11'
                number   = '005'
                severity = if_abap_behv_message=>severity-error
              )

              " 저장위치 필드 하이라이트
              %element-Lgort = if_abap_behv=>mk-on

            ) TO reported-mara.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckDate.

    " 생성일 조회
    READ ENTITIES OF zr_b11_mara
      ENTITY Mara
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    " 현재 날짜
    DATA(current_date) =
      cl_abap_context_info=>get_system_date( ).

    LOOP AT lt_result INTO DATA(ls_mara).

      " 기존 상태 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_mara-%tky
        %state_area = 'CHECK_DATE'
      ) TO reported-mara.

      " 미래 날짜 입력 방지
      IF ls_mara-Ersda > current_date.

        " 저장 실패 처리
        APPEND VALUE #(
          %tky = ls_mara-%tky
        ) TO failed-mara.

        " 미래 날짜 오류
        APPEND VALUE #(
          %tky        = ls_mara-%tky
          %state_area = 'CHECK_DATE'

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '006'
            severity = if_abap_behv_message=>severity-error
          )

          " 생성일 필드 하이라이트
          %element-Ersda = if_abap_behv=>mk-on

        ) TO reported-mara.

      ELSE.

        " 현재일과 생성일 차이 계산
        DATA(count_date) =
          current_date - ls_mara-Ersda.

        " 30일 이전 날짜 입력 방지
        IF count_date > 30.

          " 저장 실패 처리
          APPEND VALUE #(
            %tky = ls_mara-%tky
          ) TO failed-mara.

          " 30일 이전 날짜 오류
          APPEND VALUE #(
            %tky        = ls_mara-%tky
            %state_area = 'CHECK_DATE'

            %msg = new_message(
              id       = 'ZMCB11'
              number   = '015'
              severity = if_abap_behv_message=>severity-error
            )

            " 생성일 필드 하이라이트
            %element-Ersda = if_abap_behv=>mk-on

          ) TO reported-mara.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckMtart.

    " 자재유형 조회
    READ ENTITIES OF zr_b11_mara
      ENTITY Mara
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_mara).

      " 기존 상태 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_mara-%tky
        %state_area = 'CHECK_MTART'
      ) TO reported-mara.

      " 자재유형 필수값 확인
      IF ls_mara-Mtart IS INITIAL.

        " 저장 실패 처리
        APPEND VALUE #(
          %tky = ls_mara-%tky
        ) TO failed-mara.

        " 자재유형 필수값 오류
        APPEND VALUE #(
          %tky        = ls_mara-%tky
          %state_area = 'CHECK_MTART'

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '007'
            severity = if_abap_behv_message=>severity-error
          )

          " 자재유형 필드 하이라이트
          %element-Mtart = if_abap_behv=>mk-on

        ) TO reported-mara.

      ELSE.

        " 유효한 자재유형인지 확인
        SELECT SINGLE MaterialType
          FROM zi_b11_mtart_f4
          WHERE MaterialType = @ls_mara-Mtart
          INTO @DATA(lv_mtart).

        IF sy-subrc <> 0.

          " 저장 실패 처리
          APPEND VALUE #(
            %tky = ls_mara-%tky
          ) TO failed-mara.

          " 자재유형 유효성 오류
          APPEND VALUE #(
            %tky        = ls_mara-%tky
            %state_area = 'CHECK_MTART'

            %msg = new_message(
              id       = 'ZMCB11'
              number   = '008'
              severity = if_abap_behv_message=>severity-error
            )

            " 자재유형 필드 하이라이트
            %element-Mtart = if_abap_behv=>mk-on

          ) TO reported-mara.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckBklas.

    " 평가클래스 조회
    READ ENTITIES OF zr_b11_mara
      ENTITY Mara
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_mara).

      " 기존 상태 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_mara-%tky
        %state_area = 'CHECK_BKLAS'
      ) TO reported-mara.

      " 평가클래스 필수값 확인
      IF ls_mara-Bklas IS INITIAL.

        " 저장 실패 처리
        APPEND VALUE #(
          %tky = ls_mara-%tky
        ) TO failed-mara.

        " 평가클래스 필수값 오류
        APPEND VALUE #(
          %tky        = ls_mara-%tky
          %state_area = 'CHECK_BKLAS'

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '009'
            severity = if_abap_behv_message=>severity-error
          )

          " 평가클래스 필드 하이라이트
          %element-Bklas = if_abap_behv=>mk-on

        ) TO reported-mara.

      ELSE.

        " 유효한 평가클래스인지 확인
        SELECT SINGLE Bklas
          FROM zi_b11_bklas_f4
          WHERE Bklas = @ls_mara-Bklas
          INTO @DATA(lv_bklas).

        IF sy-subrc <> 0.

          " 저장 실패 처리
          APPEND VALUE #(
            %tky = ls_mara-%tky
          ) TO failed-mara.

          " 평가클래스 유효성 오류
          APPEND VALUE #(
            %tky        = ls_mara-%tky
            %state_area = 'CHECK_BKLAS'

            %msg = new_message(
              id       = 'ZMCB11'
              number   = '010'
              severity = if_abap_behv_message=>severity-error
            )

            " 평가클래스 필드 하이라이트
            %element-Bklas = if_abap_behv=>mk-on

          ) TO reported-mara.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetMatnr.

    " 자재번호용 Number Range 값
    DATA lv_num TYPE numc09.

    " 신규 자재 조회
    READ ENTITIES OF zr_b11_mara
      ENTITY Mara
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(result_mara).

    LOOP AT result_mara INTO DATA(ls_mara).

      " Number Range 채번
      TRY.

          cl_numberrange_runtime=>number_get(
            EXPORTING
              object      = 'ZNRB1103'
              nr_range_nr = '01'
            IMPORTING
              number      = DATA(lv_number_raw)
              returncode  = DATA(lv_returncode)
          ).

        CATCH cx_number_ranges INTO DATA(lx_nr).

          " 채번 오류 메시지
          APPEND VALUE #(
            %tky = ls_mara-%tky

            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text     = lx_nr->get_text( )
            )

          ) TO reported-mara.

      ENDTRY.

      " 채번값을 자재번호 형식으로 변환
      lv_num = lv_number_raw.

      DATA(lv_matnr) = |M{ lv_num }|.

      " 자재번호 저장
      MODIFY ENTITIES OF zr_b11_mara IN LOCAL MODE
        ENTITY Mara
          UPDATE FIELDS ( Matnr )
          WITH VALUE #(
            (
              %tky  = ls_mara-%tky
              Matnr = lv_matnr
            )
          )
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_reported).

      " 자재번호 저장 실패
      IF lt_failed IS NOT INITIAL.

        APPEND VALUE #(
          %tky = ls_mara-%tky

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '032'
            severity = if_abap_behv_message=>severity-error
          )

        ) TO reported-mara.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetLvorm.

    " 선택된 자재 조회
    READ ENTITIES OF zr_b11_mara IN LOCAL MODE
      ENTITY Mara
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(result_mara).

    LOOP AT result_mara INTO DATA(ls_mara).

      " 이미 삭제된 자재 확인
      IF ls_mara-Lvorm = 'X'.

        APPEND VALUE #(
          %tky = ls_mara-%tky

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '041'
            severity = if_abap_behv_message=>severity-error
          )

        ) TO reported-mara.

        APPEND VALUE #(
          %tky = ls_mara-%tky
        ) TO failed-mara.

        CONTINUE.

      ENDIF.

      " 삭제 플래그 설정
      MODIFY ENTITIES OF zr_b11_mara IN LOCAL MODE
        ENTITY Mara
          UPDATE FIELDS ( Lvorm )
          WITH VALUE #(
            (
              %tky  = ls_mara-%tky
              Lvorm = 'X'
            )
          )
        FAILED DATA(lt_failed).

      " 삭제 처리 실패
      IF lt_failed IS NOT INITIAL.

        APPEND VALUE #(
          %tky = ls_mara-%tky

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '042'
            severity = if_abap_behv_message=>severity-error
          )

        ) TO reported-mara.

        APPEND VALUE #(
          %tky = ls_mara-%tky
        ) TO failed-mara.

        CONTINUE.

      ENDIF.

      " 삭제 처리 성공
      APPEND VALUE #(
        %tky = ls_mara-%tky

        %msg = new_message(
          id       = 'ZMCB11'
          number   = '043'
          severity = if_abap_behv_message=>severity-success
        )

      ) TO reported-mara.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckStprs.

    " 표준가격 조회
    READ ENTITIES OF zr_b11_mara IN LOCAL MODE
      ENTITY Mara
        FIELDS ( Stprs )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_mara).

      " 기존 상태 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_mara-%tky
        %state_area = 'CHECK_STPRS'
      ) TO reported-mara.

      " 표준가격 음수 입력 방지
      IF ls_mara-Stprs < 0.

        " 저장 실패 처리
        APPEND VALUE #(
          %tky = ls_mara-%tky
        ) TO failed-mara.

        " 오류 메시지 + 표준가격 필드 하이라이트
        APPEND VALUE #(
          %tky        = ls_mara-%tky
          %state_area = 'CHECK_STPRS'

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '058'
            severity = if_abap_behv_message=>severity-error
          )

          %element-Stprs = if_abap_behv=>mk-on

        ) TO reported-mara.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckPeinh.

    " 가격단위 조회
    READ ENTITIES OF zr_b11_mara
      ENTITY Mara
        FIELDS ( Peinh )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_mara).

      " 기존 상태 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_mara-%tky
        %state_area = 'CHECK_PEINH'
      ) TO reported-mara.

      " 가격단위 음수 입력 방지
      IF ls_mara-Peinh < 0.

        " 저장 실패 처리
        APPEND VALUE #(
          %tky = ls_mara-%tky
        ) TO failed-mara.

        " 가격단위 오류
        APPEND VALUE #(
          %tky        = ls_mara-%tky
          %state_area = 'CHECK_PEINH'

          %msg = new_message(
            id       = 'ZMCB11'
            number   = '061'
            severity = if_abap_behv_message=>severity-error
          )

          " 가격단위 필드 하이라이트
          %element-Peinh = if_abap_behv=>mk-on

        ) TO reported-mara.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
