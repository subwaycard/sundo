package servlet.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;

import servlet.dto.SdDTO;
import servlet.service.ServletService;

@Controller
public class ServletController {
   @Resource(name = "ServletService")
   private ServletService servletService;
   
   @Resource(name="TlService")
   private TlService TlService;
   
   @GetMapping(value = "/main.do")
   public String mainTest(ModelMap model) throws Exception {
      List<SdDTO> list = TlService.selectSd();
      model.addAttribute("sdlist",list);
      
      return "main/main";
   }
   
   
   @GetMapping("/test.do")
   public String test() {
      return "main/test";
   }
}