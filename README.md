# WHOA(후아) - 꽃다발 커스터마이징 iOS 앱 출시 및 서비스

[![Download on the App Store](https://github.com/user-attachments/assets/cfd34b39-b70f-4ed0-97f7-36bd0d3afe5d)](https://apps.apple.com/kr/app/whoa-%ED%9B%84%EC%95%84/id6517357818)
![Group 1597880496](https://github.com/user-attachments/assets/c8deadc2-39d3-4cd1-982d-bb50026ee329)


## 프로젝트 소개
- WHOA(후아)는 꽃다발 커스터마이징으로 나만의 꽃다발을 만드는 서비스입니다.
- 구매 목적과 선호하는 색상에 따라 적합한 꽃을 추천해드립니다.
- 꽃다발 디자인을 구체적으로 설명하기 어려운 경우 꽃집 사장님께 전달할 요구서를 만들어 드립니다.
- 꽃말, 관리법, 주의사항 등 꽃에 대한 모든 정보를 한곳에서 확인할 수 있습니다.
- 탄생화와 기념일에 맞춰 매일 특별한 꽃을 추천해드립니다.
- 합리적인 가격으로 꽃다발을 구성할 수 있도록 매주 저렴한 꽃 순위를 확인할 수 있습니다.

## 개발 환경
| Environment            | Version |
|:-----------------------:|:-------:|
|        Swift           |  5.9.2  |
|        Xcode           |  15.2   |
| iOS Deployment Target  |  15.0   |

## 기술 스택
- UIkit, MVVM-C, URLSession, Photos, Combine, SnapKit, SPM

## 폴더 구조
``` bash
📁 WHOA_iOS
|--- 📁 App (AppDelegate, SceneDelegate)
|--- 📁 Networking
|    |--- 📁 APIs (API 요청 관련 파일)
|    |--- 📁 DTOs (Response 모델)
|    |--- 📁 Network (Network 객체)
|    |--- 📁 NetworkManager.swift (Network 요청/응답 관리)
|
|--- 📁 UI (Model, ViewController, ViewModel)
|--- 📁 Coordinator (화면 전환 및 네비게이션 관리)
|--- 📁 Global
|    |--- 📁 Extensions (공통 확장 파일)
|    |--- 📁 Helper (유틸리티/헬퍼 클래스)
|    |--- 📁 Model (공통 데이터 모델)
|    |--- 📁 Types (상수, 열거형, 타입 정의)
|
|--- 📁 Resources (Assets, Color, Fonts)
|--- 📁 SupportingFiles (Info.plist)
```
