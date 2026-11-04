CLASS lhc_GRItem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_gritem FOR NUMBERING
      IMPORTING entities FOR CREATE grheader\_gritem.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR GRItem RESULT result.

    METHODS SetWaers FOR DETERMINE ON MODIFY
      IMPORTING keys FOR GRItem~SetWaers.

    METHODS SetBwart FOR DETERMINE ON MODIFY
      IMPORTING keys FOR GRItem~SetBwart.

    METHODS SetPoHeader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR GRItem~SetPoHeader.

    METHODS ClearPoHeader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR GRItem~ClearPoHeader.

    METHODS SetPoItem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR GRItem~SetPoItem.

    METHODS ClearPoItem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR GRItem~ClearPoItem.

    METHODS SetVendorUuid FOR DETERMINE ON MODIFY
      IMPORTING keys FOR GRItem~SetVendorUuid.

    METHODS CheckCurrency FOR VALIDATE ON SAVE
      IMPORTING keys FOR GRItem~CheckCurrency.

    METHODS CheckMasterData FOR VALIDATE ON SAVE
      IMPORTING keys FOR GRItem~CheckMasterData.

    METHODS CheckPoData FOR VALIDATE ON SAVE
      IMPORTING keys FOR GRItem~CheckPoData.

    METHODS CheckQuantityAmount FOR VALIDATE ON SAVE
      IMPORTING keys FOR GRItem~CheckQuantityAmount.

    METHODS CheckRequired FOR VALIDATE ON SAVE
      IMPORTING keys FOR GRItem~CheckRequired.

    METHODS UpdatePoStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR GRItem~UpdatePoStatus.

    METHODS CheckPoStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR GRItem~CheckPoStatus.

ENDCLASS.


