<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <title>지도</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

    <!-- <script type="text/javascript" src="resource/js/ol.js"></script> OpenLayer 라이브러리
<link href="resource/css/ol.css" rel="stylesheet" type="text/css" > OpenLayer css -->
    <script src="https://cdn.jsdelivr.net/npm/ol@v9.0.0/dist/ol.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v9.0.0/ol.css">
    <script type="text/javascript">
        $(document).ready(function() {

            var sd, sgg, bjd;

            let Base = new ol.layer.Tile({
                name: "Base",
                source: new ol.source.XYZ({
                    url: 'https://api.vworld.kr/req/wmts/1.0.0/CD549E65-D552-348C-B017-44A5DC89EDF6/Base/{z}/{y}/{x}.png'
                })
            }); // WMTS API 사용

            let olview = new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
                center: ol.proj.transform([126.970371, 37.554376], 'EPSG:4326', 'EPSG:3857'),
                zoom: 15
            });

            let map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
                target: 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
                layers: [Base], // 지도에서 사용 할 레이어의 목록을 정의하는 공간이다
                view: olview
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
                        //alert(list);
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
                            duration: 800
                        });

                        //시도 레이어
                        map.removeLayer(sd);
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
                            opacity: 0.5
                        });

                        map.addLayer(sd);
                    },
                    error: function() {
                        alert("실패");
                    }
                })
            });


            //시군구 확대
            $("#sgg").on("change", function() {
                var sggdata = $("#sgg option:checked").text();
                console.log(sggdata);
                // alert(sggValue);
                $.ajax({
                    url: "/selectB.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        "sggdata": sggdata
                    },
                    success: function(result) {

                        var bList = result.list;
                        //result값을 json으로 parse시키고 bbox를 가져옴
                        map.getView().fit([result.xmin, result.ymin, result.xmax, result.ymax], {
                            duation: 900
                        });

                        /*  var geom = result.geom;
                         map.getView().fit([geom[0].xmin, geom[0].ymin, geom[0].xmax, geom[0].ymax],{
                             duration:900
                         }); */

                        //시군구 레이어
                        var sgg_CQL = "sgg_cd=" + $("#sgg").val();

                        var sgg1Source = new ol.source.TileWMS({
                            url: 'http://wisejia.iptime.org:8080/geoserver/suk/wms?service=WMS', // 1. 레이어 URL
                            params: {
                                'VERSION': '1.1.0', // 2. 버전
                                'LAYERS': 'suk:tl_sgg', // 3. 작업공간:레이어 명
                                'CQL_FILTER': sgg_CQL,
                                'BBOX': [1.386872E7, 3906626.5, 1.4428071E7, 4670269.5],
                                'SRS': 'EPSG:3857', // SRID
                                'FORMAT': 'image/png', // 포맷
                                'TRANSPARENT': 'TRUE',
                                //'FILLCOLOR' : '#5858FA'
                            },
                            serverType: 'geoserver',
                        });
                        sgg = new ol.layer.Tile({
                            source: sgg1Source,
                            opacity: 0.5
                        });
                        map.addLayer(sgg);
                    },
                    error: function() {
                        alert("실패");
                    }
                });
            });


            //입력하기 , 범례 
            $("#insertbtn").click(function() {

                var legend = $("#legendSelect").val();
                map.removeLayer(sd);
                map.removeLayer(sgg);
                map.removeLayer(bjd);

                var style = (legend === "1") ? 'bjdeq' : 'bjdna';

                alert((legend === "1") ? "등간격 스타일을 적용합니다." : "네추럴 브레이크 스타일을 적용합니다.");
                $.ajax({
                    url: "/legend.do",
                    type: 'POST',
                    dataType: "json",
                    data: {
                        "legend": legend
                    },
                    success: function(result) {
                        var bjd_CQL = "sgg_cd=" + $("#sgg").val();
                        var bjdSource = new ol.source.TileWMS({
                            url: 'http://wisejia.iptime.org:8080/geoserver/suk/wms?service=WMS',
                            params: {
                                'VERSION': '1.1.0',
                                'LAYERS': 'suk:d5bjdview',
                                'CQL_FILTER': bjd_CQL,
                                'BBOX': [1.4066749E7,3926728.0,1.4411295E7,4612208.0],
                                'SRS': 'EPSG:3857',
                                'FORMAT': 'image/png',
                                'TRANSPARENT': 'TRUE',
                                'STYLES': style,
                            },
                            serverType: 'geoserver',
                        });
                        bjd = new ol.layer.Tile({
                            source: bjdSource,
                            opacity: 0.5
                        });
                        map.addLayer(bjd);
                    },
                    error: function() {
                        alert("실패");
                    }
                });
            });


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
                console.log(formData); // FormData 객체 확인



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

    <style type="text/css">
        .map {
            height: 830px;
            width: 100%;
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="main">
            <div class="btncon">
                <select id="sdselect" name="select">

                    <option>시도 선택</option>
                    <c:forEach items="${sdlist }" var="sd">
                        <option class="sd" value="${sd.sd_cd }">${sd.sd_nm}</option>
                    </c:forEach>
                </select>

                <select id="sgg">
                    <option>시군구 선택</option>
                    <c:forEach items="${list }" var="sgg">
                        <option class="sgg" value="${sgg.sgg_cd }">${sgg.sgg_nm}</option>
                    </c:forEach>

                </select>

                <select id="legendSelect">
                    <option value="default">범례 선택</option>
                    <option value="1">등간격</option>
                    <option value="2">네추럴 브레이크</option>
                </select>

                <button id="insertbtn" class="insertbtn">입력하기</button>


                <form id="uploadForm">
                    <input type="file" accept=".txt" id="txtfile" name="txtfile">
                </form>
                <button id="transdb">전송하기</button>


            </div>
            <div class="map" id="map"></div>
        </div>
    </div>
</body>

</html>