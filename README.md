<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:0A6ED1,100:1B3A6B&height=210&section=header&text=Shin%20Minho&fontSize=58&fontColor=ffffff&fontAlignY=36&desc=SAP%20ABAP%20%C2%B7%20ERP%20Developer%20Portfolio&descSize=20&descAlignY=58" width="100%" alt="Shin Minho – SAP ABAP · ERP Developer Portfolio"/>

### 화면에서 데이터베이스까지, 데이터 흐름을 추적해 문제를 해결하는 SAP ABAP 개발자

<p>
<img src="https://img.shields.io/badge/SAP-S%2F4HANA-0FAAFF?style=for-the-badge&logo=sap&logoColor=white"/>
<img src="https://img.shields.io/badge/ABAP-Classic%20%7C%20Cloud-1B3A6B?style=for-the-badge"/>
<img src="https://img.shields.io/badge/RAP-Draft%20%7C%20OData%20V4-0A6ED1?style=for-the-badge"/>
<img src="https://img.shields.io/badge/SAPUI5-Fiori-F0AB00?style=for-the-badge&logo=sap&logoColor=white"/>
</p>

<p>
<img src="https://img.shields.io/badge/SAP%20교육-1%2C760시간-2E7D32?style=flat-square"/>
<img src="https://img.shields.io/badge/SAP%20자격증-2개-0A6ED1?style=flat-square"/>
<img src="https://img.shields.io/badge/RAP%20Business%20Object-7개-6A1B9A?style=flat-square"/>
<img src="https://img.shields.io/badge/트러블슈팅-6건-C62828?style=flat-square"/>
<img src="https://img.shields.io/badge/출고%20정합성%20오류-0건-F57C00?style=flat-square"/>
</p>

</div>

---

## 👋 About Me

> 물류센터에서 **시스템 재고와 실물 수량이 맞지 않는 문제**를 직접 겪고, 데이터가 발생 시점부터 정확히 이어지는 시스템을 만들기 위해 SAP를 선택했습니다.

- 🏗️ **S/4HANA 구축 프로젝트**에서 MM 모듈(재고·자재·출고)을 개발하고 부PM을 맡았습니다.
- ☁️ **SAP BTP · RAP**로 자재부터 구매오더·입고까지 7개 Business Object를 설계·개발했습니다.
- 🔍 결과가 이상하면 **화면 → 로직 → DB** 순서로 데이터 흐름을 따라가며 원인을 찾습니다.

```mermaid
flowchart LR
    A["📦 3PL 물류센터<br/>재고 불일치 경험<br/><sub>2024.03 ~ 2025.01</sub>"] --> B["☁️ 클라우드·데이터<br/>AWS · Python<br/><sub>2025.08 ~ 2025.10</sub>"]
    B --> C["🏗️ SAP CODE 아카데미<br/>S/4HANA 구축 · MM<br/><sub>2025.10 ~ 2026.07</sub>"]
    C --> D["🚀 SAP KDT 심화<br/>BTP · RAP · 7 BO<br/><sub>2026.07 ~ 2026.09</sub>"]
    style A fill:#ECEFF1,stroke:#90A4AE,color:#263238
    style B fill:#E3F2FD,stroke:#64B5F6,color:#0D47A1
    style C fill:#E8F5E9,stroke:#66BB6A,color:#1B5E20
    style D fill:#F3E5F5,stroke:#AB47BC,color:#4A148C
```

---

## 🏆 SAP Projects

<table>
<tr>
<td width="50%" valign="top">

### 🏗️ [F&B 기업 S/4HANA 구축 – MM 재고·출고](sap-code-s4hana-project/)
<sub>SAP CODE 아카데미 1기 · 팀 프로젝트 · 2026.03 ~ 2026.07</sub>

<a href="sap-code-s4hana-project/"><img src="sap-code-s4hana-project/images/01_goods_issue.jpg" width="100%" alt="출고 관리 프로그램"/></a>

**역할** MM 개발 · 부PM (WBS · 주간 진척 · 산출물)

