package servlet.DAO;


import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import servlet.DTO.SggDTO;


@Repository
public class SggDAO {
	
	@Autowired
	private SqlSession sqlSession;
	
	public List<SggDTO> selectSgg(String name) {
		return sqlSession.selectList("SggMapper.selectSgg", name);
	}

	public List<Map<String, Object>> selectGeom(String name) {
		return sqlSession.selectList("SggMapper.selectGeom",name);
	}

	public Map<String, Object> selectB(String name) {
	System.out.println("다오");
		return sqlSession.selectOne("SggMapper.selectB", name);
	}
	
}
