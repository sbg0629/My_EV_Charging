## EV Charging Station Management System

**충전소 관리 시스템**은 전기차 충전소 정보를 기반으로 충전소를 공유하고, 사용자에게 최적의 충전소를 추천하는 플랫폼입니다.
사용자들끼리 실시간 채팅을 통해 충전소 정보를 공유하고 이용 팁을 나눌 수 있습니다.
---

<img src="images/MoodSync_desc.png" alt="포스터" width="100%"/>

---

<h2>🌟프로젝트 기능개요(기여도: 상: ⭐/ 중: ★/ 하: ☆)</h2>

| 기능명 | 설명 | 기여도 |
|--------|------|--------|
| **회원가입/로그인 · 소셜 로그인** | Spring Security 기반 인증 / Kakao·Google 소셜 로그인 지원 | 중 ★ |
| **이메일 인증(ID/비밀번호 찾기)** | 인증코드 메일 발송 / 계정 찾기 및 비밀번호 재설정 | 상 ⭐ |
| **실시간 충전소 정보 조회** | 공공데이터 API 기반 충전기 상태 실시간 제공 |  중 ★ |
| **지도 기반 충전소 탐색** |카카오맵 + 클러스터링을 통한 충전소 위치 표시 |  중 ★ |
| **충전소 예약 · Toss 결제** |예약 기능 및 Toss Payments 결제 연동 | 중 ★ |
| **혼잡도 예측 서비스** | 시간대별 사용량 통계 기반 혼잡도 시각화 | 상 ⭐ |
| **충전소 검색/필터링** | 지역/속도/운영사 등 조건 검색 | 중 ★ |
| **고장 신고 처리 시스템** | 고장 신고 접수 및 처리 상태 조회 | 중 ★ |
| **게시판/공지사항** | 커뮤니티 CRUD / 관리자 공지 안내 | 상 ⭐ |
| **관리자 모드(Admin)** | 충전소/신고/사용자 관리 기능 |  상 ⭐ |

---

<h2>🛠️ 기술 스택</h2>

📌 Backend

Java 17
Spring Framework / Spring MVC
Spring Security
MyBatis
Tomcat
Oracle Database

<p align="left"> <img src="https://img.shields.io/badge/Java 17-007396?style=for-the-badge&logo=openjdk&logoColor=white"/> <img src="https://img.shields.io/badge/Spring MVC-6DB33F?style=for-the-badge&logo=spring&logoColor=white"/> <img src="https://img.shields.io/badge/Spring Security-6DB33F?style=for-the-badge&logo=springsecurity&logoColor=white"/> <img src="https://img.shields.io/badge/MyBatis-14274E?style=for-the-badge&logo=databricks&logoColor=white"/> <img src="https://img.shields.io/badge/Tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black"/> <img src="https://img.shields.io/badge/Oracle DB-F80000?style=for-the-badge&logo=oracle&logoColor=white"/> <img src="https://img.shields.io/badge/Google API-4285F4?style=for-the-badge&logo=google&logoColor=white"/> </p>

📌 Frontend
JSP
HTML5 / CSS3
JavaScript
jQuery

<p align="left"> <img src="https://img.shields.io/badge/JSP-007396?style=for-the-badge&logo=java&logoColor=white"/> <img src="https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white"/> <img src="https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white"/> <img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black"/> <img src="https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white"/> </p>

📌 Version Control / Tools
Git / GitHub
Gradle
Postman

<p align="left"> <img src="https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white"/> <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white"/> <img src="https://img.shields.io/badge/Gradle-02303A?style=for-the-badge&logo=gradle&logoColor=white"/> <img src="https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white"/> </p>

---

## ✨ 주요 기능

- **회원 관리**: 회원가입, 로그인/로그아웃, 마이페이지, 회원 정보 수정, Spring Security 기반 비밀번호 암호화   
- **충전소 지도/API 연동**: 실시간 충전소 위치·상태·혼잡도(공공데이터 API), 주변 카페·편의점 등 부가 정보 표시  
- **고장 신고 & 처리**: 회원의 고장신고/관리자 처리, 처리 상태 확인
- **공지사항 및 자유게시판**: 커뮤니티 기능, 게시글/댓글 작성·수정·삭제
- **관리자 페이지**: 고장 처리, 회원 관리, 예약 내역 관리
- **예약/결제 기능**: 충전소 예약, 예약금 결제(토스 API)
- **혼잡도 예측**: 시간대별 실시간 충전소 이용 혼잡도 예측