CLASS lhc_GRItem IMPLEMENTATION.

  METHOD earlynumbering_cba_gritem.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_header>).

      DATA(lv_mblnr_uuid) = <fs_header>-MblnrUuid.

      " 기존 Item 조회
      READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
        ENTITY GRHeader BY \_GRItem
        FIELDS ( MblnrUuid Zeile )
        WITH VALUE #(
          (
            MblnrUuid = lv_mblnr_uuid
            %is_draft = <fs_header>-%is_draft
          )
        )
        RESULT DATA(lt_result).

      " 최대 순번 조회
      SORT lt_result BY Zeile DESCENDING.
      READ TABLE lt_result INDEX 1 INTO DATA(ls_result).

      DATA lv_zeile TYPE ztb11mseg-zeile.

      IF sy-subrc <> 0.
        lv_zeile = 10.
      ELSE.
        lv_zeile = ls_result-Zeile + 10.
      ENDIF.

      " 신규 Item 번호 설정
      LOOP AT <fs_header>-%target INTO DATA(ls_target).

        IF ls_target-Zeile IS INITIAL.

          APPEND VALUE #(
            %cid      = ls_target-%cid
            %is_draft = ls_target-%is_draft
            MblnrUuid = lv_mblnr_uuid
            Zeile     = lv_zeile
          ) TO mapped-gritem.

          lv_zeile = lv_zeile + 10.

        ELSE.

          APPEND VALUE #(
            %cid      = ls_target-%cid
            %is_draft = ls_target-%is_draft
            MblnrUuid = lv_mblnr_uuid
            Zeile     = ls_target-Zeile
          ) TO mapped-gritem.

        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_instance_features.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_item).

    LOOP AT result_item INTO DATA(ls_item).

      APPEND VALUE #(
        %tky = ls_item-%tky
      ) TO result ASSIGNING FIELD-SYMBOL(<ls_result>).

      SELECT SINGLE ebeln_uuid
        FROM ztb11ekpo
        WHERE ebeln_uuid = @ls_item-EbelnUuid
          AND ebelp      = @ls_item-Ebelp
        INTO @DATA(lv_active_item).

      " PO Header 선택 여부
      IF ls_item-EbelnUuid IS NOT INITIAL.
        <ls_result>-%field-Ebelp = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Lifnr = if_abap_behv=>fc-f-read_only.
      ELSE.
        <ls_result>-%field-Ebelp = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Lifnr = if_abap_behv=>fc-f-unrestricted.
      ENDIF.

      " PO Item 선택 여부
      IF ls_item-Ebelp IS NOT INITIAL.
        <ls_result>-%field-Meins = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Matnr = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Werks = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Dmbtr = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Lgort = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Menge = if_abap_behv=>fc-f-read_only.
      ELSE.
        <ls_result>-%field-Meins = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Matnr = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Werks = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Dmbtr = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Lgort = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Menge = if_abap_behv=>fc-f-unrestricted.
      ENDIF.

      <ls_result>-%field-Waers = if_abap_behv=>fc-f-read_only.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetWaers.

    " 통화 기본값
    MODIFY ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRItem
      UPDATE FIELDS ( Waers )
      WITH VALUE #(
        FOR key IN keys
        (
          %tky  = key-%tky
          Waers = 'KRW'
        )
      ).

  ENDMETHOD.


  METHOD SetBwart.

    " 이동유형 기본값
    MODIFY ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRItem
      UPDATE FIELDS ( Bwart )
      WITH VALUE #(
        FOR key IN keys
        (
          %tky  = key-%tky
          Bwart = '101'
        )
      ).

  ENDMETHOD.


  METHOD SetPoHeader.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      " PO Header 조회
      SELECT SINGLE Lifnr, LifUuid, VendorName, Podesc
        FROM zr_b11_ekko
        WHERE EbelnUuid = @ls_item-EbelnUuid
        INTO @DATA(ls_poheader).

      IF sy-subrc <> 0 OR ls_item-Ebeln IS INITIAL.
        CONTINUE.
      ENDIF.

      " Header 설정 및 Item 초기화
      MODIFY ENTITIES OF zr_b11_mkpf IN LOCAL MODE
        ENTITY GRItem
        UPDATE FIELDS (
          Lifnr LifUuid VendorName Podesc Ebelp
          Werks Lgort MatUuid Matnr Menge Meins
          Dmbtr Mtart Infnr InfUuid
        )
        WITH VALUE #(
          (
            %tky       = ls_item-%tky
            Lifnr      = ls_poheader-Lifnr
            LifUuid    = ls_poheader-LifUuid
            VendorName = ls_poheader-VendorName
            Podesc     = ls_poheader-Podesc
            Ebelp      = VALUE #( )
            Werks      = VALUE #( )
            Lgort      = VALUE #( )
            MatUuid    = VALUE #( )
            Matnr      = VALUE #( )
            Menge      = VALUE #( )
            Meins      = VALUE #( )
            Dmbtr      = VALUE #( )
            Mtart      = VALUE #( )
            Infnr      = VALUE #( )
            InfUuid    = VALUE #( )
          )
        ).

    ENDLOOP.

  ENDMETHOD.


  METHOD ClearPoHeader.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      " PO 존재 확인
      SELECT SINGLE ebeln_uuid
        FROM ztb11ekko
        WHERE ebeln = @ls_item-Ebeln
        INTO @DATA(lv_ebelnuuid).

      IF sy-subrc = 0 OR ls_item-Ebeln IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      " PO 정보 초기화
      MODIFY ENTITIES OF zr_b11_mkpf IN LOCAL MODE
        ENTITY GRItem
        UPDATE FIELDS (
          EbelnUuid Lifnr LifUuid VendorName Podesc Ebelp
          Werks Lgort MatUuid Matnr Menge Meins Dmbtr Mtart
          Infnr InfUuid
        )
        WITH VALUE #(
          (
            %tky       = ls_item-%tky
            EbelnUuid  = VALUE #( )
            Lifnr      = VALUE #( )
            LifUuid    = VALUE #( )
            VendorName = VALUE #( )
            Podesc     = VALUE #( )
            Ebelp      = VALUE #( )
            Werks      = VALUE #( )
            Lgort      = VALUE #( )
            MatUuid    = VALUE #( )
            Matnr      = VALUE #( )
            Menge      = VALUE #( )
            Meins      = VALUE #( )
            Dmbtr      = VALUE #( )
            Mtart      = VALUE #( )
            Infnr      = VALUE #( )
            InfUuid    = VALUE #( )
          )
        ).

    ENDLOOP.

  ENDMETHOD.


  METHOD SetPoItem.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      " PO Item 조회
      SELECT SINGLE Werks, Lgort, MatUuid, Matnr, Menge, Meins,
                    Netpr, Mtart, Infnr, InfUuid
        FROM zi_b11_ekpo
        WHERE EbelnUuid = @ls_item-EbelnUuid
          AND ebelp     = @ls_item-Ebelp
        INTO @DATA(ls_poitem).

      IF sy-subrc <> 0 OR ls_item-Ebelp IS INITIAL.
        CONTINUE.
      ENDIF.

      " 가격단위 조회
      SELECT SINGLE Peinh
        FROM zr_b11_mara
        WHERE MatUuid = @ls_poitem-MatUuid
        INTO @DATA(lv_peinh).

      DATA(lv_dmbtr) = ls_poitem-Netpr * ls_poitem-Menge / lv_peinh.

      " PO Item 정보 설정
      MODIFY ENTITIES OF zr_b11_mkpf IN LOCAL MODE
        ENTITY GRItem
        UPDATE FIELDS (
          Werks Lgort MatUuid Matnr Menge
          Meins Dmbtr Mtart Infnr InfUuid
        )
        WITH VALUE #(
          (
            %tky    = ls_item-%tky
            Werks   = ls_poitem-Werks
            Lgort   = ls_poitem-Lgort
            MatUuid = ls_poitem-MatUuid
            Matnr   = ls_poitem-Matnr
            Menge   = ls_poitem-Menge
            Meins   = ls_poitem-Meins
            Dmbtr   = lv_dmbtr
            Mtart   = ls_poitem-Mtart
            Infnr   = ls_poitem-Infnr
            InfUuid = ls_poitem-InfUuid
          )
        ).

    ENDLOOP.

  ENDMETHOD.


  METHOD ClearPoItem.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      " PO Item 존재 확인
      SELECT SINGLE EbelnUuid
        FROM zi_b11_ekpo
        WHERE EbelnUuid = @ls_item-EbelnUuid
          AND ebelp     = @ls_item-Ebelp
        INTO @DATA(lv_EbelnUuid).

      IF sy-subrc = 0 OR ls_item-Ebelp IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      " PO Item 정보 초기화
      MODIFY ENTITIES OF zr_b11_mkpf IN LOCAL MODE
        ENTITY GRItem
        UPDATE FIELDS (
          Werks Lgort MatUuid Matnr Menge
          Meins Dmbtr Mtart Infnr InfUuid
        )
        WITH VALUE #(
          (
            %tky    = ls_item-%tky
            Werks   = VALUE #( )
            Lgort   = VALUE #( )
            MatUuid = VALUE #( )
            Matnr   = VALUE #( )
            Menge   = VALUE #( )
            Meins   = VALUE #( )
            Dmbtr   = VALUE #( )
            Mtart   = VALUE #( )
            Infnr   = VALUE #( )
            InfUuid = VALUE #( )
          )
        ).

    ENDLOOP.

  ENDMETHOD.


  METHOD SetVendorUuid.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRItem
      FIELDS ( Lifnr LifUuid VendorName )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      " 공급업체 미입력
      IF ls_item-Lifnr IS INITIAL.

        MODIFY ENTITIES OF zr_b11_mkpf IN LOCAL MODE
          ENTITY GRItem
          UPDATE FIELDS ( LifUuid VendorName )
          WITH VALUE #(
            (
              %tky       = ls_item-%tky
              LifUuid    = VALUE #( )
              VendorName = VALUE #( )
            )
          ).

        CONTINUE.
      ENDIF.

      " 공급업체 조회
      SELECT SINGLE lif_uuid, name1
        FROM ztb11lfa1
        WHERE lifnr = @ls_item-Lifnr
        INTO @DATA(ls_vendor).

      IF sy-subrc <> 0.

        MODIFY ENTITIES OF zr_b11_mkpf IN LOCAL MODE
          ENTITY GRItem
          UPDATE FIELDS ( LifUuid VendorName )
          WITH VALUE #(
            (
              %tky       = ls_item-%tky
              LifUuid    = VALUE #( )
              VendorName = VALUE #( )
            )
          ).

        CONTINUE.
      ENDIF.

      " 공급업체 정보 설정
      MODIFY ENTITIES OF zr_b11_mkpf IN LOCAL MODE
        ENTITY GRItem
        UPDATE FIELDS ( LifUuid VendorName )
        WITH VALUE #(
          (
            %tky       = ls_item-%tky
            LifUuid    = ls_vendor-lif_uuid
            VendorName = ls_vendor-name1
          )
        ).

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckCurrency.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRItem
      FIELDS ( Waers )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      " 통화 확인
      IF ls_item-Waers <> 'KRW'.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '081'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Waers = if_abap_behv=>mk-on
        ) TO reported-gritem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckMasterData.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      " 이동유형 확인
      IF ls_item-Bwart IS NOT INITIAL.

        CASE ls_item-Bwart.
          WHEN '101' OR '102' OR '311' OR '511'.

          WHEN OTHERS.

            APPEND VALUE #(
              %tky = ls_item-%tky
            ) TO failed-gritem.

            APPEND VALUE #(
              %tky = ls_item-%tky
              %msg = new_message(
                id       = 'ZMCB11'
                number   = '027'
                severity = if_abap_behv_message=>severity-error
              )
              %element-Bwart = if_abap_behv=>mk-on
            ) TO reported-gritem.

        ENDCASE.

      ENDIF.

      " 공급업체 확인
      IF ls_item-Lifnr IS NOT INITIAL.

        SELECT SINGLE lif_uuid, loevm
          FROM ztb11lfa1
          WHERE lifnr = @ls_item-Lifnr
          INTO @DATA(ls_vendor).

        IF sy-subrc <> 0.

          APPEND VALUE #(
            %tky = ls_item-%tky
          ) TO failed-gritem.

          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '037'
              severity = if_abap_behv_message=>severity-error
            )
            %element-Lifnr = if_abap_behv=>mk-on
          ) TO reported-gritem.

        ELSEIF ls_vendor-loevm = 'X'.

          APPEND VALUE #(
            %tky = ls_item-%tky
          ) TO failed-gritem.

          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '049'
              severity = if_abap_behv_message=>severity-error
            )
            %element-Lifnr = if_abap_behv=>mk-on
          ) TO reported-gritem.

        ENDIF.

      ENDIF.

      " 자재 확인
      IF ls_item-Matnr IS NOT INITIAL.

        SELECT SINGLE mat_uuid, lvorm
          FROM ztb11mara
          WHERE matnr = @ls_item-Matnr
          INTO @DATA(ls_material).

        IF sy-subrc <> 0.

          APPEND VALUE #(
            %tky = ls_item-%tky
          ) TO failed-gritem.

          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '031'
              severity = if_abap_behv_message=>severity-error
            )
            %element-Matnr = if_abap_behv=>mk-on
          ) TO reported-gritem.

        ELSEIF ls_material-lvorm = 'X'.

          APPEND VALUE #(
            %tky = ls_item-%tky
          ) TO failed-gritem.

          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '050'
              severity = if_abap_behv_message=>severity-error
            )
            %element-Matnr = if_abap_behv=>mk-on
          ) TO reported-gritem.

        ENDIF.

      ENDIF.

      " 플랜트 확인
      IF ls_item-Werks IS NOT INITIAL.

        SELECT SINGLE Werks
          FROM zi_b11_werks_f4
          WHERE Werks = @ls_item-Werks
          INTO @DATA(lv_werks).

        IF sy-subrc <> 0.

          APPEND VALUE #(
            %tky = ls_item-%tky
          ) TO failed-gritem.

          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '004'
              severity = if_abap_behv_message=>severity-error
            )
            %element-Werks = if_abap_behv=>mk-on
          ) TO reported-gritem.

        ENDIF.

      ENDIF.

      " 저장위치 확인
      IF ls_item-Werks IS NOT INITIAL
         AND ls_item-Lgort IS NOT INITIAL.

        SELECT SINGLE Lgort
          FROM zi_b11_lgort_f4
          WHERE Werks = @ls_item-Werks
            AND Lgort = @ls_item-Lgort
          INTO @DATA(lv_lgort).

        IF sy-subrc <> 0.

          APPEND VALUE #(
            %tky = ls_item-%tky
          ) TO failed-gritem.

          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '005'
              severity = if_abap_behv_message=>severity-error
            )
            %element-Werks = if_abap_behv=>mk-on
            %element-Lgort = if_abap_behv=>mk-on
          ) TO reported-gritem.

        ENDIF.

      ENDIF.

      " 단위 확인
      IF ls_item-Meins IS NOT INITIAL.

        SELECT SINGLE Msehi
          FROM zi_b11_meins_f4
          WHERE Msehi = @ls_item-Meins
          INTO @DATA(lv_meins).

        IF sy-subrc <> 0.

          APPEND VALUE #(
            %tky = ls_item-%tky
          ) TO failed-gritem.

          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '071'
              severity = if_abap_behv_message=>severity-error
            )
            %element-Meins = if_abap_behv=>mk-on
          ) TO reported-gritem.

        ENDIF.

      ENDIF.

      " 재고타입 확인
      IF ls_item-Insmk IS NOT INITIAL
         AND ls_item-Insmk <> 'X'
         AND ls_item-Insmk <> 'S'.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '072'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Insmk = if_abap_behv=>mk-on
        ) TO reported-gritem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckPoData.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      " PO 미입력 제외
      IF ls_item-Ebeln IS INITIAL
         AND ls_item-Ebelp IS INITIAL.
        CONTINUE.
      ENDIF.

      " PO 필수값 확인
      IF ls_item-Ebeln IS INITIAL
         OR ls_item-Ebelp IS INITIAL.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = COND #(
              WHEN ls_item-Ebeln IS INITIAL THEN '067'
              ELSE '068'
            )
            severity = if_abap_behv_message=>severity-error
          )
          %element-Ebeln = if_abap_behv=>mk-on
          %element-Ebelp = if_abap_behv=>mk-on
        ) TO reported-gritem.

        CONTINUE.

      ENDIF.

      " PO Header 확인
      SELECT SINGLE EbelnUuid, LifUuid
        FROM zr_b11_ekko
        WHERE Ebeln = @ls_item-Ebeln
        INTO @DATA(ls_poheader).

      IF sy-subrc <> 0.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '073'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Ebeln = if_abap_behv=>mk-on
        ) TO reported-gritem.

        CONTINUE.

      ENDIF.

      " 공급업체 일치 확인
      IF ls_item-LifUuid IS NOT INITIAL
         AND ls_poheader-LifUuid <> ls_item-LifUuid.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '075'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Lifnr = if_abap_behv=>mk-on
          %element-Ebeln = if_abap_behv=>mk-on
        ) TO reported-gritem.

      ENDIF.

      " PO Item 확인
      SELECT SINGLE EbelnUuid, MatUuid, Werks, Lgort
        FROM zi_b11_ekpo
        WHERE EbelnUuid = @ls_poheader-EbelnUuid
          AND Ebelp     = @ls_item-Ebelp
        INTO @DATA(ls_poitem).

      IF sy-subrc <> 0.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '074'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Ebelp = if_abap_behv=>mk-on
        ) TO reported-gritem.

        CONTINUE.

      ENDIF.

      " 자재 일치 확인
      IF ls_item-MatUuid IS NOT INITIAL
         AND ls_poitem-MatUuid <> ls_item-MatUuid.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '076'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Matnr = if_abap_behv=>mk-on
          %element-Ebelp = if_abap_behv=>mk-on
        ) TO reported-gritem.

      ENDIF.

      " 플랜트 일치 확인
      IF ls_item-Werks IS NOT INITIAL
         AND ls_poitem-Werks <> ls_item-Werks.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '077'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Werks = if_abap_behv=>mk-on
          %element-Ebelp = if_abap_behv=>mk-on
        ) TO reported-gritem.

      ENDIF.

      " 저장위치 일치 확인
      IF ls_item-Lgort IS NOT INITIAL
         AND ls_poitem-Lgort IS NOT INITIAL
         AND ls_poitem-Lgort <> ls_item-Lgort.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '078'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Lgort = if_abap_behv=>mk-on
          %element-Ebelp = if_abap_behv=>mk-on
        ) TO reported-gritem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckQuantityAmount.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRItem
      FIELDS ( Menge Dmbtr )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      " 수량 확인
      IF ls_item-Menge <= 0.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '070'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Menge = if_abap_behv=>mk-on
        ) TO reported-gritem.

      ENDIF.

      " 금액 확인
      IF ls_item-Dmbtr < 0.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '058'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Dmbtr = if_abap_behv=>mk-on
        ) TO reported-gritem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckRequired.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      " 이동유형 필수
      IF ls_item-Bwart IS INITIAL.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '026'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Bwart = if_abap_behv=>mk-on
        ) TO reported-gritem.

      ENDIF.

      " 플랜트 필수
      IF ls_item-Werks IS INITIAL.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '033'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Werks = if_abap_behv=>mk-on
        ) TO reported-gritem.

      ENDIF.

      " 저장위치 필수
      IF ls_item-Lgort IS INITIAL.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '069'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Lgort = if_abap_behv=>mk-on
        ) TO reported-gritem.

      ENDIF.

      " 자재 필수
      IF ls_item-Matnr IS INITIAL.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '001'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Matnr = if_abap_behv=>mk-on
        ) TO reported-gritem.

      ENDIF.

      " 단위 필수
      IF ls_item-Meins IS INITIAL.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '007'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Meins = if_abap_behv=>mk-on
        ) TO reported-gritem.

      ENDIF.

      " 일반입고 PO 필수
      IF ls_item-Bwart = '101'.

        IF ls_item-Lifnr IS INITIAL.

          APPEND VALUE #(
            %tky = ls_item-%tky
          ) TO failed-gritem.

          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '036'
              severity = if_abap_behv_message=>severity-error
            )
            %element-Lifnr = if_abap_behv=>mk-on
          ) TO reported-gritem.

        ENDIF.

        IF ls_item-Ebeln IS INITIAL.

          APPEND VALUE #(
            %tky = ls_item-%tky
          ) TO failed-gritem.

          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '067'
              severity = if_abap_behv_message=>severity-error
            )
            %element-Ebeln = if_abap_behv=>mk-on
          ) TO reported-gritem.

        ENDIF.

        IF ls_item-Ebelp IS INITIAL.

          APPEND VALUE #(
            %tky = ls_item-%tky
          ) TO failed-gritem.

          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message(
              id       = 'ZMCB11'
              number   = '068'
              severity = if_abap_behv_message=>severity-error
            )
            %element-Ebelp = if_abap_behv=>mk-on
          ) TO reported-gritem.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD UpdatePoStatus.

    " GR Item 조회
    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRItem
      FIELDS ( EbelnUuid Ebelp Bwart )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      " PO 정보 확인
      IF ls_item-EbelnUuid IS INITIAL
         OR ls_item-Ebelp IS INITIAL.
        CONTINUE.
      ENDIF.

      " 101 입고만 처리
      IF ls_item-Bwart <> '101'.
        CONTINUE.
      ENDIF.

      " PO 입고완료 처리
      MODIFY ENTITIES OF zr_b11_ekko
        ENTITY POItem
        EXECUTE SetGrComplete
        FROM VALUE #(
          (
            EbelnUuid = ls_item-EbelnUuid
            Ebelp     = ls_item-Ebelp
          )
        ).

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckPoStatus.

    " GR Item 조회
    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRItem
      FIELDS ( EbelnUuid Ebelp )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      " PO 정보 확인
      IF ls_item-EbelnUuid IS INITIAL
         OR ls_item-Ebelp IS INITIAL.
        CONTINUE.
      ENDIF.

      " PO Item 상태 조회
      SELECT SINGLE Loekz, Elikz
        FROM zi_b11_ekpo
        WHERE EbelnUuid = @ls_item-EbelnUuid
          AND Ebelp     = @ls_item-Ebelp
        INTO @DATA(ls_poitem).

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      " 삭제 Item
      IF ls_poitem-Loekz = 'X'.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '083'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Ebelp = if_abap_behv=>mk-on
        ) TO reported-gritem.

        CONTINUE.

      ENDIF.

      " 입고완료 Item
      IF ls_poitem-Elikz = 'X'.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-gritem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '082'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Ebelp = if_abap_behv=>mk-on
        ) TO reported-gritem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.



