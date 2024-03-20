package servlet.controller;

import java.util.List;

import servlet.dto.SdDTO;
import servlet.dto.SggDTO;

public interface TlService {

	List<SdDTO> selectSd();

	List<SggDTO> selectSgg(String name);

}