---


# ✨ UI / 기능 상세

---

<details>
<summary><strong>✨ UI/UX 테마 보기</strong></summary>

### ◈ 메인 페이지 구성
<img src="https://github.com/user-attachments/assets/f1648604-1c5e-46de-b2ff-ef36c885ef21" alt="메인 페이지" width="100%"/>


### ◈ 로그인/회원가입
<img src="https://github.com/user-attachments/assets/686caee1-7d11-48b4-894d-4f37a7abe5b1" alt="로그인" width="100%"/>
<img src="https://github.com/user-attachments/assets/2d8b626e-d032-4218-bacb-34673bfe6955" alt="회원가입" width="100%"/>

### ◈ 아이디/비밀번호 찾기
<img src="https://github.com/user-attachments/assets/9c259fdd-88e4-46de-b179-c8dd4115f04c" alt="아이디 /비밀번호 찾기" width="100%"/>
<img src="https://github.com/user-attachments/assets/c492c839-aa1f-4229-bd1c-355af70a325c" alt="이메일" width="100%"/>

### ◈ Footer
<img src="" alt="Footer" width="100%"/>

<details><summary>회사 소개</summary>
<img src="" alt="회사 소개" width="100%"/>
</details>

<details><summary>이용약관</summary>
<img src="" alt="이용약관" width="100%"/>
</details>

<details><summary>개인정보 처리방침</summary>
<img src="" alt="개인정보 처리방침" width="100%"/>
</details>

<details><summary>고객센터</summary>
<img src="" alt="고객센터" width="100%"/>
</details>

</details>

---

<details>
<summary><strong>✨ 충전소 정보 보기</strong></summary>

### ◈ 충전소 목록
<img src="https://github.com/user-attachments/assets/96440a1c-b75e-459a-bd27-d1dd32039f47" alt="충전소 목록" width="100%"/>


### ◈ 충전소 상세 정보
<img src="https://github.com/user-attachments/assets/66695ca6-443d-44bc-be7c-3e804c8f9d77" alt="충전소 상세" width="100%"/>

### ◈ 충전소 주변 카페
<img src="https://github.com/user-attachments/assets/dbdadde8-b8c5-4eec-a10b-e340e66e82b9" alt="충전소 주변 카페" width="100%"/>
  
### ◈ 충전소 혼잡도
<img src="https://github.com/user-attachments/assets/b79696ac-5fd9-4a11-9432-e339e7a4c331" alt="충전소 혼잡도" width="100%"/>
<img width="766" height="849" alt="image" src= />

### ◈ 즐겨찾기
<details><summary>즐겨찾기 UI</summary>
<img src="https://github.com/user-attachments/assets/b2a2fe1f-c2cd-485b-b712-f0f6c4aa4676"  alt="즐겨찾기 버튼" width="100%"/>
</details>

<details><summary>즐겨찾기 목록</summary>
<img src="" alt="즐겨찾기 목록" width="100%"/>
</details>

</details>

---

<details>
<summary><strong>✨ 마이페이지 보기</strong></summary>

<img src="https://github.com/user-attachments/assets/d304245b-65b5-4fa2-97c4-1317e9b9fbc4" alt="마이페이지 메인" width="100%"/>
<img src="https://github.com/user-attachments/assets/d345b8f9-4bfb-4609-862b-71b1026fe76a" alt="내 예약 취소 내역" width="100%"/>


<details><summary>고장 신고 내역 </summary>
<img src="https://github.com/user-attachments/assets/9bfaf87d-6fa5-4963-a3d7-7c5a7424b499" alt="추천 회원" width="100%"/>
</details>


</details>

---

<details>
<summary><strong>✨ 고장 신고 </strong></summary>

