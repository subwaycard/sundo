<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>지도</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<!-- Spin.js -->
<script
   src="https://cdnjs.cloudflare.com/ajax/libs/spin.js/2.3.2/spin.js"></script>

<!-- main.css 파일을 포함합니다. -->
    <<link rel="stylesheet" type="text/css" href="css/main.css">

<!-- OpenLayers 자바스크립트 및 CSS-->
<script src="https://cdn.jsdelivr.net/npm/ol@v9.0.0/dist/ol.js"></script>
<link rel="stylesheet"
   href="https://cdn.jsdelivr.net/npm/ol@v9.0.0/ol.css">

<!-- jQuery-->
<script
   src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"
   integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g=="
   crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<!-- Popper.js-->
<script
   src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"
   integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r"
   crossorigin="anonymous"></script>

   <!-- Google Charts Loader -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<script type="text/javascript">
google.charts.load("current", {packages:['bar']});

function drawChart(result) {
    
    $('#bardiv').show();
    
    let rows =[];
    
    result.forEach(function(i){
       let arr = new Array();
       arr.push(i.sgg_nm);
       arr.push(i.amount);
       rows.push(arr);
    })
    
    var data = new google.visualization.DataTable();
    data.addColumn('string');
      data.addColumn('number', '전기');
      data.addRows(rows);

    var options = {
       legend: {
            position: 'none'
          },
      bars: 'horizontal', 
    };

    var chart = new google.charts.Bar(document.getElementById('bar'));

    chart.draw(data, options);
 } 
   
