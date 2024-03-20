package servlet.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import servlet.dto.SggDTO;

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
}
