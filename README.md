# 🌈 날씨 모아
<img width="250" alt="image" src="https://github.com/user-attachments/assets/72bdd15d-9fba-455a-94a9-462c9689b9bb">
<img width="250" alt="image" src="https://github.com/user-attachments/assets/2264bc54-d8ba-4d3b-bf6a-b33c2ba44b31">
<img width="250" alt="image" src="https://github.com/user-attachments/assets/78f16c36-dad7-425d-8b00-863645f0d9bb">
<img width="250" alt="image" src="https://github.com/user-attachments/assets/bc69cdd4-72c7-4626-932d-4f23a83ead52">
<img width="250" alt="image" src="https://github.com/user-attachments/assets/2ddfec4f-e202-433e-a699-3bfca03beec5">

<br>

##  ❄️  현재날씨, 주간예보 소개
https://github.com/user-attachments/assets/666179f3-ccf4-49ac-862a-bd4b784870ef

<br>

##  ☃️ 지역 추가 소개
https://github.com/user-attachments/assets/699239b0-b10d-42a7-b424-532e82d3a715

<br>

## 1️⃣ 시작 동기
- 기존 날씨 앱에서 ‘한눈에 볼 수 없는 불편함’으로 인해 시작하게 됨
- 새로운 기술을 현업에 적용하기 전 먼저 사용해보고, 학습한 것을 바로 적용해보기 위한 토이 프로젝트 (위젯, 모듈화 등)

<br>

## 2️⃣ 설명
- 공공데이터를 이용한 날씨 앱
- 일출 및 일몰 시간, 강수량, 바람 속도, 미세먼지, 온도, 시간대별 온도, 주간예보 등 '한눈에 볼 수 있도록'에 초점
- Day or Night 모드 지원, 해당 모드에 따른 애니메이션 및 이미지 변화
- 현재 GPS 위치뿐만 아니라, 다른 지역 추가 기능 제공
- 위젯 제공 (현재 날씨, 주간 예보)
- 공공 데이터 특성상 통신이 느릴 때가 있으므로, 통신 지연 Notice Floater 제공 및 재시도 기능 제공
<br>

## 3️⃣ 고민한 점
- 공공 데이터 통신 속도가 느릴땐 어떻게 대처해야 할 까 ?
  
   -> 2초 이상 지연 시 - Notice Floater 제공,

   -> 8초 이상 지연 시 - 자동 재시도 제공

<br>
     
- 위젯에서도 현재 날씨, 주간 예보 등 재사용 할 코드들이 많은데 어떻게 관리하면 효울적일까 ?

    -> SPM 모듈화 진행  
       (전체 코드를 Core, Domain, Data, Feature, Widget 모듈로 나눔)
  
    -> Widget 모듈에서 Core, Domain 모듈을 의존하여 재사용성 향상

<br>

- 모듈 구조를 어떻게 나누면 좋을까 ?

    -> Core - 공통 UI 및 Component, 비즈니스 로직 Support 및 공통 사용 (Environment Object), Network 관련 유틸  
  
    -> Domain - 핵심 비즈니스 로직 및 규칙(날씨 변환, 날씨 타입, 위치 타입, 에러 타입 등), 앱 <-> 위젯 데이터 연결

    -> Data - 공공 데이터 API 실제 통신, Response 반환 타입  

    -> Feature - View, View Model 등 Presentation 영역

<br>

## 4️⃣ 기술 스택
- SwiftUI + MVVM
- Async / Await
- SPM Modulaization
