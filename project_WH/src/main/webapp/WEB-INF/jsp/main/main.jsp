<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>브이월드 오픈API</title>
<script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
<script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v6.15.1/ol.css">
<!-- 제이쿼리 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>2DMap</title>
<script type="text/javascript">
$( document ).ready(function() {
   let map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
       target: 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
       layers: [ // 지도에서 사용 할 레이어의 목록을 정희하는 공간이다.
         new ol.layer.Tile({
           source: new ol.source.OSM({
             url: 'https://api.vworld.kr/req/wmts/1.0.0/CD549E65-D552-348C-B017-44A5DC89EDF6/Base/{z}/{y}/{x}.png' // vworld의 지도를 가져온다.
           })
         })
       ],
       view: new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
         center: ol.proj.fromLonLat([128.4, 35.7]),
         zoom: 7
       })
   });

	var wms = new ol.layer.Tile({
		   source : new ol.source.TileWMS({
		      target: 'wms',
		      url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
		      params : {
		         'VERSION' : '1.1.0', // 2. 버전
		         'LAYERS' : 'suk', // 3. 작업공간:레이어 명
		         'BBOX' : [1.386872E7,3906626.5,1.4680011171788167E7,4670269.5], 
		         'SRS' : 'EPSG:3857', // SRID
		         'FORMAT' : 'image/png' // 포맷
		      },
		      serverType : 'geoserver',
		   })
		});

		map.addLayer(wms); // 맵 객체에 레이어를 추가함
		});

</script>


<style type="text/css">
.map{
height: 1060px;
width: 100%
}
</style>
</head>

<body>
   <div id="map" class="map">
   </div>
   


</body>
</html>