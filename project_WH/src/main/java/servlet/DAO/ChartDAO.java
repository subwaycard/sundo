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

	public static List<Map<String, Object>> sdChart() {
		
		return null;
	}

	public static List<Map<String, Object>> getChart(String sdcd) {
		
		return null;
	}

	
	
	


}
