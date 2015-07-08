import java.sql.SQLException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.DriverManager;

public class HiveJdbcClient {
	private static String hiveDriverName = "org.apache.hive.jdbc.HiveDriver";
	private static String sqlDriverName = "com.microsoft.sqlserver.jdbc.SQLServerDriver";

	public static void main(String[] args) throws SQLException {
		float executionTime = ExecuteHiveQuery(args[0]);
		ExecuteSQLQuery(executionTime);
	}
	
	public static float ExecuteHiveQuery(String query) throws SQLException {
		try {
			Class.forName(hiveDriverName);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			System.exit(1);
		}
		Connection conn = DriverManager.getConnection("jdbc:hive2://localhost:10001/default", "", "");
		Statement stmt = conn.createStatement();
		long ini = System.currentTimeMillis();
		ResultSet res = stmt.executeQuery(query);
		long end = System.currentTimeMillis();
		/*while (res.next()) {
			System.out.println(res.getString(1));
		}*/
		return end - ini;
	}
	
	public static void ExecuteSQLQuery(float executionTime) throws SQLException {
		try {
			Class.forName(sqlDriverName);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			System.exit(1);
		}
		Connection conn = DriverManager.getConnection("jdbc:sqlserver://vide-hadoopm01;database=HadoopPerf;Username=hive;Password=bdp2015");
		Statement stmt = conn.createStatement();
		String query = "UPDATE HadoopPerf.dbo.TestCases SET ExecutionTime = " + executionTime + " WHERE Id = (SELECT MAX(Id) FROM HadoopPerf.dbo.TestCases)";
		stmt.execute(query);
	}
}