- 생산·판매·창고이동 **3유형 출고**를 한 처리 단위로 등록
- **선입선출 배치 자동 선택** (품질 불합격·관리종료 제외)
- 품질보증기간 기준 **품질상태 업데이트 배치**
- UI5 + OData **재고 조정 · 폐기대상 모니터링**

<img src="https://img.shields.io/badge/Module%20Pool-555?style=flat-square"/> <img src="https://img.shields.io/badge/ALV%20Grid%20%7C%20Tree-555?style=flat-square"/> <img src="https://img.shields.io/badge/Batch%20Job-555?style=flat-square"/> <img src="https://img.shields.io/badge/Gateway%20OData-555?style=flat-square"/> <img src="https://img.shields.io/badge/SAPUI5-555?style=flat-square"/>

</td>
<td width="50%" valign="top">

### 🚀 [S-Mobile RAP 기반 S/4HANA 전환 – MM 구매·입고](sap-kdt-rap-project/)
<sub>SAP KDT 심화과정 2기 · 2026.07 ~ 2026.09</sub>

<a href="sap-kdt-rap-project/"><img src="sap-kdt-rap-project/images/04_purchase_order.jpg" width="100%" alt="구매오더 관리 프로그램"/></a>

**역할** ERD 설계 · Business Object 7개 개발

- 자재 · 벤더 · G/L 계정 · 계정결정 · PIR · **PO · GR**
- **UUID 기술키**와 Number Range 업무 번호 분리
- 입고 저장 시 **Action으로 PO 입고완료** 자동 동기화
- 🏅 **조별 평가우수자** 선정 · 수료식 최종 발표

<img src="https://img.shields.io/badge/ABAP%20Cloud-555?style=flat-square"/> <img src="https://img.shields.io/badge/RAP%20Managed%20%7C%20Draft-555?style=flat-square"/> <img src="https://img.shields.io/badge/CDS%20View-555?style=flat-square"/> <img src="https://img.shields.io/badge/OData%20V4-555?style=flat-square"/> <img src="https://img.shields.io/badge/abapGit-555?style=flat-square"/>

</td>
</tr>
</table>

### 🔧 Troubleshooting Highlights

| | 문제 | 해결 | 결과 |
|:-:|---|---|---|
| 🔴 | 다품목 출고 시 재고 값이 덮어써짐 | 관련 재고를 Internal Table에 모아 일괄 계산 후 한 번에 DB 반영, `COMMIT`/`ROLLBACK` 정리 | **정합성 오류 0건** |
| 🟠 | ALV Toolbar 클릭 후 Screen 필드 미갱신 | `sy-ucomm`을 Enter로 바꿔 PAI → PBO 흐름을 타도록 처리 | ALV · Screen 동시 반영 |
| 🟡 | 생산 불가 원자재가 출고에 등록됨 | 자재 그룹별로 상태·날짜 조건을 나눠 검증 | 사용 가능 자재만 등록 |
| 🔵 | 입고(GR) · 구매오더(PO) 상태 불일치 | PO BO에 `SetGrComplete` Action 선언, GR 저장 시 EML로 호출 | 입고 시 PO 자동 완료 |
| 🟣 | 여러 PO Item 동시 추가 시 번호 충돌 | Early Numbering에서 최대 번호 조회 후 +10 채번 | 10 · 20 · 30… 순차 부여 |

<sub>👉 원인 분석과 발표 자료는 각 프로젝트 README의 트러블슈팅 섹션에 있습니다.</sub>

---

## 🧩 Other Projects

<table>
<tr>
<td width="50%" valign="top">

### 📊 [전기차 화재 분석 대시보드](ev-fire-analysis/)
<sub>새싹(SeSAC) 개인 프로젝트 · 2025.08 ~ 2025.09</sub>

<a href="ev-fire-analysis/"><img src="ev-fire-analysis/images/02_ev_vs_ice.png" width="100%" alt="전기차 vs 내연기관 화재율"/></a>

