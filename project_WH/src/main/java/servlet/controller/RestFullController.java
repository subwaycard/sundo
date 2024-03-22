package servlet.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import servlet.DTO.SggDTO;
import servlet.service.TlService;

@RestController
public class RestFullController {
   
    @Resource(name="TlService")
    private TlService tlService;
    
    @PostMapping("/selectSgg.do")
    public List<SggDTO> selectSgg(@RequestParam("test") String name){
        List<SggDTO> list=tlService.selectSgg(name);
        System.out.println(list);      
        return list;
        }
    
    @PostMapping("/fileUpload.do")
    public void fileUpload(@RequestParam("testfile") MultipartFile multi) throws IOException {
       
       System.out.println(multi.getOriginalFilename());
       System.out.println(multi.getName());
       System.out.println(multi.getContentType());
       System.out.println(multi.getSize());
       
       List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
       
       
       InputStreamReader isr = new InputStreamReader(multi.getInputStream());
       BufferedReader br = new BufferedReader(isr);
       
       String line=null;
       while((line = br.readLine()) != null) {
          Map<String, Object> m = new HashMap<String, Object>();
          String[] lineArr = line.split("\\|");
          
          System.out.println(Arrays.toString(lineArr));
          m.put("usage_year_month", lineArr[0]);   //사용_년월   date
          m.put("land_location",   lineArr[1]);   //대지_위치   addr
          m.put("road_name_land_location",lineArr[2]);   //도로명_대지_위치   newAddr
          m.put("city_code",   lineArr[3]);   //시군구_코드   sigungu
          m.put("legal_code",   lineArr[4]);   //법정동_코드   bubjungdong
          m.put("classification_code",lineArr[5]);   //대지_구분_코드   addrCode
          m.put("lot", lineArr[6]);   //번   bun
          m.put("parcel",   lineArr[7]);   //지   si
          m.put("new_address_no",   lineArr[8]);   //새주소_일련번호   newAddrCode
          m.put("new_street_code", lineArr[9]);   //새주소_도로_코드   newAddr
          m.put("new_address_land_code", lineArr[10]);//새주소_지상지하_코드newAddrUnder
          m.put("new_address_bon_no",   lineArr[11]==""?Integer.parseInt(lineArr[11]):0);   //새주소_본_번   newAddrBun
          m.put("new_address_bu_no",   lineArr[12]==""?Integer.parseInt(lineArr[12]):0);   //새주소_부_번   newAddrBun2
          m.put("amount_kwh",   lineArr[13]==""?Integer.parseInt(lineArr[13]):0);   //사용_량(KWh)   usekwh
          
          list.add(m);
       }
       fileService.uploadFile(list);
       
       br.close();
       isr.close();
    }
    }
