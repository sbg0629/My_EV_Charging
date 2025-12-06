<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.boot.Main_Page.dto.ElecDTO" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>EV Charge - 스마트 충전소 찾기</title>
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">
	
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;900&display=swap" rel="stylesheet">
    
    <style>
        * {
            font-family: 'Noto Sans KR', sans-serif;
            box-sizing: border-box;
        }
        
        html, body {
            margin: 0;
            padding: 0;
            overflow: hidden;
            background: #f8f9fa;
        }

        /* 지도 컨테이너 */
        #map {
            width: 100vw;
            height: 100vh;
            position: relative;
        }
        
        /* 🌟 사이드바 토글 버튼 컨테이너 */
        #toggle-sidebar-btn-container {
            position: absolute;
            top: 50%; /* 수직 중앙 */
            left: 424px; /* 400px (사이드바) + 24px (간격) */
            transform: translateY(-50%); /* 정확한 중앙 정렬 */
            z-index: 1005; 
            transition: left 0.3s ease; 
        }

        #toggle-sidebar-btn {
            width: 25px; /* 폭 증가 */
            height: 70px; /* 높이 증가 */
            background: #fff;
            color: #52c41a;
            border: 1px solid #e9ecef;
            border-radius: 4px 0 0 4px; /* 왼쪽만 둥글게 */
            border-right: none; 
            cursor: pointer;
            box-shadow: -2px 0 8px rgba(0, 0, 0, 0.1); 
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px; /* 아이콘 크기 증가 */
            padding: 0 5px 0 0; 
        }

        #toggle-sidebar-btn:hover {
            background: #f8f9fa;
        }


        /* 🌟 사이드바 닫힘 상태 CSS */
        .sidebar-closed #toggle-sidebar-btn-container {
            left: 20px !important; 
        }
        
        .sidebar-closed #toggle-sidebar-btn .fa-chevron-left {
            transform: rotate(180deg); 
        }

        .sidebar-closed #toggle-sidebar-btn {
            border-radius: 0 4px 4px 0; 
            border-left: none; 
            border-right: 1px solid #e9ecef; 
            box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1); 
            padding: 0 0 0 5px; 
        }

        .sidebar-closed .left-sidebar {
            display: none !important; 
        }
        
        /* 💡 [추가] 토글 버튼으로 닫았을 때 상세 패널도 숨기기 */
        .sidebar-closed #detail-panel {
            display: none !important; 
        }


        /* 🌟 1. 왼쪽 사이드바 컨테이너 (검색창 + 결과 목록) */
        .left-sidebar {
            position: absolute;
            top: 60px;
            left: 20px;
            width: 400px; /* 고정 너비 */
            height: calc(100vh - 80px);
            z-index: 1000;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        /* 검색 입력창 */
        #search-container {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(0, 0, 0, 0.08);
            /* z-index를 높여 상세/목록 패널 위로 오게 함 */
            z-index: 10; 
        }

        #keyword {
            flex: 1;
            padding: 10px 12px;
            border: none;
            background: transparent;
            font-size: 15px;
            outline: none;
            color: #333;
        }

        #keyword::placeholder {
            color: #999;
        }

        #search-btn {
            padding: 10px 24px;
            margin-left: 8px;
            /* 상세 패널과 일관된 그라데이션 */
            background: linear-gradient(135deg, #52c41a 0%, #95de64 100%); 
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        #search-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 24px rgba(82, 196, 26, 0.4);
        }

        /* 🌟 검색 결과 패널 - 왼쪽 하단 */
        #stations-list-panel {
            flex: 1;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            display: none; /* JS에서 'flex'로 변경 */
            flex-direction: column;
            border: 1px solid rgba(0, 0, 0, 0.08);
        }

        #stations-list-panel h3 {
            margin: 0;
            padding: 20px 20px 16px;
            display: flex;
            justify-content: space-between; /* 💡 'flex-start'에서 'space-between'으로 변경 */
            align-items: center;         /* 💡 수직 중앙 정렬 */
            font-size: 18px;
            font-weight: 700;
            color: #333;
            background: #f8f9fa;
            border-bottom: 1px solid rgba(0, 0, 0, 0.08);
        }

        /* 2. 이 스타일을 <style> 태그 하단에 새로 추가하세요. */
        #filter-available-container {
            font-size: 14px;
            font-weight: 500;
            color: #555;
            display: flex;
            align-items: center;
        }
        #filter-available-container input[type="checkbox"] {
            margin-right: 6px;
            width: 15px;
            height: 15px;
            vertical-align: middle;
            cursor: pointer;
        }
        #filter-available-container label {
            margin-bottom: 0; /* Bootstrap CSS와 충돌 방지 */
            cursor: pointer;
            user-select: none; /* 글자 선택 방지 */
        }


        #stations-list {
            flex: 1;
            overflow-y: auto;
            padding: 8px;
        }

        /* 🌟 검색 결과 항목 스타일 (상세 패널과 비슷하게) */
        .station-item {
            padding: 16px;
            margin-bottom: 6px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
            background: white;
            border: 1px solid rgba(0, 0, 0, 0.06);
        }

        .station-item:hover {
            background: #f8f9fa;
            border-color: #52c41a; /* 그라데이션 주색 */
            transform: translateX(2px);
        }

        .station-item.active {
            /* 활성화 상태 스타일 */
            background: linear-gradient(135deg, rgba(82, 196, 26, 0.1) 0%, rgba(149, 222, 100, 0.1) 100%);
            border-color: #52c41a;
        }

        .station-item strong {
            display: block;
            font-size: 15px;
            font-weight: 700;
            color: #333;
            margin-bottom: 6px;
        }

        .station-item span {
            font-size: 13px;
            color: #777;
            line-height: 1.4;
        }
        
        /* 🌟 2. 상세 패널 위치 재조정 (검색 결과 옆) */
        #detail-panel {
            position: absolute;
            top: 60px;
            /* 400px (사이드바) + 24px (간격) = 424px. 안전하게 444px */
            left: 444px; 
            width: 380px; 
            height: calc(100vh - 80px);
            z-index: 1000;
            display: none; 
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            overflow-y: auto;
            border-radius: 12px;
            animation: slideInRight 0.3s ease; /* 애니메이션 방향 변경 */
            border: 1px solid rgba(0, 0, 0, 0.08);
            transition: left 0.3s ease; 
        }
        
        /* 💡 마커 클릭 시 상세 패널 위치 (목록이 닫혔을 때) */
        .sidebar-closed #detail-panel {
            /* JS가 위치를 덮어쓰도록 함 */
        }


        @keyframes slideInRight {
            from {
                transform: translateX(20px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        /* 현재 위치 검색 버튼 - 하단 중앙으로 수정 */
        #search-bounds-btn-container {
            position: absolute;
            bottom: 30px;
            left: 50%; /* 💡 중앙 정렬 시작 */
            transform: translateX(-50%); /* 정확한 중앙 정렬 */
            z-index: 1010;
            transition: none; /* 동적 이동 로직 제거로 인한 트랜지션도 제거 */
        }

        #search-bounds-btn {
            padding: 16px 28px;
            background: white;
            color: #52c41a;
            border: 2px solid #52c41a;
            border-radius: 50px;
            cursor: pointer;
            font-weight: 700;
            font-size: 15px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        #search-bounds-btn:hover {
            background: linear-gradient(135deg, #52c41a 0%, #95de64 100%);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 24px rgba(82, 196, 26, 0.4);
        }

        /* 빈 결과 메시지 */
        #stations-list p {
            text-align: center;
            color: #999;
            padding: 40px 20px;
            font-size: 14px;
        }

        /* 🌟 3. 반응형 (모바일 레이아웃) */
        @media (max-width: 1024px) {
            .left-sidebar {
                width: 320px;
            }
            #detail-panel {
                left: 356px; /* 320px + 24px 간격 */
                width: 320px;
            }
            #toggle-sidebar-btn-container {
                left: 340px; /* 320px + 20px 간격 */
            }
            .sidebar-closed #toggle-sidebar-btn-container {
                left: 20px !important;
            }
            
            /* 마커 클릭 시 상세 패널 위치 재조정 (모바일) */
            /* .sidebar-closed #detail-panel {
                left: 20px !important; 
                width: calc(100% - 40px);
            } */
        }

        @media (max-width: 768px) {
            /* 지도 아래쪽에 패널을 쌓음 */
            .left-sidebar, #detail-panel {
                width: calc(100% - 40px);
                left: 20px;
                height: 45vh; /* 화면의 45% 사용 */
                bottom: 20px;
                top: auto;
            }

            .left-sidebar {
                height: 45vh;
                margin-bottom: 10px; /* 상세 패널과의 간격 */
            }
            
            /* 상세 패널은 검색 결과가 닫히면 전체 화면 하단을 차지 */
            #detail-panel {
                height: 45vh;
                margin-bottom: 0;
            }
            
            /* 검색 결과 패널 위에 상세 패널이 뜨도록 z-index 조정 */
            .left-sidebar { z-index: 1000; }
            #detail-panel { z-index: 1001; }
            
            /* 현재 위치 버튼 위치 조정 */
            #search-bounds-btn-container {
                top: 70px;
                right: 20px;
                bottom: auto;
                left: auto;
                transform: none;
            }

            /* 모바일에서 토글 버튼 위치 변경 */
            #toggle-sidebar-btn-container {
                top: 70px;
                left: 20px;
            }
        }


        /* 💡 [추가] 현재 위치 버튼 스타일 */
        #my-location-btn-container {
            position: absolute;
            top: 140px; /* 맵 컨트롤(MapTypeControl) 바로 아래 */
            right: 45px;
            z-index: 1010;
        }
        #my-location-btn {
            width: 40px;
            height: 40px;
            background: #fff;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.15);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: #555;
            transition: all 0.2s ease;
        }
        #my-location-btn:hover {
            background: #f9f9f9;
            color: #000;
        }
    </style>