<details><summary>고장 신고 접수 </summary>
<img src="https://github.com/user-attachments/assets/0816f1db-60f7-4eba-9c70-d924cdcef189" alt="추천 회원" width="100%"/>
</details>

<details><summary>관리자 고장 신고 확인 </summary>
<img src="https://github.com/user-attachments/assets/0537a5ab-2f48-41c3-aed9-0ffb07a5a614" alt="추천 회원" width="100%"/>
</details>

<details><summary>고장신고 상세 보기 </summary>
<img src="https://github.com/user-attachments/assets/b3387057-90f4-484c-82f1-fac675fb15c7" alt="추천 회원" width="100%"/>
</details>

---

---

<details>
<summary><strong>✨ 예약 결제 기능 </strong></summary>

<details><summary>에약 접수 </summary>
<img src="https://github.com/user-attachments/assets/25e49347-116e-4ce1-bb60-4b2c9717b981" alt="추천 회원" width="100%"/>
</details>

<details><summary>예약 접수 방법 </summary>
<img src="https://github.com/user-attachments/assets/0d124f0b-4f05-41c2-ad11-115f838879d3" alt="추천 회원" width="100%"/>
</details>

<details><summary>결제 확인 기능 </summary>
<img src="https://github.com/user-attachments/assets/e13a73af-bf95-4701-82a8-43dfa71552e0" alt="추천 회원" width="100%"/>
</details>

---

<details>
<summary><strong>✨ 게시판 보기</strong></summary>
<img src="https://github.com/user-attachments/assets/cca601d6-b109-4a06-94ed-b90c4a7c3706" width="100%"/>
</details>

---

<details>
<summary><strong>✨ 공지사항 보기</strong></summary>
<img src="https://github.com/user-attachments/assets/56ea9b5c-9e2c-4dae-9eed-633dfb8eac61" width="100%"/>
</details>

---


## 🧬 ERD & 테이블 명세서

### ERD

<details>
<summary><strong>테이블 세부 명세서</strong></summary>

</details>

---

## 👥 팀원 소개

<br>

<h3 align="center">Charging Station Team</h3>

<br>

<div align="center">

<table>
  <tr>
    <!-- 팀원 1(팀장) -->
    <td align="center">
      <a href="https://github.com/sbg0629">
        <img src="https://github.com/sbg0629.png" width="130" height="130" style="border-radius: 10px;">
        <br><br>
        <b>손봉균 (팀장)</b>
      </a>
      <br>
      <sub>풀스택 - 로그인, 회원가입, 추천 회원, 실시간 채팅, 구글 소셜로그인, 페이징 처리, 게시판</sub>
    </td>
    <!-- 팀원 2 -->
    <td align="center">
       <a href="https://github.com/LeeHyunJin323">
      <img src="https://github.com/LeeHyunJin323.png" width="130" height="130" style="border-radius: 10px;">
      <br><br>
      <b>이현진</b>
          </a>
      <br>
      <sub>백엔드 - 마이페이지, 시큐리티, 네이버·카카오 소셜로그인, 댓글/대댓글, 공지 사항</sub>
    </td>
    <!-- 팀원 3 -->
    <td align="center">
       <a href="https://github.com/RollingSoap">
      <img src="https://github.com/RollingSoap.png" width="130" height="130" style="border-radius: 10px;">
      <br><br>
      <b>박동영</b>
          </a>
      <br>
      <sub>백엔드 - 충전소 페이지, 카테고리 구현, Gemini 챗봇, 이메일 인증</sub>
    </td>
    <!-- 팀원 4 -->
    <td align="center">
       <a href="https://github.com/Rootplant">
      <img src="https://github.com/Rootplant.png" width="130" height="130" style="border-radius: 10px;">
      <br><br>
      <b>정찬호</b>
          </a>
      <br>
      <sub>백엔드 - 충전소 상세페이지, 쪽지 기능, 이미지 처리</sub>
    </td>
  </tr>
</table>

</div>

<br>

---

## 🧩 기타 특장점

- **JWT + Spring Security 기반 인증/인가**
- **WebSocket 기반 실시간 채팅**
- **REST API 기반 통신 구성**
- **컴포넌트 기반 UI 구조 채택**

---
