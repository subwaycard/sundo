package servlet.DAO;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ChartDAO {
	
	@Autowired
	private SqlSession sqlSession;

	public List<Map<String, Object>> sdChart() {
		return sqlSession.selectList("ChartMapper.sdChart");
	}

	public List<Map<String, Object>> getChart(String sdcd) {
		return sqlSession.selectList("ChartMapper.getChart", sdcd);
	}
}