</head>
<body class="sidebar-closed">
    
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>
    <jsp:include page="detail_panel.jsp"/>
    
    <div id="toggle-sidebar-btn-container">
        <button id="toggle-sidebar-btn" title="사이드바 보이기">
            <i class="fas fa-chevron-left"></i> </button>
    </div>
    
    <div class="left-sidebar">
        <div id="search-container">
            <input type="text" id="keyword" placeholder="🔍 충전소명, 주소 검색">
            <button id="search-btn">검색</button>
        </div>

        <div id="stations-list-panel">
            <h3>
                <span>🔎 검색 결과</span>
                
                <div id="filter-available-container">
                    <input type="checkbox" id="available-only-toggle">
                    <label for="available-only-toggle">이용 가능만 보기</label>
                </div>
            </h3>
            <div id="stations-list"></div>
        </div>
    </div>

    <div id="my-location-btn-container">
        <button id="my-location-btn" title="현재 내 위치로 이동">
            <i class="fa fa-crosshairs"></i>
        </button>
    </div>

    <div id="search-bounds-btn-container">
        <button id="search-bounds-btn">
            <span></span>
            <span>현재 위치에서 찾기</span>
        </button>
    </div>

    <div id="map"></div>

    <%-- (주의) appkey는 본인의 키로, libraries=services가 포함되어야 합니다 --%>
    <script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=ed669a0f0c7b004abc0c496f1e2ac4a0&libraries=services,clusterer"></script>
    
    <script>
    var map; 
    var markers = []; 
    var stationsListEl; // 전역 선언
    var stationsListPanel; // 전역 선언
    var activeStationItem = null; 
    var availableOnlyToggle = null;

    var selectedMarker = null; // 💡 [추가] 1. 전역 변수로 이동
    var selectedMarkerImage = null; // 💡 [추가] 2. 전역 변수로 추가
    
    var markerClusterer = null; // 💡 [추가] 클러스터러 객체를 담을 변수
    var customOverlays = []; // 💡 [추가] Custom Overlay 배열
    var nearbyMarkers = []; // 💡 [추가] 주변 편의시설 마커 배열 (새로 추가)
    
    // 🌟 상수 정의
    const DEFAULT_TOGGLE_LEFT = '424px'; // 400px (사이드바) + 24px (간격)
    const DETAIL_OPEN_TOGGLE_LEFT = '828px'; // 444px (상세 시작) + 380px (상세 너비) + 4px (간격)
    
    // 💡 [추가] 클러스터링/Custom Overlay 숨김 기준 레벨 (레벨 5 미만일 때 Custom Overlay 표시)
    const HIDE_ZOOM_LEVEL = 5; 
    
    // ⭐ [핵심 추가] 마커를 완전히 숨길 레벨 (레벨 9 이상)
    const HIDE_ALL_MARKERS_ZOOM_LEVEL = 9; 

    
    // --- [전역 함수로 이동]: 마커 제거 함수 ---
    function clearMarkers() {
        // 클러스터러가 관리하는 마커 제거
        if (markerClusterer) {
            markerClusterer.clear(); // 💡 [수정] 클러스터러에 등록된 모든 마커를 제거
            
            // 클러스터러가 관리하지 못하는 마커도 혹시 남아있을 수 있으므로 개별 제거 시도
            for (var i = 0; i < markers.length; i++) {
                 markers[i].setMap(null); 
            }
        }

        // Custom Overlay 제거
        for (var i = 0; i < customOverlays.length; i++) {
            customOverlays[i].setMap(null);
        }
        customOverlays = [];
        
        markers = [];
        
        // 선택 마커 초기화 (지도에서 제거)
        if (selectedMarker) {
            selectedMarker.setImage(null);
            selectedMarker.setMap(null); // 지도에서 명시적으로 제거
            selectedMarker = null;
        }
    }
    
    // --- [전역 함수]: 주변 편의시설 마커 정리/복구 함수 ---
    function clearNearbyMarkers(restoreStations = true) {
        // 편의시설 마커 삭제
        for (var i = 0; i < nearbyMarkers.length; i++) {
            nearbyMarkers[i].setMap(null);
        }
        nearbyMarkers = [];

        // 충전소 마커 복구 로직 (새 검색 시에는 false로 호출되므로 실행 안 됨)
        if (restoreStations) {
            // 마커 복구 시 클러스터러에 다시 등록하여 클러스터링 재개
            if (markerClusterer && markers.length > 0) {
                markerClusterer.addMarkers(markers);
            }
            
            // Custom Overlay 복구 (줌 레벨에 따라 표시/숨김)
            var level = map.getLevel();
            var showOverlays = level < HIDE_ZOOM_LEVEL;
            for (var i = 0; i < customOverlays.length; i++) {
                if (customOverlays[i]) customOverlays[i].setMap(showOverlays ? map : null);
            }
        }
    }
    
	// --- [전역 함수]: 마커와 목록을 지도에 표시하는 함수 ---
	    function displayStations(stations, skipMapMove) {
	        clearMarkers(); 
	        stationsListEl.innerHTML = ''; 
	        var bounds = new kakao.maps.LatLngBounds();
	        
            // 💡 [추가] 현재 지도 레벨 확인 (Custom Overlay 표시 여부 판단)
	        var currentLevel = map.getLevel();
	        var showOverlays = currentLevel < HIDE_ZOOM_LEVEL;
	        
	        // 1. DOM 요소 참조
	        var panel = document.getElementById('detail-panel');
	        var stationNameEl = document.getElementById('station-name');
	        var stationAddressEl = document.getElementById('station-address');
	        
	        var operator_large = document.getElementById('operator_large');
	        var busi_call = document.getElementById('busi_call');
	        var use_time = document.getElementById('use_time');
	        var parking_free = document.getElementById('parking_free');
	        var facility_type_large = document.getElementById('facility_type_large');
	        var user_restriction = document.getElementById('user_restriction');
	        
	        // [New] 업데이트 시간 표시 요소 참조
	        var lastUpdatedEl = document.getElementById('last-updated-time');
	        
	        var toggleContainer = document.getElementById('toggle-sidebar-btn-container');
	        var body = document.body;

	        // ---------------------------------------------------------
	        // 🌟 [신규 기능] 개별 충전기 상태 조회 및 패널 열기 함수
	        // ---------------------------------------------------------
			// 💡 [수정] 타입 코드를 받지 않는 loadChargerDetails 유지 (구버전 호환)
			window.loadChargerDetails = function(apiStatId) {
			    var statusPanel = document.getElementById('status-detail-panel');
			    var listContainer = document.getElementById('real-time-charger-list');
			    
			    // 패널 열기
			    if(statusPanel) {
			        statusPanel.style.display = 'block'; 
			        setTimeout(function() { statusPanel.classList.add('open'); }, 10);
			    }
			    
			    if(listContainer) listContainer.innerHTML = '<li style="padding:20px;text-align:center;color:#666;">데이터 불러오는 중...</li>';

			    // API 호출
			    fetch('${pageContext.request.contextPath}/station/chargers?statId=' + apiStatId)
			        .then(function(res) { return res.json(); })
			        .then(function(data) {
			            var html = '';
			            var syncTime = ''; 

			            if(!data || data.length === 0) {
			                html = '<li style="padding:20px;text-align:center;">상세 정보가 없습니다.</li>';
			            } else {
			                // 실시간 갱신 시간 표시
			                if (data[0].lastSyncedAt) {
			                    syncTime = '<div style="padding:10px 15px;text-align:right;font-size:11px;color:#888;background:#f9f9f9;border-bottom:1px solid #eee;">🕒 실시간 갱신: ' + data[0].lastSyncedAt + '</div>';
			                }

			                data.forEach(function(c) {
			                    // 1. 상태 코드 해석
			                    var statClass = 'stat-gray';
			                    var statText = '알수없음';
			                    var statColor = '#999';
			                    
			                    if(c.stat == 2) { statClass = 'stat-green'; statText = '대기중'; statColor = '#52c41a'; }
			                    else if(c.stat == 3) { statClass = 'stat-red'; statText = '충전중'; statColor = '#ff4d4f'; }
			                    else if(c.stat == 1) { statText = '통신이상'; }
			                    else if(c.stat == 4) { statText = '운영중지'; }
			                    else if(c.stat == 5) { statText = '점검중'; }
			                    
			                    var outputStr = c.output ? c.output + 'kW' : '-';

			                    // 2. 혼잡도 점수 처리
			                    var score = c.congestionScore || 0;
			                    var scoreColor = '#52c41a'; 
			                    
			                    if (score >= 70) {
			                        scoreColor = '#ff4d4f'; 
			                    } else if (score >= 40) {
			                        scoreColor = '#faad14'; 
			                    }
			                    
			                    // 🌟 [추가] 3. 상태 꼬리표 처리
			                    var statusMsg = c.statusMsg || ''; // DTO에서 전달받은 메시지 (예: (장기주차))
			                    var msgHtml = '';
			                    
			                    if (statusMsg.includes('점검필요')) {
			                        // 🚫 아이콘과 회색 경고
			                        msgHtml = '<span style="color:#999; font-size:11px; margin-left:4px;">🚫' + statusMsg + '</span>';
			                    } else if (statusMsg.includes('장기주차')) {
			                        // ⚠️ 아이콘과 빨간색 경고
			                        msgHtml = '<span style="color:#ff4d4f; font-size:11px; margin-left:4px; font-weight:700;">⚠️' + statusMsg + '</span>';
			                    }

			                    // 4. HTML 생성 (JSP 충돌 방지 버전)
			                    html += '<li class="status-item">';
			                    html += '    <div class="status-indicator ' + statClass + '"></div>';
			                    html += '    <div style="flex: 1;">';
			                    html += '        <span class="charger-id-badge">' + c.chargerId + '번</span>';
			                    html += '        <div class="charger-info-text" style="margin-top:4px;">';
			                    html += '            ' + c.typeName + ' <span style="color:#999;font-size:11px;">(' + outputStr + ')</span>';
			                    html += '        </div>';
			                    html += '    </div>';
			                    html += '    <div style="text-align: right;">';
			                    html += '        <div class="charger-status-text" style="color:' + statColor + '; margin-bottom: 2px;">';
			                    // 🌟 [수정] 상태 텍스트 옆에 꼬리표를 합쳐서 표시
			                    html += '            ' + statText + msgHtml; 
			                    html += '        </div>';
			                    html += '        <div style="font-size: 11px; color: #888;">';
			                    html += '            예상 혼잡도 <span style="color:' + scoreColor + '; font-weight: bold;">' + score + '%</span>';
			                    html += '        </div>';
			                    html += '    </div>';
			                    html += '</li>';
			                });
			            }
			            listContainer.innerHTML = syncTime + html;
			        })
			        .catch(function(err) {
			            console.error(err);
			            if(listContainer) listContainer.innerHTML = '<li style="padding:20px;text-align:center;">오류가 발생했습니다.</li>';
			        });
			};

	        // 상태 패널 닫기 함수
	        window.closeStatusPanel = function() {
	            var statusPanel = document.getElementById('status-detail-panel');
	            if(statusPanel) {
	                statusPanel.classList.remove('open'); // 슬라이드 아웃
	                // 애니메이션(0.3초) 끝난 뒤 display none
	                setTimeout(() => {
	                    statusPanel.style.display = 'none';
	                }, 300);
	            }
	        };
	        // ---------------------------------------------------------

	        stations.forEach(function(station, index) { 
	            // 2. 마커 생성
	            var markerPosition  = new kakao.maps.LatLng(station.latitude, station.longitude); 
	            var marker = new kakao.maps.Marker({ position: markerPosition });
	            
	            markers.push(marker); 
	            bounds.extend(markerPosition);
	            
	            // 🔹 [추가] 마커 위 충전기 개수 표시 (CustomOverlay)
	            var total = (station.fastChargerCount || 0) + (station.slowChargerCount || 0);
	            var avail = (station.availableChargerCount !== undefined) ? station.availableChargerCount : 0;

	            var labelContent =
	                '<div style="background:#007bff;color:#fff;padding:2px 8px;border-radius:12px;font-size:12px;font-weight:bold;box-shadow:0 2px 6px rgba(0,0,0,0.3);white-space:nowrap;">'
	                + avail + ' / ' + total +
	                '</div>';

	            var label = new kakao.maps.CustomOverlay({
	                position: markerPosition,
	                content: labelContent,
	                xAnchor: 0.5,
	                yAnchor: 3.0 // 💡 마커 위쪽으로 위치 조정
	            });
	            
	            // 💡 [수정] 지도 레벨에 따라 Custom Overlay를 초기 표시
	            if (showOverlays) {
	                label.setMap(map);
	            }
	            customOverlays.push(label);


	            // 3. 목록 항목 생성
	            var item = document.createElement('div');
	            item.className = 'station-item';
	            
	            var nameEl = document.createElement('strong');
	            nameEl.textContent = station.stationName;
	            
	            var addressEl = document.createElement('span');
	            addressEl.textContent = station.address;
	            
	            item.appendChild(nameEl);
	            item.appendChild(addressEl);

	            item.dataset.userRestriction = station.note || '정보 없음';
	            item.linkedMarker = marker;

	            // 4. 클릭 이벤트
	            var clickHandler = function() {
	                // 활성화 스타일
	                if (activeStationItem) activeStationItem.classList.remove('active');
	                item.classList.add('active');
	                activeStationItem = item;

	                // 마커 이미지 변경
	                if (selectedMarker) selectedMarker.setImage(null);
	                marker.setImage(selectedMarkerImage);
	                selectedMarker = marker;
	                
	                // 상세 패널 닫혀있던 상태 패널 초기화
	                closeStatusPanel();

	                // ⭐⭐⭐ [핵심 수정: 클러스터링 중단 및 모든 마커/오버레이 지도에 표시] ⭐⭐⭐
	                
	                // 1. 클러스터러에서 모든 마커를 제거하여 클러스터링 중단
	                if (markerClusterer) {
	                    markerClusterer.removeMarkers(markers);
	                }

	                // 2. Custom Overlay 모두 표시 (클릭 시 가시성 유지)
	                for (var i = 0; i < customOverlays.length; i++) {
	                    if (customOverlays[i]) customOverlays[i].setMap(map); 
	                }

	                // 3. 모든 마커를 지도에 직접 띄우기 (클러스터링 안 되게 강제)
	                for (var i = 0; i < markers.length; i++) {
	                    markers[i].setMap(map);
	                }
	                // --------------------------------------------------

	                // --- 데이터 매핑 ---
	                stationNameEl.textContent = station.stationName;
	                stationAddressEl.textContent = station.address;
	                
	                operator_large.textContent = station.operator || '-';
	                busi_call.textContent = station.busiCall || '-';
	                use_time.textContent = station.useTime || '-';
	                
	                if (station.parkingFree === 'Y') {
	                    parking_free.textContent = '무료 주차 가능';
	                    parking_free.style.color = '#52c41a';
	                } else if (station.parkingFree === 'N') {
	                    parking_free.textContent = '주차료 유료 / 불가';
	                    parking_free.style.color = '#666';
	                } else {
	                    parking_free.textContent = '정보 없음';
	                    parking_free.style.color = '#666';
	                }

	                facility_type_large.textContent = station.facilityTypeLarge || '-';

	                var restrictionText = station.note || '정보 없음';
	                user_restriction.textContent = restrictionText;
	                user_restriction.classList.remove('badge-yellow', 'badge-red');
	                
	                if (restrictionText.includes('제한') || restrictionText.includes('거주자')) {
	                    user_restriction.classList.add('badge-yellow');
	                } else if (restrictionText === '비공개' || restrictionText.includes('점검')) {
	                    user_restriction.classList.add('badge-red');
	                }

	                // 충전기 개수
	                var fastCount = station.fastChargerCount || 0;
	                var slowCount = station.slowChargerCount || 0;

	                var fastEl = document.getElementById('fast-charger-count');
	                var slowEl = document.getElementById('slow-charger-count');
	                if (fastEl) fastEl.textContent = fastCount;
	                if (slowEl) slowEl.textContent = slowCount;
	                
	                // ---------------------------------------------------------
	                // 🌟 [핵심] 리스트 생성 시 onclick 이벤트 연결
	                // ---------------------------------------------------------
	                var fastDetailsList = document.getElementById('fast-details-list');
	                var slowDetailsList = document.getElementById('slow-details-list');
	                
	                const TYPE_NAMES = {
	                    '01': 'DC차데모', '02': 'AC완속', '03': 'DC차데모+AC3상',
	                    '04': 'DC콤보', '05': 'DC차데모+DC콤보', '06': 'DC차데모+AC3상+DC콤보',
	                    '07': 'AC3상', '08': 'DC콤보(완속)', '09': 'NACS', '10': 'DC콤보+NACS'
	                };

	                // 급속 목록 생성
	                var fastHtml = '';
	                const fastCodes = ['01', '03', '04', '05', '06', '07', '09', '10'];
	                
	                fastCodes.forEach(function(code) {
	                    var count = station['countType' + code]; 
	                    if (count > 0) {
	                        // 💡 클릭 시 loadChargerDetails 호출 (타입 코드를 받지 않음)
	                        fastHtml += '<li style="cursor:pointer;" onclick="loadChargerDetails(\'' + station.apiStatId + '\')">' +
	                                    '<span>' + TYPE_NAMES[code] + '</span>' +
	                                    '<span style="background:#e6f7ff;color:#1890ff;padding:2px 6px;border-radius:4px;font-weight:700;">👉 ' + count + '기</span></li>';
	                    }
	                });
	                
	                if (fastHtml === '' && fastCount > 0 && station.fastChargeCapacity) {
	                     fastHtml += '<li><span>기타/용량정보</span><span>' + station.fastChargeCapacity + '</span></li>';
	                }

	                // 완속 목록 생성
	                var slowHtml = '';
	                const slowCodes = ['02', '08'];
	                
	                slowCodes.forEach(function(code) {
	                    var count = station['countType' + code];
	                    if (count > 0) {
	                        // 💡 클릭 시 loadChargerDetails 호출
	                        slowHtml += '<li style="cursor:pointer;" onclick="loadChargerDetails(\'' + station.apiStatId + '\')">' +
	                                    '<span>' + TYPE_NAMES[code] + '</span>' +
	                                    '<span style="background:#f6ffed;color:#52c41a;padding:2px 6px;border-radius:4px;font-weight:700;">👉 ' + count + '기</span></li>';
	                    }
	                });

	                fastDetailsList.innerHTML = fastHtml;
	                slowDetailsList.innerHTML = slowHtml;
	                
	                fastDetailsList.style.display = 'none';
	                slowDetailsList.style.display = 'none';

	                // ---------------------------------------------------------
	                // 🌟 [추가된 부분] 마지막 업데이트 시간 표시
	                // ---------------------------------------------------------
	                if (lastUpdatedEl) {
	                    var lastTime = station.lastUpdated; 
	                    if (lastTime) {
	                        lastUpdatedEl.textContent = lastTime;
	                    } else {
	                        lastUpdatedEl.textContent = "정보 없음";
	                    }
	                }

                // 즐겨찾기 ID 설정 (이 함수 내에서 혼잡도 차트도 자동으로 업데이트됨)
                if (typeof setStationIdAndCheckFavorite === 'function') {
                    setStationIdAndCheckFavorite(station.apiStatId); 
                }

	                // 지도 이동 및 UI 처리
	                map.setCenter(markerPosition);
	                map.setLevel(3); // ⭐⭐⭐ 레벨 7로 수정 ⭐⭐⭐
	                panel.style.display = 'block';
	                body.classList.remove('sidebar-closed');
	                panel.style.left = '444px'; 
	                panel.style.width = '380px';
	                if (toggleContainer) {
	                    toggleContainer.style.left = DETAIL_OPEN_TOGGLE_LEFT;
	                    toggleContainer.title = "사이드바 숨기기";
	                }

	                // 버튼 링크
	                var naviLink = document.getElementById('navi-link');
	                if (naviLink) {
	                    var safeName = encodeURIComponent(station.stationName);
	                    naviLink.href = 'https://map.kakao.com/link/to/' + safeName + ',' + station.latitude + ',' + station.longitude;
	                }
	                var roadviewLink = document.getElementById('roadview-link');
	                if (roadviewLink) {
	                    roadviewLink.href = 'https://map.kakao.com/link/roadview/' + station.latitude + ',' + station.longitude;
	                }

                    // ✅ [추가] 상세 패널이 열릴 때, 현재 충전소 좌표를 hidden input에 심어둡니다.
                    document.getElementById('current-lat').value = station.latitude;
                    document.getElementById('current-lng').value = station.longitude;
	            };

	            kakao.maps.event.addListener(marker, 'click', clickHandler);
	            item.addEventListener('click', clickHandler);
	            
	            stationsListEl.appendChild(item);
	        });

            // 🌟 [추가] 모든 마커 생성이 끝난 후 클러스터러에 일괄 추가
            if (markerClusterer) {
                markerClusterer.addMarkers(markers);
            }

	        if (!skipMapMove && stations.length > 0) {
	             if (stations.length === 1) {
	                map.setCenter(bounds.getCenter());
	                map.setLevel(4); 
	            } else {
	                 map.setBounds(bounds);
	            }
	        } 
	    }
    
    // 🌟 [추가된 함수] 헤더의 즐겨찾기 버튼 클릭 시 호출됨 (전역으로 정의)
    function displayFavoriteStations(stations) {
        if (stations && stations.length > 0) {
            // 🌟 [수정]: 두 번째 인자로 true를 전달하여 displayStations 내부의 지도 이동 로직을 건너뜁니다.
            displayStations(stations, true); 
            stationsListPanel.querySelector('h3 span').textContent = '💚 즐겨찾기 목록'; // 💡 제목 변경
            stationsListPanel.style.display = 'flex';
            
            // 🌟 [수정]: bounds 계산 및 설정 (여기서 지도 이동 처리하여 1개일 때 오류 방지)
            var bounds = new kakao.maps.LatLngBounds(); 
            markers.forEach(function(marker) {
                bounds.extend(marker.getPosition());
            });
            
            // 마커가 1개 이상 있으므로 map.setBounds는 안전합니다.
            map.setBounds(bounds); 
            
        } else {
            clearMarkers();
            stationsListEl.innerHTML = '<p>등록된 즐겨찾기가 없습니다.</p>';
            stationsListPanel.querySelector('h3 span').textContent = '💚 즐겨찾기 목록'; // 💡 제목 변경
            stationsListPanel.style.display = 'flex';
        }
        
        // 상세 패널 닫기 (새로운 목록이 뜰 때 상세 패널은 초기화)
        var panel = document.getElementById('detail-panel');
        var toggleContainer = document.getElementById('toggle-sidebar-btn-container'); 
        var body = document.body; // body 참조 추가
        
        if (panel) {
            panel.style.display = 'none';

            // 💡 [추가] 선택된 마커 초기화
            if (selectedMarker) {
                selectedMarker.setImage(null);
                selectedMarker = null;
            }
        }
        
        // 🌟 [수정] 목록이 새로 열리면 사이드바 상태 복구
        body.classList.remove('sidebar-closed'); 

        // 목록이 열렸으므로 토글 버튼 위치를 목록 옆으로 이동
        if (toggleContainer) {
            toggleContainer.style.left = DEFAULT_TOGGLE_LEFT;
        }

        if (activeStationItem) {
            activeStationItem.classList.remove('active');
            activeStationItem = null;
        }
    }
    
    // 💡 [새로 추가된 함수] 헤더 및 상세 패널에서 즐겨찾기 목록 조회를 요청하는 AJAX 함수 (전역)
    function fetchFavoriteStations() {
        
        const panel = document.getElementById('detail-panel');
        // 상세 패널 닫기 (목록을 새로 열기 위함)
        if (panel) panel.style.display = 'none';
        
        // 로그인 여부 확인 및 요청
        fetch('${pageContext.request.contextPath}/favorite/list')
            .then(response => {
                // 응답 코드가 401 Unauthorized 등 로그인 필요 응답일 수 있음
                if (response.status === 401) { 
                    alert('로그인 후 즐겨찾기 목록을 이용할 수 있습니다.');
                    return null;
                }
                if (!response.ok) {
                    throw new Error('즐겨찾기 목록을 가져오는 중 오류 발생');
                }
                return response.json();
            })
            .then(stations => {
                if (stations) {
                    displayFavoriteStations(stations); 
                }
            })
            .catch(error => {
                console.error('즐겨찾기 목록 로드 실패:', error);
                alert('즐겨찾기 목록을 가져올 수 없습니다. 서버 상태를 확인해주세요.');
                
                // 오류 발생 시 목록 패널 초기화
                if (stationsListEl && stationsListPanel) {
                    clearMarkers();
                    stationsListEl.innerHTML = '<p>데이터 로드 중 오류 발생.</p>';
                    stationsListPanel.style.display = 'flex';
                    stationsListPanel.querySelector('h3 span').textContent = '💚 즐겨찾기 목록';
                }
            });
    }


    window.onload = function() {
        
        var mapContainer = document.getElementById('map'), 
            mapOption = {
                center: new kakao.maps.LatLng(35.15781570000001 , 129.0600331),
                level: 7
            }; 
        map = new kakao.maps.Map(mapContainer, mapOption); // 전역 변수 초기화

        
        // 🌟 [추가] 마커 클러스터러 생성
        markerClusterer = new kakao.maps.MarkerClusterer({
            map: map, // 마커들을 표시할 지도 객체 
            averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정 
            minLevel: HIDE_ZOOM_LEVEL, // 💡 [핵심] 최소 클러스터링 레벨을 HIDE_ZOOM_LEVEL로 설정
            disableClickZoom: true, // 클러스터 클릭 시 확대 방지 (직접 경계 이동 처리)
            
            // 💡 [추가] 클러스터 스타일을 개수 범위별로 정의 (100개 초과 시 실제 개수 표시)
            calculator: [10, 50, 99999], // 0~10, 11~50, 51~99999
            styles: [
                // 10개 이하 (연한 녹색)
                {
                    width: '38px', height: '38px',
                    background: 'rgba(82, 196, 26, 0.6)', 
                    color: '#fff', textAlign: 'center', lineHeight: '39px',
                    borderRadius: '50%', fontWeight: 'bold', fontSize: '12px',
                    text: 'cluster'
                },
                // 11개 ~ 50개 (주황색)
                {
                    width: '45px', height: '45px',
                    background: 'rgba(250, 173, 20, 0.7)', 
                    color: '#fff', textAlign: 'center', lineHeight: '46px',
                    borderRadius: '50%', fontWeight: 'bold', fontSize: '13px',
                    text: 'cluster'
                },
                // 51개 ~ 99999개 (빨간색)
                {
                    width: '55px', height: '55px',
                    background: 'rgba(255, 77, 79, 0.8)', 
                    color: '#fff', textAlign: 'center', lineHeight: '56px',
                    borderRadius: '50%', fontWeight: 'bold', fontSize: '14px',
                    text: 'cluster'
                },
                 // 99999개 초과 시 (Index 3: Index 2와 동일하게 처리되지만 텍스트 제한을 해제하기 위함)
                 {
                    width: '55px', height: '55px',
                    background: 'rgba(255, 77, 79, 0.9)', 
                    color: '#fff', textAlign: 'center', lineHeight: '56px',
                    borderRadius: '50%', fontWeight: 'bold', fontSize: '14px',
                    text: 'cluster' 
                }
            ],
            // texts 배열을 제거하여 실제 개수가 표시되도록 합니다.
        });


        // 💡 [신규 기능] 클러스터 클릭 시 이벤트 리스너
        kakao.maps.event.addListener(markerClusterer, 'clusterclick', function(cluster) {
            
            var bounds = cluster.getBounds();
            map.setBounds(bounds); // 경계 내의 모든 마커가 보이도록 이동 및 확대
            
            // 클러스터를 클릭했으므로 상세 패널 및 선택 마커 상태 초기화
            if (selectedMarker) {
                selectedMarker.setImage(null);
                selectedMarker.setMap(null); 
                selectedMarker = null;
            }
            document.getElementById('detail-panel').style.display = 'none';

        });


        // 💡 [추가] 2. 노란색 마커 이미지 객체 생성
        var imageSrc = '${pageContext.request.contextPath}/image/sel_marker_yellow_small.png'; // 💡 새 이름
        var imageSize = new kakao.maps.Size(38, 50); // 💡 새 크기
        var imageOption = { offset: new kakao.maps.Point(14, 39) }; // 💡 새 오프셋
    
        selectedMarkerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);

        // 💡 [추가] 이 객체가 잘 생성되었는지 콘솔에 찍어봅니다.
        console.log("노란색 마커 이미지 객체:", selectedMarkerImage);

        var mapTypeControl = new kakao.maps.MapTypeControl();
        map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
        var zoomControl = new kakao.maps.ZoomControl();
        map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

        var ps = new kakao.maps.services.Places(); 
        
        var keywordEl = document.getElementById('keyword');
        var searchBtn = document.getElementById('search-btn');
        var searchBoundsBtn = document.getElementById('search-bounds-btn'); 

        var myLocationBtn = document.getElementById('my-location-btn'); // 💡 [추가]
        
        // 🌟 전역 변수 초기화
        stationsListPanel = document.getElementById('stations-list-panel'); 
        stationsListEl = document.getElementById('stations-list'); 
        
        var panel = document.getElementById('detail-panel');
        var closeBtn = document.getElementById('close-btn');

        // 💡 [추가] 급속/완속 상세 목록 토글 이벤트
        var fastToggle = document.getElementById('fast-charger-toggle');
        var slowToggle = document.getElementById('slow-charger-toggle');

        // 💡 [수정] 필터 체크박스 초기화 및 이벤트 리스너 (로직 수정됨)
        availableOnlyToggle = document.getElementById('available-only-toggle');
        
        if (availableOnlyToggle) {
            availableOnlyToggle.addEventListener('change', function() {
                var isChecked = this.checked;
                var allItems = stationsListEl.querySelectorAll('.station-item');
                
                // 필터링 시 활성화된 항목 및 상세 패널 초기화
                if (activeStationItem) {
                    activeStationItem.classList.remove('active');
                    activeStationItem = null;
                    document.getElementById('detail-panel').style.display = 'none';
                    
                    var toggleContainer = document.getElementById('toggle-sidebar-btn-container');
                    if (toggleContainer) {
                        toggleContainer.style.left = DEFAULT_TOGGLE_LEFT;
                    }

                    // 💡 [추가] 선택된 마커 초기화
                    if (selectedMarker) {
                        selectedMarker.setImage(null);
                        selectedMarker = null;
                    }
                }

                // 💡 [클러스터러 수정 반영] 필터링 시 모든 마커를 임시 제거하고 필터링된 것만 추가
                markerClusterer.removeMarkers(markers); 
                var filteredMarkers = [];
                
                allItems.forEach(function(item) {
                    var restriction = item.dataset.userRestriction;
                    var isAvailable = (restriction === '이용가능' || restriction === '정보 없음'); 
                    var marker = item.linkedMarker;
                    
                    if (isChecked) { // 1. "이용 가능만" 체크 시
                        if (isAvailable) {
                            item.style.display = ''; 
                            if (marker) filteredMarkers.push(marker);
                        } else {
                            item.style.display = 'none';
                        }
                    } else { // 2. "이용 가능만" 체크 해제 시 (모두 보기)
                        item.style.display = ''; 
                        if (marker) filteredMarkers.push(marker);
                    }
                });

                // 💡 [클러스터러 수정 반영] 필터링된 마커만 클러스터러에 추가
                markerClusterer.addMarkers(filteredMarkers);
                
                // 💡 [추가] Custom Overlay도 필터링된 마커에 맞게 재표시/숨김 (여기서는 복잡해지므로 단순화: 필터링 시 모든 오버레이 숨김)
                for (var i = 0; i < customOverlays.length; i++) {
                    customOverlays[i].setMap(null); 
                }
            });
        }

        // 헬퍼 함수
        function setupToggle(toggleButton) {
            toggleButton.addEventListener('click', function(e) {
                // 텍스트 선택 등 방지
                e.stopPropagation(); 
                var targetList = document.querySelector(toggleButton.dataset.target);
                
                if (targetList) {
                    // 목록에 내용이 있을 때(빈 문자열이 아닐 때)만 토글 실행
                    if (targetList.innerHTML.trim() !== "") {
                        var isVisible = targetList.style.display === 'block';
                        targetList.style.display = isVisible ? 'none' : 'block';
                    }
                }
            });
        }

        // 두 카드에 토글 기능 적용
        if (fastToggle) setupToggle(fastToggle);
        if (slowToggle) setupToggle(slowToggle);
        
        // 🌟 사이드바 토글 로직 추가 (수정됨)
        var toggleSidebarBtn = document.getElementById('toggle-sidebar-btn');
        var toggleContainer = document.getElementById('toggle-sidebar-btn-container');
        var body = document.body;

        if (toggleSidebarBtn && toggleContainer) {
            toggleSidebarBtn.addEventListener('click', function() {
                var isClosed = body.classList.toggle('sidebar-closed');
                
                // 🌟 추가된 로직: 상세 패널이 현재 보이는지 확인
                var isDetailPanelVisible = panel.style.display === 'block';

                if (isClosed) {
                    toggleSidebarBtn.title = "사이드바 보이기";
                    // 닫힐 때는 CSS가 처리하도록 둡니다. (left: 20px)
                } else {
                    toggleSidebarBtn.title = "사이드바 숨기기";
                    
                    // 💡 핵심 수정: 상세 패널이 열려 있다면 토글 버튼을 828px로 이동
                    if (isDetailPanelVisible) {
                        toggleContainer.style.left = DETAIL_OPEN_TOGGLE_LEFT; // ⬅️ 828px로 이동
                    } else {
                        // 상세 패널이 닫혀 있다면 기본 위치(424px)로 복원
                        toggleContainer.style.left = DEFAULT_TOGGLE_LEFT;
                    }
                    
                    // 상세 패널 위치 복원 (목록 옆)
                    panel.style.left = '444px';
                    panel.style.width = '380px';
                }
            });
        }
        // ----------------------------------


        // 💡 [추가] '현재 내 위치' 버튼 클릭 이벤트
        if (myLocationBtn) {
            myLocationBtn.addEventListener('click', function() {
                
                // 1. 브라우저가 Geolocation을 지원하는지 확인
                if (navigator.geolocation) {
                    
                    // 2. Geolocation API로 현재 위치 가져오기
                    navigator.geolocation.getCurrentPosition(function(position) {
                        
                        // 3. 성공 시: 위도(latitude), 경도(longitude) 가져오기
                        var lat = position.coords.latitude;
                        var lng = position.coords.longitude;
                        
                        var locPosition = new kakao.maps.LatLng(lat, lng); 
                        
                        // 4. 지도를 현재 위치로 부드럽게 이동
                        map.panTo(locPosition);
                        map.setLevel(3); // 줌 레벨 5로 확대

                        // (선택 사항) 현재 위치에 임시 마커 표시
                        var marker = new kakao.maps.Marker({
                            position: locPosition
                        });
                        marker.setMap(map);
                        
                        // 2초 뒤에 마커 사라지게 하기 (임시 표시)
                        setTimeout(function() {
                            marker.setMap(null);
                        }, 2000);

                    }, function(error) {
                        // 5. 실패 시: 오류 처리
                        console.error('Geolocation 오류:', error);
                        alert('현재 위치를 가져올 수 없습니다. 위치 권한을 확인해주세요.');
                    });
                    
                } else {
                    // 브라우저가 Geolocation을 지원하지 않는 경우
                    alert('이 브라우저에서는 현재 위치 기능을 지원하지 않습니다.');
                }
            });
        }


        // DOM 이벤트 리스너 설정
        closeBtn.addEventListener('click', function() {
            panel.style.display = 'none';
            if (activeStationItem) {
                activeStationItem.classList.remove('active');
                activeStationItem = null;
            }
            // 🌟 [수정] 상세 패널 닫힐 때 사이드바를 다시 보이게 함
            var body = document.body;
            body.classList.remove('sidebar-closed');

            // 토글 버튼 위치 복원
            var toggleContainer = document.getElementById('toggle-sidebar-btn-container');
            if (toggleContainer) {
                toggleContainer.style.left = DEFAULT_TOGGLE_LEFT;
            }

            // 💡 [핵심 수정] 닫기 버튼 클릭 시 클러스터 상태 및 Custom Overlay 복구
            
            // 1. 노란 마커 이미지 해제 및 선택 마커 초기화
            if (selectedMarker) {
                selectedMarker.setImage(null);
                selectedMarker.setMap(null); // 지도에 직접 띄웠던 마커를 제거
                selectedMarker = null;
            }
            
            // 2. 클러스터러에게 모든 마커를 다시 관리하도록 요청 (클러스터링 재개)
            if (markerClusterer) {
                 markerClusterer.addMarkers(markers);
            }
            
            // 3. Custom Overlay 복구 (줌 레벨에 따라 표시/숨김)
            var level = map.getLevel();
            var showOverlays = level < HIDE_ZOOM_LEVEL;
            for (var i = 0; i < customOverlays.length; i++) {
                // 줌 레벨에 따라 오버레이를 표시하거나 숨깁니다.
                if (customOverlays[i]) customOverlays[i].setMap(showOverlays ? map : null);
            }

            // 주변 편의시설 마커도 정리
            clearNearbyMarkers(true); // 복구 시에는 주변 마커도 복구 시도 (주변 시설 마커는 restore true)
            
            // 지도 영역 재검색 버튼 위치 복구
            var searchBoundsBtnContainer = document.getElementById('search-bounds-btn-container');
            if (searchBoundsBtnContainer) {
                 searchBoundsBtnContainer.style.right = '30px'; 
                 searchBoundsBtnContainer.style.left = 'auto'; 
                 searchBoundsBtnContainer.style.transform = 'none'; 
            }
            
        });


        // Enter 키로 검색
        keywordEl.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchBtn.click();
            }
        });

        // 4-6. 검색 버튼 로직
        searchBtn.addEventListener('click', function() {
            var keyword = keywordEl.value.trim();
            
            // 검색 버튼 클릭 시 목록이 열리므로 사이드바 상태 복원 및 토글 버튼 위치 초기화
            var body = document.body;
            body.classList.remove('sidebar-closed'); 

            if (toggleContainer) {
                toggleContainer.style.left = DEFAULT_TOGGLE_LEFT;
            }
            
            // --- 1단계: 카카오 'Places' API로 좌표 변환 (장소 검색) ---
            ps.keywordSearch(keyword, function(data, status, pagination) {
                
                // --- 2단계: 분기 ---
                if (status === kakao.maps.services.Status.OK && data && data.length > 0) {
                    
                    var firstPlace = data[0];
                    var coords = new kakao.maps.LatLng(firstPlace.y, firstPlace.x); 
                    
                    map.setCenter(coords);
                    map.setLevel(4); 

                    // --- 3단계 (A): '반경'으로 DB 검색 ---
                    fetchStationsDataByRadius(coords.getLat(), coords.getLng());

                } else {
                    
                    // --- 3단계 (B): '키워드(LIKE)'로 DB 검색 ---
                    searchByKeyword(keyword);
                }
            });
        });
        
		// 💡 4-13. '현재 위치에서 찾기' 버튼 클릭 이벤트 (버튼 클릭시에만 작동)
		searchBoundsBtn.addEventListener('click', function() {
		    
		    var bounds = map.getBounds();
		    var swLatlng = bounds.getSouthWest();
		    var neLatlng = bounds.getNorthEast();

		    var minLat = swLatlng ? swLatlng.getLat() : NaN;
		    var maxLat = neLatlng ? neLatlng.getLat() : NaN;
		    var minLng = swLatlng ? swLatlng.getLng() : NaN;
		    var maxLng = neLatlng ? neLatlng.getLng() : NaN;
		    
		    if (isNaN(minLat) || isNaN(maxLat) || isNaN(minLng) || isNaN(maxLng) || (minLat == 0 && minLng == 0 && map.getLevel() < 10)) {
		        alert("지도 영역 정보를 가져올 수 없습니다. 지도를 움직이거나 확대/축소한 후 다시 시도해 주세요.");
		        console.error("Bounds check failed: Invalid coordinates detected.");
		        return; 
		    }
		    
            // 사이드바 상태 복원 및 토글 버튼 위치 초기화
            var body = document.body;
            body.classList.remove('sidebar-closed'); 
		    
            if (toggleContainer) {
                toggleContainer.style.left = DEFAULT_TOGGLE_LEFT;
            }
            
            // 중앙 하단으로 위치 조정
            var searchBoundsBtnContainer = document.getElementById('search-bounds-btn-container');
             if (searchBoundsBtnContainer) {
                 searchBoundsBtnContainer.style.right = 'auto'; 
                 searchBoundsBtnContainer.style.left = '50%'; 
                 searchBoundsBtnContainer.style.transform = 'translateX(-50%)'; 
            }
            
            // ⭐⭐⭐ [핵심 수정 로직 시작] ⭐⭐⭐
            
            // 1. 상세 패널 닫기
            var panel = document.getElementById('detail-panel');
            if (panel) {
                panel.style.display = 'none';
            }
            
            // 2. 이전 마커 및 클러스터 초기화 (마커 잔상 제거)
            clearMarkers(); 
            clearNearbyMarkers(false); 

            // 3. 새로운 영역 검색 시작
		    fetchStationsDataByBounds(minLat, maxLat, minLng, maxLng);
		});
        
        // 4-8. '반경' 검색 함수
        function fetchStationsDataByRadius(latitude, longitude) {
            if (availableOnlyToggle) availableOnlyToggle.checked = false; // 💡 필터 초기화

            // 💡 [추가] 선택된 마커 초기화
            if (selectedMarker) {
                selectedMarker.setImage(null);
                selectedMarker = null;
            }

            var radius = 2000; // 2km
            var url = '/searchByRadius?lat=' + latitude + '&lng=' + longitude + '&radius=' + radius; 
            
            fetch(url)
                .then(response => {
                    if (!response.ok) throw new Error('반경 검색 네트워크 오류');
                    return response.json();
                })
                .then(stations => {
                    if (stations && stations.length > 0) {
                        displayStations(stations); // 🌟 [수정 없음]
                    } else {
                        alert("검색된 지역 주변에 충전소가 없습니다.");
                        clearMarkers();
                        stationsListEl.innerHTML = '<p>검색된 충전소가 없습니다.</p>';
                    }
                    stationsListPanel.style.display = 'flex';
                    stationsListPanel.querySelector('h3 span').textContent = '🔎 검색 결과';
                    document.getElementById('detail-panel').style.display = 'none';
                })
                .catch(error => {
                    console.error('반경 검색 중 오류 발생:', error);
                    alert('충전소 데이터를 가져오는 중 오류가 발생했습니다.');
                    stationsListEl.innerHTML = '<p>데이터 로드 중 오류 발생.</p>';
                    stationsListPanel.style.display = 'flex'; 
                    stationsListPanel.querySelector('h3 span').textContent = '🔎 검색 결과';
                });
        }
        
        // 4-8-2. '키워드(LIKE)' 검색 함수 
        function searchByKeyword(keyword) {
            if (availableOnlyToggle) availableOnlyToggle.checked = false; // 💡 필터 초기화

            // 💡 [추가] 선택된 마커 초기화
            if (selectedMarker) {
                selectedMarker.setImage(null);
                selectedMarker = null;
            }

            var url = '/searchByKeyword?keyword=' + encodeURIComponent(keyword); 
            
            fetch(url)
                .then(response => {
                    if (!response.ok) throw new Error('키워드 검색 네트워크 오류');
                    return response.json();
                })
                .then(stations => {
                    if (stations && stations.length > 0) {
                        displayStations(stations); // 🌟 [수정 없음]
                    } else {
                        alert("'" + keyword + "'에 대한 검색 결과가 없습니다.");
                        clearMarkers();
                        stationsListEl.innerHTML = '<p>검색된 충전소가 없습니다.</p>';
                    }
                    stationsListPanel.style.display = 'flex'; 
                    stationsListPanel.querySelector('h3 span').textContent = '🔎 검색 결과';
                    document.getElementById('detail-panel').style.display = 'none';
                })
                .catch(error => {
                    console.error('키워드 검색 중 오류 발생:', error);
                    alert('충전소 데이터를 가져오는 중 오류가 발생했습니다.');
                    clearMarkers();
                    stationsListEl.innerHTML = '<p>데이터 로드 중 오류 발생.</p>';
                    stationsListPanel.style.display = 'flex'; 
                    stationsListPanel.querySelector('h3 span').textContent = '🔎 검색 결과';
                });
        }
        
        // 💡 4-14. '지도 영역' 검색 함수
        function fetchStationsDataByBounds(minLat, maxLat, minLng, maxLng) {
            if (availableOnlyToggle) availableOnlyToggle.checked = false; // 💡 필터 초기화

            // 💡 [추가] 선택된 마커 초기화
            if (selectedMarker) {
                selectedMarker.setImage(null);
                selectedMarker = null;
            }

            var url = "/searchByBounds?minLat=" + encodeURIComponent(minLat) + 
                      "&maxLat=" + encodeURIComponent(maxLat) + 
                      "&minLng=" + encodeURIComponent(minLng) + 
                      "&maxLng=" + encodeURIComponent(maxLng);

            fetch(url)
                .then(response => {
                    if (!response.ok) throw new Error('영역 검색 네트워크 오류');
                    return response.json();
                })
                .then(stations => {
                    if (stations && stations.length > 0) {
                        displayStations(stations); // 🌟 [수정 없음]
                    } else {
                        alert("현재 지도 영역에 충전소가 없습니다.");
                        clearMarkers();
                        stationsListEl.innerHTML = '<p>현재 영역에 충전소가 없습니다.</p>';
                    }
                    stationsListPanel.style.display = 'flex';
                    stationsListPanel.querySelector('h3 span').textContent = '🔎 검색 결과';
                    document.getElementById('detail-panel').style.display = 'none';
                })
                .catch(error => {
                    console.error('영역 검색 중 오류 발생:', error);
                    alert('충전소 데이터를 가져오는 중 오류가 발생했습니다.');
                    clearMarkers();
                    stationsListEl.innerHTML = '<p>데이터 로드 중 오류 발생.</p>';
                    stationsListPanel.style.display = 'flex'; 
                    stationsListPanel.querySelector('h3 span').textContent = '🔎 검색 결과';
                });
        }

        // 4-12. 페이지 로드 시 초기 데이터 로드 (서울시청 기준)
        // var initialCoords = mapOption.center; 
        // fetchStationsDataByRadius(initialCoords.getLat(), initialCoords.getLng());
        
        
        // 💡 4-15. [신규] 지도 Zoom Level 변경 이벤트 리스너 추가 (Custom Overlay 제어)
        kakao.maps.event.addListener(map, 'zoom_changed', function() {
            var level = map.getLevel(); // 현재 지도 레벨을 가져옵니다.

            // Custom Overlay 표시/숨김 기준 (레벨 5 기준)
            var isHiddenByCluster = level >= HIDE_ZOOM_LEVEL; 

            // ⭐⭐ [핵심 추가] 마커와 오버레이를 완전히 숨길 기준 (레벨 9 기준)
            var isHiddenByMaxZoom = level >= HIDE_ALL_MARKERS_ZOOM_LEVEL; 

            var isSelected = selectedMarker !== null;

            // 1. 마커 숨김 처리
            // 마커가 선택된 상태에서 클러스터링을 강제로 중단하며, 레벨 9 이상이면 마커를 완전히 숨깁니다.
            if (isSelected) {
                 if (isHiddenByMaxZoom) {
                    for (var i = 0; i < markers.length; i++) {
                        markers[i].setMap(null); 
                    }
                } else {
                    // 마커가 선택된 상태 (클러스터링 중단 상태)에서는 모든 마커를 표시합니다.
                    for (var i = 0; i < markers.length; i++) {
                        markers[i].setMap(map); 
                    }
                }
            }
            
            // 2. Custom Overlay 표시/숨김 처리
            for (var i = 0; i < customOverlays.length; i++) {
                if (customOverlays[i]) {
                    if (isHiddenByMaxZoom) {
                         customOverlays[i].setMap(null);
                    } else if (isSelected) {
                         // 마커가 선택된 상태일 때는 Custom Overlay를 계속 띄웁니다.
                         customOverlays[i].setMap(map); 
                    } else if (isHiddenByCluster) {
                         // 마커 선택 안됨 && 레벨 5 이상이면 기본적으로 숨김 (클러스터가 뜸)
                         customOverlays[i].setMap(null); 
                    } else {
                         // 마커 선택 안됨 && 레벨 5 미만이면 표시
                         customOverlays[i].setMap(map);
                    }
                }
            }
        });
        
    }; // window.onload 함수 끝
	function alignStatusPanel() {
	        var panel = document.getElementById('detail-panel');
	        var statusPanel = document.getElementById('status-detail-panel');
	        
	        // 패널들이 존재하고, 상세 패널이 보이는 상태일 때만 계산
	        if (panel && statusPanel && panel.style.display !== 'none') {
	            var rect = panel.getBoundingClientRect(); // 상세 패널의 현재 위치값 가져오기
	            var newLeft = rect.right + 10; // 오른쪽 끝 + 10px 간격
	            
	            statusPanel.style.left = newLeft + 'px';
	        } else if (statusPanel) {
	            // 상세 패널이 닫히면 상태 패널도 같이 숨김
	            statusPanel.style.display = 'none';
	        }
	    }

	    // 🌟 [추가] 시간대별 혼잡도 예측 로드 함수
	    function loadCongestionPrediction(statId) {
	        var predictionSection = document.getElementById('congestion-prediction-section');
	        var chartContainer = document.getElementById('hour-chart-container');
	        
	        if (!predictionSection || !chartContainer) return;
	        
	        // 섹션 표시
	        predictionSection.style.display = 'block';
	        chartContainer.innerHTML = '<div style="text-align: center; padding: 20px; color: #999;">데이터 로딩 중...</div>';
	        
	        // API 호출 (충전기 타입 무관, 전체 혼잡도)
	        var url = '${pageContext.request.contextPath}/station/congestion/predict';
	        
	        fetch(url)
	            .then(function(res) { return res.json(); })
	            .then(function(data) {
	                if (data.success && data.probabilities) {
	                    renderHourChart(data.probabilities, data.currentHour, data.currentProbability);
	                } else {
	                    // 데이터가 부족해도 기본값(50%)으로 표시
	                    var defaultProbs = {};
	                    var currentHour = new Date().getHours();
	                    for (var h = 0; h < 24; h++) {
	                        defaultProbs[h] = 0.5; // 기본값 50%
	                    }
	                    renderHourChart(defaultProbs, currentHour, 0.5);
	                    chartContainer.insertAdjacentHTML('afterbegin', '<div style="text-align: center; padding: 8px; margin-bottom: 12px; background: #fff3cd; border-radius: 6px; font-size: 12px; color: #856404;">⚠️ 데이터가 부족하여 기본값으로 표시됩니다. 데이터가 쌓이면 정확도가 향상됩니다.</div>');
	                }
	            })
	            .catch(function(error) {
	                console.error('혼잡도 예측 로드 실패:', error);
	                chartContainer.innerHTML = '<div style="text-align: center; padding: 20px; color: #ff4d4f;">데이터를 불러올 수 없습니다.</div>';
	            });
	    }
	    
	    // 시간대별 차트 렌더링
	    function renderHourChart(probabilities, currentHour, currentProbability) {
	        var chartContainer = document.getElementById('hour-chart-container');
	        if (!chartContainer) return;
	        
	        var html = '';
	        
	        for (var hour = 0; hour < 24; hour++) {
	            var prob = probabilities[hour] || 0;
	            var probPercent = Math.round(prob * 100);
	            
	            // 확률에 따른 클래스 및 색상
	            var probClass = 'prob-low';
	            var statusText = '여유';
	            
	            if (probPercent >= 61) {
	                probClass = 'prob-high';
	                statusText = '혼잡';
	            } else if (probPercent >= 31) {
	                probClass = 'prob-medium';
	                statusText = '보통';
	            }
	            
	            // 현재 시간대 강조
	            var isCurrent = (hour === currentHour);
	            var currentClass = isCurrent ? ' current' : '';
	            
	            html += '<div class="hour-item' + currentClass + '" title="' + hour + '시: ' + probPercent + '% 확률로 혼잡">';
	            html += '<div class="hour-label">' + hour + '시</div>';
	            html += '<div class="hour-probability ' + probClass + '">' + probPercent + '%</div>';
	            html += '<div class="hour-status">' + statusText + '</div>';
	            html += '</div>';
	        }
	        
	        chartContainer.innerHTML = html;
	        
	        // 현재 시간대 확률 정보 표시
	        if (currentProbability !== undefined) {
	            var currentProbPercent = Math.round(currentProbability * 100);
	            var infoText = '현재 시간대(' + currentHour + '시) 혼잡 확률: <strong>' + currentProbPercent + '%</strong>';
	            chartContainer.insertAdjacentHTML('afterbegin', '<div style="text-align: center; padding: 8px; margin-bottom: 12px; background: #fff; border-radius: 6px; font-size: 13px; color: #333;">' + infoText + '</div>');
	        }
	    }


        // --- [추가] 주변 편의시설 검색 기능 ---

