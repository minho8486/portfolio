# 신민호 | SAP ABAP·ERP Portfolio

> **화면에서 데이터베이스까지 이어지는 흐름을 추적하며 문제를 해결하는 SAP ABAP 개발자**

SAP S/4HANA 구축 프로젝트에서 MM 모듈(재고·자재·출고)을 개발했고, SAP BTP·RAP 기반 Cloud ABAP을 학습했습니다.
물류센터 현장에서 시스템 재고와 실물 수량이 맞지 않는 문제를 겪은 뒤, 데이터가 발생 시점부터 정확히 이어지는 시스템을 만드는 일을 목표로 SAP를 공부하고 있습니다.

## Projects

| 프로젝트 | 기간 | 역할 | 기술 |
|---|---|---|---|
| [F&B 기업 SAP S/4HANA 구축 – MM 재고·출고](sap-code-s4hana-project/) | 2026.03 ~ 2026.07 | MM 개발, 부PM | Classic ABAP, Module Pool, ALV, Batch, Gateway(OData), SAPUI5 |
| [S-Mobile RAP 기반 S/4HANA 전환 – MM 구매·입고](sap-kdt-rap-project/) | 2026.07 ~ 2026.09 | ERD 설계, BO 7개 개발 | ABAP Cloud, RAP(Draft), CDS View, OData V4, SAP BTP |

### 대표 구현
- **출고 유형별 연계 처리**: 생산·판매·창고이동 출고를 하나의 처리 단위로 등록하고, 오더 상태 변경과 재고 차감이 모두 성공할 때만 `COMMIT` 합니다.
- **선입선출 배치 자동 선택**: 생산일자순으로 배치를 고르고, 품질 불합격·관리종료 배치는 제외합니다.
- **품질상태 업데이트 배치**: 품질보증기간이 지난 배치를 폐기 상태로 바꾸고, 해당 재고를 폐기 창고로 옮깁니다.
- **재고 조정 (UI5 + OData)**: 재고 실사 결과를 증가·감소로 반영하고, 재고 변경과 입출고 문서 생성을 한 처리 단위로 묶었습니다.
- **RAP 구매–입고 연계**: UUID 기술키와 Number Range 업무 번호를 분리하고, 입고 저장 시 구매오더 품목을 Action으로 입고완료 처리했습니다.
- **트러블슈팅 6건**: ALV 이벤트와 Dynpro 화면 갱신 흐름 분리, 다품목 출고 재고 덮어쓰기(정합성 오류 0건), 자재 그룹별 품질 검증, RAP BO 간 상태 동기화, PO Item Early Numbering 등. 각 프로젝트 README의 트러블슈팅 표에 원인·해결·결과를 정리했습니다.

## Other Projects

| 프로젝트 | 기간 | 내용 | 기술 |
|---|---|---|---|
| [모션 인식 게임 (Unity)](motion-game/) | 2023.03 ~ 2023.12 | 웹캠 포즈·손 인식(Python) → UDP → Unity로 몸 동작을 인식하는 팀 게임. 인식·통신 공통부, 장애물 회피·아이템 전달 스테이지 담당 | Python, OpenCV, cvzone, UDP, Unity, C# |
| [전기차 화재 분석 대시보드](ev-fire-analysis/) | 2025.08 ~ 2025.09 | 공공데이터로 전기차·내연기관차의 등록 대수 대비 화재율 비교, Streamlit 대시보드 배포 | Python, pandas, Plotly, Streamlit |

## Education
- SAP CODE 아카데미 1기 (2025.10 ~ 2026.07, 1,440시간)
- SAP KDT 심화과정 2기 (2026.07 ~ 2026.09, 320시간)
- 새싹(SeSAC) × 베스핀글로벌 AI서비스 운영을 위한 클라우드 데이터 엔지니어 과정 (2025.08 ~ 2025.10, 수강)

## Certifications
- SAP Certified Associate – Back-End Developer – ABAP Cloud (2026.06)
- SAP Certified – SAP S/4HANA Cloud Private Edition, Financial Accounting (2026.06)
- SQL 개발자(SQLD) (2026.03)
- 전산회계 2급 (2025.06)

## Skills

| SAP Development | SAP Technical Skills | ERP Knowledge |
|---|---|---|
| ABAP Report · Module Pool · ALV Event | Open SQL · Debugging · DDIC | MM 재고 관리 · 구매 |
| Gateway OData · SAPUI5 | Function Module · Class / OOP | Batch Management · 유효기간 / FEFO |
| CDS View · RAP | BAPI / RFC | FI 문서 흐름 · PP / SD 프로세스 |

## Tech Stack
`ABAP` `ABAP Cloud` `RAP` `CDS View` `SAP Gateway (OData)` `SAPUI5 / Fiori` `SAP BTP` `S/4HANA (MM·SD·FI·PP)` `SQL`