- 소방청 화재 통계 **약 11만 건** 전처리
- 등록 대수 대비 **1만 대당 화재율** 비교
- 전기차가 내연기관보다 **연평균 0.28건 적음**
- Streamlit Cloud 배포 → [대시보드 열기](https://evfireanalysisproject-e7ygs7vzz6b8zysrmiv7nz.streamlit.app/)

<img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white"/> <img src="https://img.shields.io/badge/pandas-150458?style=flat-square&logo=pandas&logoColor=white"/> <img src="https://img.shields.io/badge/Plotly-3F4F75?style=flat-square&logo=plotly&logoColor=white"/> <img src="https://img.shields.io/badge/Streamlit-FF4B4B?style=flat-square&logo=streamlit&logoColor=white"/>

</td>
<td width="50%" valign="top">

### 🎮 [모션 인식 게임 (Unity)](motion-game/)
<sub>대학 팀 프로젝트 · 2023.03 ~ 2023.12</sub>

```
 [웹캠] ─▶ Python (손·몸 인식)
             │  UDP 5052
             ▼
 [Unity] ─▶ 몸 동작으로 게임 조작
```

- 웹캠 하나로 **몸 33개 · 손 21개** 랜드마크 인식
- 인식·통신 공통부 개발 (Python → UDP → C#)
- **장애물 회피**: 손 들기 = 점프, 팔 뻗기 = 좌우 이동
- **아이템 전달**: 손가락으로 집어 캐릭터에게 전달

<img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white"/> <img src="https://img.shields.io/badge/OpenCV-5C3EE8?style=flat-square&logo=opencv&logoColor=white"/> <img src="https://img.shields.io/badge/Unity-000000?style=flat-square&logo=unity&logoColor=white"/> <img src="https://img.shields.io/badge/C%23-512BD4?style=flat-square&logo=dotnet&logoColor=white"/>

</td>
</tr>
</table>

---

## 🛠️ Skills

<table>
<tr>
<th width="33%">💻 SAP Development</th>
<th width="33%">⚙️ SAP Technical</th>
<th width="33%">📚 ERP Knowledge</th>
</tr>
<tr>
<td valign="top">

- ABAP Report · Module Pool
- ALV Grid · Tree · Event
- Gateway OData · SAPUI5
- CDS View · RAP

</td>
<td valign="top">

- Open SQL · Debugging
- DDIC · Function Module
- Class / OOP
- BAPI / RFC

</td>
<td valign="top">

- MM 재고 · 구매
- Batch Management
- 유효기간 · FEFO
- FI 문서 흐름 · PP / SD

</td>
</tr>
</table>

<div align="center">

<img src="https://img.shields.io/badge/SAP-0FAAFF?style=for-the-badge&logo=sap&logoColor=white"/>
<img src="https://img.shields.io/badge/ABAP-1B3A6B?style=for-the-badge"/>
<img src="https://img.shields.io/badge/SQL-4479A1?style=for-the-badge"/>
<img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black"/>
<img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white"/>
<img src="https://img.shields.io/badge/C%23-512BD4?style=for-the-badge&logo=dotnet&logoColor=white"/>
<img src="https://img.shields.io/badge/AWS-232F3E?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white"/>

</div>

---

## 🎓 Education & 📜 Certifications

<table>
<tr>
<td width="50%" valign="top">

**🎓 Education**

| 기간 | 과정 |
|---|---|
| 2026.07 ~ 2026.09 | **SAP KDT 심화과정 2기** · 320h |
| 2025.10 ~ 2026.07 | **SAP CODE 아카데미 1기** · 1,440h |
| 2025.08 ~ 2025.10 | 새싹(SeSAC) 클라우드 데이터 엔지니어 과정 (수강) |

</td>
<td width="50%" valign="top">

**📜 Certifications**

| 취득 | 자격 |
|---|---|
| 2026.06 | 🟦 **SAP Certified** – Back-End Developer – ABAP Cloud |
| 2026.06 | 🟦 **SAP Certified** – S/4HANA Cloud Private Edition, FI |
| 2026.03 | 🗄️ SQL 개발자 (SQLD) |
| 2025.06 | 🧾 전산회계 2급 |

</td>
</tr>
</table>

<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:1B3A6B,100:0A6ED1&height=110&section=footer" width="100%"/>

</div>