var nearbyMarkers = []; // 편의시설 마커들을 담을 배열 (나중에 지우기 위해)

// 1. 주변 편의시설 검색 함수
function searchNearby(categoryCode) {
    var lat = document.getElementById('current-lat').value;
    var lng = document.getElementById('current-lng').value;

    if (!lat || !lng) {
        alert("충전소를 먼저 선택해주세요.");
        return;
    }

    // --- 🌟 [핵심 변경 1] 다른 충전소 숨기기 로직 (클러스터러 제어) ---
    
    // 1) 기존에 떠있던 편의시설 마커 지우기
    clearNearbyMarkers(false); // false: 충전소 복구는 하지 않고, 편의시설만 지움

    // 2) 클러스터러를 비워서 모든 충전소 마커를 지도에서 제거
    if (markerClusterer) {
        markerClusterer.clear(); 
    }
    
    // 3) Custom Overlay 모두 숨김
    for (var i = 0; i < customOverlays.length; i++) {
        customOverlays[i].setMap(null); 
    }


    // 4) 내가 선택한(클릭한) 충전소 마커만 다시 지도에 표시
    if (selectedMarker) {
        selectedMarker.setMap(map); 
    }
    // ------------------------------------------------

    var ps = new kakao.maps.services.Places(map);

    ps.categorySearch(categoryCode, placesSearchCB, {
        location: new kakao.maps.LatLng(lat, lng),
        radius: 500
    });
}

