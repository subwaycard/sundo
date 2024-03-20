<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>지도</title>
<script
   src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"
   integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g=="
   crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<!-- <script type="text/javascript" src="resource/js/ol.js"></script> OpenLayer 라이브러리
<link href="resource/css/ol.css" rel="stylesheet" type="text/css" > OpenLayer css -->
<script src="https://cdn.jsdelivr.net/npm/ol@v9.0.0/dist/ol.js"></script>
<link rel="stylesheet"
   href="https://cdn.jsdelivr.net/npm/ol@v9.0.0/ol.css">
<script type="text/javascript">
   $(function() {

      var sd,sgg,bjd;
      
      let Base = new ol.layer.Tile(
            {
               name : "Base",
               source : new ol.source.XYZ(
                     {
                        url : 'https://api.vworld.kr/req/wmts/1.0.0/CD549E65-D552-348C-B017-44A5DC89EDF6/Base/{z}/{y}/{x}.png'
                     })
            }); // WMTS API 사용

      let olview = new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
         center : ol.proj.transform([ 126.970371, 37.554376 ], 'EPSG:4326',
               'EPSG:3857'),
         zoom : 15
      });

      let map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
         target : 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
         layers : [ Base ],// 지도에서 사용 할 레이어의 목록을 정희하는 공간이다
         view : olview
      });

      $("#sdselect").on("change", function() {
         
         
         var test = $("#sdselect option:checked").text();
         $.ajax({
            url : "/selectSgg.do",
            type : "post",
            dataType : "json",
            data : {"test" : test},
            success : function(result) {
               $("#sgg").empty();
               var sgg = "<option>시군구 선택</option>";
               
               for(var i=0;i<result.length;i++){
                  sgg += "<option value='"+result[i].sgg_cd+"'>"+result[i].sgg_nm+"</option>"
               }
               
               $("#sgg").append(sgg);
            },
            error : function() {
               alert("실패");
            }
         })
      });

      $(".insertbtn").click(function() {

         map.removeLayer(sd);
         map.removeLayer(sgg);
         map.removeLayer(bjd);
         
         var sd_CQL = "sd_cd="+$("#sdselect").val();
         var sgg_CQL = "sgg_cd="+$("#sgg").val();
         
         var sdSource = new ol.source.TileWMS({
            url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
            params : {
               'VERSION' : '1.1.0', // 2. 버전
               'LAYERS' : 'cite', // 3. 작업공간:레이어 명
               'CQL_FILTER' : sd_CQL,
               'BBOX' : [ 1.3871489341071218E7,3910407.083927817,1.4680011171788167E7,4666488.829376997&width=768 ],
               'SRS' : 'EPSG:3857', // SRID
               'FORMAT' : 'image/png', // 포맷
               'TRANSPARENT' : 'TRUE',

            },
            serverType : 'geoserver',
         });

         sd = new ol.layer.Tile({
            source : sdSource,
            opacity : 0.5
         });

         //for(var i in sd) sd[i].setStyle(style);

         //map.addLayer(sd); // 맵 객체에 레이어를 추가함

         sgg = new ol.layer.Tile({
            source : new ol.source.TileWMS({
               url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
               params : {
                  'VERSION' : '1.1.0', // 2. 버전
                  'LAYERS' : 'cite', // 3. 작업공간:레이어 명
                  'CQL_FILTER' : sgg_CQL,
                  'BBOX' : [1.3871489341071218E7,3910407.083927817,1.4680011171788167E7,4666488.829376997 ],
                  'SRS' : 'EPSG:3857', // SRID
                  'FORMAT' : 'image/png', // 포맷
                  'FILLCOLOR' : '#5858FA'
               },
               serverType : 'geoserver',
            })
         });

         //map.addLayer(sgg); // 맵 객체에 레이어를 추가함
         
         

         bjd = new ol.layer.Tile(
               {
                  source : new ol.source.TileWMS(
                        {
                           url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
                           params : {
                              'VERSION' : '1.1.0', // 2. 버전
                              'LAYERS' : 'cite', // 3. 작업공간:레이어 명
                              'CQL_FILTER' : sgg_CQL,
                              'BBOX' : [ 1.386872E7,3906626.5,1.4428071E7,4670269.5 ],
                              'SRS' : 'EPSG:3857', // SRID
                              'FORMAT' : 'image/png', // 포맷
                              'FILLCOLOR' : '#5858FA'
                           },
                           serverType : 'geoserver',
                        }),
                  opacity : 0.8
               });

         //map.addLayer(bjd); // 맵 객체에 레이어를 추가함
         
         
         map.addLayer(sd);
         map.addLayer(sgg);
         map.addLayer(bjd);
      });

   })
</script>

<style type="text/css">
.map {
   height: 1060px;
   width: 100%;
}
</style>
</head>
<body>
   <div class="container">
      <div class="main">
         <div class="btncon">
            <select id="sdselect">
               <option>시도 선택</option>
               <c:forEach items="${sdlist }" var="sd">
                  <option class="sd" value="${sd.sd_cd }">${sd.sd_nm}</option>
               </c:forEach>
            </select> 
            
            <select id="sgg">
               <option>시군구 선택</option>
            </select> 
            
            <select>
               <option selected="selected">범례 선택</option>
            </select>

            <button class="insertbtn">입력하기</button>
         </div>
         <div class="map" id="map"></div>
      </div>
   </div>
</body>
</html>