$(function() {

    $("#uploaddiv").hide();
    $("#chartdiv").hide();
    
    $("#tanso").on("click",function(){
       $("#uploaddiv").hide();
       $("#chartdiv").hide();

       let upload = document.querySelector('#data');
       let chart = document.querySelector('#statics');
       let select = document.querySelector('#tanso');
       
        upload.classList.remove('active');
        chart.classList.remove('active');
        select.classList.add('active');

       $("#selectdiv").show();
    })
    
    $("#data").on("click",function(){
    	// 다른 요소들을 숨깁니다.
       $("#selectdiv").hide();
       $("#chartdiv").hide();
       
       let upload = document.querySelector('#data');
       let chart = document.querySelector('#statics');
       let select = document.querySelector('#tanso');
       
       select.classList.remove('active');
        chart.classList.remove('active');
        upload.classList.add('active');
       
       $("#uploaddiv").show();
    })
    
    $("#statics").on("click",function(){
       $("#selectdiv").hide();
       $("#uploaddiv").hide();
       
       let upload = document.querySelector('#data');
       let chart = document.querySelector('#statics');
       let select = document.querySelector('#tanso');
       
        upload.classList.remove('active');
        select.classList.remove('active');
        
        chart.classList.add('active');
       
       $("#chartdiv").show();
    })
    
      var sd, sgg, bjd,legendDiv;
    
    let Base = new ol.layer.Tile(
          {
             name : "Base",
             source : new ol.source.XYZ(
                   {
                      url : 'https://api.vworld.kr/req/wmts/1.0.0/665E97C4-73AA-3EF8-9944-02196CA05F79/Base/{z}/{y}/{x}.png'
                   })
          }); // WMTS API 사용

    let olview = new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
       center : ol.proj.transform([ 126.970371, 37.554376 ], 'EPSG:4326',
             'EPSG:3857'),
       zoom : 15
    });

    let map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
       target : 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
       layers : [ Base ],// 지도에서 사용 할 레이어의 목록을 정의하는 공간이다
       view : olview
    });

            //시도 확대
            $("#sdselect").on("change", function() {

                var test = $("#sdselect option:checked").text();
                $.ajax({
                    url: "/selectSgg.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        "test": test
                    },
                    success: function(result) {
                    	
                        var list = result.list;
                        var geom = result.geom;
                        $("#sgg").empty();
                        var sgg = "<option>시군구 선택</option>";
                        for (var i = 0; i < list.length; i++) {
                            sgg += "<option value='" + list[i].sgg_cd + "'>" +
                                list[i].sgg_nm + "</option>"
                        }

                        $("#sgg").append(sgg);

                        //  지도확대
                        map.getView().fit([geom[0].xmin, geom[0].ymin, geom[0].xmax, geom[0].ymax], {
                            duration: 900
                        });

                        map.removeLayer(sd);
                        //시도 레이어
                        var sd_CQL1 = "sd_cd=" + $("#sdselect").val();

                        var sdSource = new ol.source.TileWMS({
                            url: 'http://wisejia.iptime.org:8080/geoserver/suk/wms?service=WMS', // 1. 레이어 URL
                            params: {
                                'VERSION': '1.1.0', // 2. 버전
                                'LAYERS': 'suk:tl_sd', // 3. 작업공간:레이어 명
                                'CQL_FILTER': sd_CQL1,
                                'BBOX': [1.3867446E7, 3906626.5, 1.4684055E7, 4670269.5],
                                'SRS': 'EPSG:3857', // SRID
                                'FORMAT': 'image/png', // 포맷
                                'TRANSPARENT': 'TRUE',
                            },
                            serverType: 'geoserver',
                        });

                        sd = new ol.layer.Tile({
                            source: sdSource,
                            opacity: 0.2
                        });

                        map.addLayer(sd);
                        $("#legendSelect").val("default");
        	            legendSelected = false;
                    },
                    error: function() {
                        alert("실패");
                    }
                })
            });

            //시군구 확대
            $("#sgg").on("change", function() {
               var sggdata = $("#sgg option:checked").text();

                $.ajax({
                    url: "/selectB.do",
                    type: "post",
                    dataType: "json",
                    data: { "sggdata": sggdata },
                    success: function(result) {
                        var bList = result.list;
                        
                        //result값을 json으로 parse시키고 bbox를 가져옴
                        map.getView().fit([result.xmin, result.ymin, result.xmax, result.ymax], {
                            duation: 900 });

                        //시군구 레이어
                        var sgg_CQL = "adm_sect_c=" + $("#sgg").val();
                        map.removeLayer(sgg);
                        var sggSource = new ol.source.TileWMS({

                                url: 'http://wisejia.iptime.org:8080/geoserver/suk/wms?service=WMS', // 1. 레이어 URL
                                params: {
                                    'VERSION': '1.1.0', // 2. 버전
                                    'LAYERS': 'suk:tl_sgg', // 3. 작업공간:레이어 명
                                    'CQL_FILTER': sgg_CQL,
                                    'BBOX': [1.386872E7, 3906626.5, 1.4428071E7, 4670269.5],
                                    'SRS': 'EPSG:3857', // SRID
                                    'FORMAT': 'image/png', // 포맷
                                    'TRANSPARENT' : 'TRUE',
                                    'FILLCOLOR': '#5858FA'
                                },
                                serverType: 'geoserver',
                            });
                            
                            sgg = new ol.layer.Tile({
                                source : sggSource,
                                opacity : 0.5
                        });
                        map.addLayer(sgg);
                        $("#legendSelect").val("default");
                        legendSelected = false;
                    },
                    error : function() {
                       alert("실패");
                    }
                 });
              });

            //입력하기 , 범례 
            $("#insertbtn").click(function() {
                let selectedSd = $("#sdselect").val();
                let selectedSgg = $("#sgg").val();
                let legend = $("#legendSelect").val();

                if (selectedSd === "시도 선택" || selectedSgg === "시군구 선택") {
                    alert("시도와 시군구를 선택해주세요.");
                    return;
                }


                map.removeLayer(sd);
                map.removeLayer(sgg);
                map.removeLayer(bjd);

                let style = (legend === "1") ? 'bjdeq' : 'bjdna';
                // 변경된 스타일 이름으로 수정
                alert((legend === "1") ? "등간격 스타일을 적용합니다." : "네추럴 브레이크 스타일을 적용합니다.");
                $.ajax({
                    url: "/legend.do",
                    type: 'POST',
                    dataType: "json",
                    data: {
                        "legend": style
                    },
                    success: function(result) {


                        //console.log("legend값:", result.legend);
                        var bjd_CQL = "sgg_cd=" + $("#sgg").val();
                        var bjdSource = new ol.source.TileWMS({
                            url: 'http://wisejia.iptime.org:8080/geoserver/suk/wms?service=WMS',
                            params: {
                                'VERSION': '1.1.0',
                                'LAYERS': 'suk:d5bjdview',
                                'CQL_FILTER': bjd_CQL,
                                'BBOX': [1.4066749E7, 3926728.0, 1.4411295E7, 4612208.0],
                                'SRS': 'EPSG:3857',
                                'FORMAT': 'image/png',
                                'TRANSPARENT': 'TRUE',
                                'STYLES': style, // 변경된 스타일 적용
                            },
                            serverType: 'geoserver'
                        });
                        bjd = new ol.layer.Tile({
                            properties: {
                                name: 'legend'
                            },
                            source: bjdSource,
                            opacity: 0.5
                        });

                        map.addLayer(bjd);

                        let legendInfo = result.legend;
                        
                        $("#legend").remove();
        	            
                        legendDiv = document.createElement("div");
        	            
        	            legendDiv.setAttribute("style","text-align:center;position: absolute;background-color:white;z-index:10;position:absolute;right:10px;bottom:10px");
        	            legendDiv.setAttribute("id","legend");
        	            
        	            $("#map").append(legendDiv);
        	            
        	            let legendTable = document.createElement("table");
        	            legendTable.setAttribute("id","legendTable");
        	            
        	            legendDiv.appendChild(legendTable);

        	            let legendHeadTr = document.createElement("tr");
        	            let legendHead = document.createElement("td");
        	            let legendBody = document.createElement("tbody");
        	            
        	            legendTable.appendChild(legendHeadTr);
        	            legendHeadTr.appendChild(legendHead);
        	            
        	            legendHead.setAttribute("colspan","2");
        	            legendHead.setAttribute("style","font-size:24px;font-weight: bold;");
        	            legendHead.innerText="범 례";
        	            
        	            legendTable.appendChild(legendBody);
        	            
        	            // 범례 정보를 테이블에 추가
        	            for(let i = 0; i < legendInfo.length; i++) {
        	                let legendTr = document.createElement("tr");
        	                let legendTd1 = document.createElement("td");
        	                let legendTd2 = document.createElement("td");
        	                
        	                legendTd1.innerHTML="<img style='background-size:100%' src='/resource/img/"+i+".png'>"
        	                legendTd2.innerText= legendInfo[i].from_val +" ~ "+legendInfo[i].to_val;
        	                
        	                legendTr.appendChild(legendTd1);
        	                legendTr.appendChild(legendTd2);
        	                legendBody.appendChild(legendTr);
        	            } 

                    },
                    error: function() {
                        alert("실패");
                    }
                });
            });
            
            $("body").on("click",function(){
                $("#bardiv").hide();
                $(".container").next().remove();
             })


            //파일 업로드
            $("#transdb").on("click", function() {
                var test = $("#txtfile").val().split(".").pop();

                var formData = new FormData();
                formData.append("testfile", $("#txtfile")[0].files[0]);

                if ($.inArray(test, ['txt']) == -1) {
                    alert("pem 파일만 업로드 할 수 있습니다.");
                    $("#txtfile").val("");
                    return false;
                }
             
                //파일 업로드
                $.ajax({
                    url: "/fileUpload.do",
                    type: 'post',
                    enctype: 'multipart/form-data',
                    //contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    data: formData,
                    contentType: false,
                    processData: false,
                    beforeSend: function() {
                        modal();
                    },
                    success: function() {
                        $('#uploadtext').text("업로드 완료");
                        setTimeout(timeout, 5000);

                         // 파일 업로드가 성공했을 때 폼을 초기화
                        $('#uploadForm')[0].reset();
                    },
                    error: function(xhr, status, error) {
                        $('#uploadtext').text("업로드 실패");
                        setTimeout(timeout, 5000);

                        // 파일 업로드가 실패했을 때 폼을 초기화
                        $('#uploadForm')[0].reset();
 

                    }
                });

            });
            $("#charttbtn").on("click",function(){

                var sdChartcd = $("#sdChartSelect option:checked").val();
                alert(sdChartcd);
                $.ajax({
                   url:'/chart.do',
                   type:'post',
                   data:{'sdcd':sdChartcd},
                   dataType:'json',
                   success:function(result){
                      drawChart(result);
                      alert(result);
                      console.log(result);
                   },
                   error:function(){
                      alert("실패");
                   }
                });
                
             });            

          });

        var timeout = function() {
            $('#mask').remove();
            $('#loading').remove();

        }

        function modal() {
            var maskHeight = $(document).height();
            var maskWidth = window.document.body.clientWidth;

            var mask = "<div id='mask' style='position:absolute;z-indx:5;background-color: rgba(0, 0, 0, 0.13);display:none;left:0;top:0;'></div>";
            var loading = "<div id='loading' style='background-color:white;width:500px'><h1 id='uploadtext' style='text-align:center'>업로드 진행중</h1></div>";
            $('body').append(mask);
            $('#mask').append(loading);

            $("#mask").css({
                'height': maskHeight,
                'width': maskWidth
            });

            $('#loading').css({
                /* 'position': 'absolute',
                 'top': '50%',
                  'left': '50%',
                  'transform': 'translate(-50%, -50%)' */
                'position': 'absolute',
                'left': '800px',
                'top': '100px'

            })
            $('#mask').show();
            $('#loading').show();
        }
    </script>