// 검색 결과 콜백 함수
function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {
        // 검색된 장소들을 마커로 표시
        for (var i = 0; i < data.length; i++) {
            displayNearbyMarker(data[i]);
        }
        alert(data.length + "개의 장소를 찾았습니다! 지도에 표시된 작은 마커를 확인하세요.");
    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
        alert('주변 500m 반경에 해당 시설이 없습니다.');
    } else {
        alert('검색 중 오류가 발생했습니다.');
    }
}

// 편의시설 마커 표시 함수
function displayNearbyMarker(place) {
    // 편의시설은 기본 마커(또는 다른 이미지)로 표시해서 충전소와 구분
    var marker = new kakao.maps.Marker({
        map: map,
        position: new kakao.maps.LatLng(place.y, place.x),
        title: place.place_name // 마우스를 올리면 이름이 뜸
    });

    // 마커 클릭 시 카카오맵 상세보기로 이동 (선택사항)
    kakao.maps.event.addListener(marker, 'click', function() {
        window.open(place.place_url, '_blank');
    });

    nearbyMarkers.push(marker);
}

// 2. 마커 정리 및 복구 함수
// restoreStations가 true(기본값)이면 충전소 마커들을 다시 보여줍니다.
function clearNearbyMarkers(restoreStations = true) {
    // 편의시설 마커 삭제
    for (var i = 0; i < nearbyMarkers.length; i++) {
        nearbyMarkers[i].setMap(null);
    }
    nearbyMarkers = [];

    // --- 🌟 [핵심 변경 2] 충전소 마커 복구 로직 ---
    if (restoreStations) {
        // 1. 숨겼던 충전소 마커들을 다시 클러스터러에 담아서 지도에 표시 (클러스터링 재개)
        if (markerClusterer && markers.length > 0) {
            markerClusterer.addMarkers(markers);
        }
        
        // 2. 선택된 충전소 마커는 지도에서 제거 (클러스터러가 관리하도록)
        if (selectedMarker) {
             selectedMarker.setMap(null);
             selectedMarker.setImage(null);
             selectedMarker = null;
        }

        // 3. Custom Overlay 복구 (줌 레벨에 따라 표시/숨김)
        var level = map.getLevel();
        var showOverlays = level < HIDE_ZOOM_LEVEL;
        for (var i = 0; i < customOverlays.length; i++) {
            if (customOverlays[i]) customOverlays[i].setMap(showOverlays ? map : null);
        }
    }
}
    
    </script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>