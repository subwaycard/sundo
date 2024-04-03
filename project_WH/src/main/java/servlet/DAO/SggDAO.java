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
		return sqlSession.selectList("SggMapper.selectGeom", name);
	}

	public Map<String, Object> selectB(String name) {
		System.out.println("다오");
		return sqlSession.selectOne("SggMapper.selectB", name);
	}

	public Map<String, Object> LegendInfo(String name) {

		return sqlSession.selectOne("SggMapper.LegendInfo", name);
	}

}

/*
 * public List<Map<String, Object>> sdChart() { // TODO Auto-generated method
 * stub return sqlSession.selectList; }
 * 
 * public List<Map<String, Object>> getChart(String sdcd) { // TODO
 * Auto-generated method stub return sqlSession.selectList; }
 * 
 * }
 */