CLASS lhc_GRHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR GRHeader RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR GRHeader RESULT result.

    METHODS SetYearDate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR GRHeader~SetYearDate.

    METHODS SetYearByBudat FOR DETERMINE ON MODIFY
      IMPORTING keys FOR GRHeader~SetYearByBudat.

    METHODS CheckDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR GRHeader~CheckDate.

    METHODS NumberingMblnr FOR DETERMINE ON SAVE
      IMPORTING keys FOR GRHeader~NumberingMblnr.

    METHODS CheckItemExists FOR VALIDATE ON SAVE
      IMPORTING keys FOR GRHeader~CheckItemExists.

    METHODS CheckYear FOR VALIDATE ON SAVE
      IMPORTING keys FOR GRHeader~CheckYear.

ENDCLASS.


CLASS lhc_GRHeader IMPLEMENTATION.

  METHOD get_instance_authorizations.

  ENDMETHOD.


  METHOD get_instance_features.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRHeader
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_header).

    LOOP AT result_header INTO DATA(ls_header).

      APPEND VALUE #(
        %tky = ls_header-%tky
      ) TO result ASSIGNING FIELD-SYMBOL(<ls_result>).

      " Draft 수정 허용
      IF ls_header-%is_draft = if_abap_behv=>mk-on.
        <ls_result>-%delete = if_abap_behv=>fc-o-enabled.
        <ls_result>-%update = if_abap_behv=>fc-o-enabled.
      ELSE.
        <ls_result>-%delete = if_abap_behv=>fc-o-disabled.
        <ls_result>-%update = if_abap_behv=>fc-o-disabled.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetYearDate.

    DATA(lv_year) = sy-datum+0(4).

    " 기본 날짜 설정
    MODIFY ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRHeader
      UPDATE FIELDS ( Mjahr Bldat Budat Cpudt )
      WITH VALUE #(
        FOR key IN keys
        (
          %tky  = key-%tky
          Mjahr = lv_year
          Bldat = sy-datum
          Budat = sy-datum
          Cpudt = sy-datum
        )
      ).

  ENDMETHOD.


  METHOD SetYearByBudat.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRHeader
      FIELDS ( Budat )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    LOOP AT lt_header INTO DATA(ls_header).

      IF ls_header-Budat IS INITIAL.
        CONTINUE.
      ENDIF.

      " 전기일 기준 연도
      DATA(lv_year) = ls_header-Budat+0(4).

      MODIFY ENTITIES OF zr_b11_mkpf IN LOCAL MODE
        ENTITY GRHeader
        UPDATE FIELDS ( Mjahr )
        WITH VALUE #(
          (
            %tky  = ls_header-%tky
            Mjahr = lv_year
          )
        ).

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckDate.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRHeader
      FIELDS ( Bldat Budat )
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_header).

    LOOP AT result_header INTO DATA(ls_header).

      " 이전 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_header-%tky
        %state_area = 'CHECK_DATE'
      ) TO reported-grheader.

      " 날짜 필수
      IF ls_header-Bldat IS INITIAL
         OR ls_header-Budat IS INITIAL.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-grheader.

        APPEND VALUE #(
          %tky        = ls_header-%tky
          %state_area = 'CHECK_DATE'
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '066'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Bldat = if_abap_behv=>mk-on
          %element-Budat = if_abap_behv=>mk-on
        ) TO reported-grheader.

        RETURN.

      ENDIF.

      " 미래일 방지
      IF sy-datum < ls_header-Bldat
         OR sy-datum < ls_header-Budat.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-grheader.

        APPEND VALUE #(
          %tky        = ls_header-%tky
          %state_area = 'CHECK_DATE'
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '048'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Bldat = if_abap_behv=>mk-on
          %element-Budat = if_abap_behv=>mk-on
        ) TO reported-grheader.

        RETURN.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD NumberingMblnr.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRHeader
      FIELDS ( Mblnr )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    LOOP AT lt_header INTO DATA(ls_header).

      " Draft 제외
      IF ls_header-%is_draft = if_abap_behv=>mk-on.
        CONTINUE.
      ENDIF.

      " 기존 번호 제외
      IF ls_header-Mblnr IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      " 이동유형 조회
      READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
        ENTITY GRHeader BY \_GRItem
        FIELDS ( Bwart )
        WITH VALUE #(
          (
            %tky = ls_header-%tky
          )
        )
        RESULT DATA(lt_item).

      DATA lv_range TYPE nrnr.
      lv_range = '03'.

      LOOP AT lt_item INTO DATA(ls_item).

        CASE ls_item-Bwart.

          " 일반입고
          WHEN '101' OR '511'.
            lv_range = '01'.

          " 입고취소
          WHEN '102'.
            lv_range = '02'.

          " 기타
          WHEN OTHERS.
            lv_range = '03'.

        ENDCASE.

        EXIT.

      ENDLOOP.

      " 문서번호 채번
      TRY.

          cl_numberrange_runtime=>number_get(
            EXPORTING
              object      = 'ZNRB1105'
              nr_range_nr = lv_range
            IMPORTING
              number      = DATA(lv_number)
              returncode  = DATA(lv_returncode)
          ).

        CATCH cx_number_ranges INTO DATA(lx_nr).

          APPEND VALUE #(
            %tky = ls_header-%tky
            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text     = lx_nr->get_text( )
            )
          ) TO reported-grheader.

          CONTINUE.

      ENDTRY.

      DATA lv_num TYPE numc10.
      lv_num = lv_number.

      " 문서번호 저장
      MODIFY ENTITIES OF zr_b11_mkpf IN LOCAL MODE
        ENTITY GRHeader
        UPDATE FIELDS ( Mblnr )
        WITH VALUE #(
          (
            %tky  = ls_header-%tky
            Mblnr = lv_num
          )
        ).

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckItemExists.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRHeader BY \_GRItem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT keys INTO DATA(ls_key).

      " Item 존재 확인
      READ TABLE lt_item
        WITH KEY MblnrUuid = ls_key-MblnrUuid
        TRANSPORTING NO FIELDS.

      IF sy-subrc <> 0.

        APPEND VALUE #(
          %tky = ls_key-%tky
        ) TO failed-grheader.

        APPEND VALUE #(
          %tky = ls_key-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '079'
            severity = if_abap_behv_message=>severity-error
          )
        ) TO reported-grheader.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckYear.

    READ ENTITIES OF zr_b11_mkpf IN LOCAL MODE
      ENTITY GRHeader
      FIELDS ( Budat Mjahr )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    LOOP AT lt_header INTO DATA(ls_header).

      " 이전 메시지 초기화
      APPEND VALUE #(
        %tky        = ls_header-%tky
        %state_area = 'CHECK_YEAR'
      ) TO reported-grheader.

      IF ls_header-Budat IS INITIAL.
        CONTINUE.
      ENDIF.

      DATA(lv_year) = ls_header-Budat+0(4).

      " 연도 확인
      IF ls_header-Mjahr <> lv_year.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-grheader.

        APPEND VALUE #(
          %tky        = ls_header-%tky
          %state_area = 'CHECK_YEAR'
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '080'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Budat = if_abap_behv=>mk-on
          %element-Mjahr = if_abap_behv=>mk-on
        ) TO reported-grheader.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