</head>
<body>
    <div class="container">
        <div class="main">
            <div class="btncon">
                <div class="footer">
                    <h3>탄소공간지도 시스템</h3>
                </div>
                <div class="menu">
                    <div class="menubar list-group">
                        <button id="tanso" class="list-group-item list-group-item-action active">탄소지도</button>
                        <button id="data" class="list-group-item list-group-item-action">데이터삽입</button>
                        <button id="statics" class="list-group-item list-group-item-action">통계</button>
                    </div>

                    <div class="func">
                        <div id="selectdiv">
                            <select id="sdselect">

                                <option>시도 선택</option>
                                <c:forEach items="${sdlist}" var="sd">
                                    <option class="sd" value="${sd.sd_cd}">${sd.sd_nm}</option>
                                </c:forEach>
                            </select>

                            <select id="sgg">
                                <option>시군구 선택</option>
                            </select>
                            <select id="legendSelect">
                                <option>범례 선택</option>
                                <option value="1">등간격</option>
                                <option value="2">Natural Break</option>
                            </select>

                            <button id="insertbtn" class="insertbtn">입력하기</button>

                        </div>
                        <div id="uploaddiv">

                            <form id="uploadForm">
                                <div class="input-group mb-3">
                                    <input class="form-control" type="file" accept=".txt" id="txtfile" name="txtfile">
                                </div>
                            </form>
                            <button id="transdb">전송하기</button>
                        </div>
                        <div id="chartdiv">
                            <select id="sdChartSelect">
                                <option class="sd" value="0">시도 전체</option>
                                <c:forEach items="${sdlist }" var="sd">
                                    <option class="sd" value="${sd.sd_cd }">${sd.sd_nm}</option>
                                </c:forEach>
                            </select>

                            <button id="charttbtn">검색</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="map" id="map">
                <div id="bardiv" style="z-index:100;position: absolute;top: 50%;left: 50%;transform: translate(-50%, -50%);background-color:rgba(253, 255, 255, 0.5);width:97%;height:97%;display:none;">
                    <div id="bar" style="width: 80%; height: 50%;opacity:none;margin: 0 auto; padding-top:10px"></div>

                </div>
            </div>

        </div>
    </div>
</body>
</html>