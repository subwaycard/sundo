package servlet.service;

import java.util.List;

import org.springframework.stereotype.Service;

import servlet.DTO.SdDTO;
import servlet.DTO.SggDTO;

@Service
public interface TlService {

	List<SggDTO> selectSgg(String name);
	
	List<SdDTO> selectSd();

}
