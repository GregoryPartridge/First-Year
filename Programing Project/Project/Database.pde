import java.io.BufferedReader;
import java.io.FileReader;
import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.PreparedStatement;

/**
  * Creates a link between the SQL database and java-processing. Provides
  * methods to retrieve and manage the SQL database.
  * ----------------------------------------------------------------------------
  * Previous version(s)
  * ----------------------------------------------------------------------------
  * Used to parse the JSON file and convert them to Story/Comment objects which
  * were then stored in two separate HashMaps.
  * Only provided functions to retrieve a comment or story by id.
  * ----------------------------------------------------------------------------
  *
  * Maintained by Lexes Mantiquilla
  */
class Database {
  private Connection connection;
  private float percentFinished;
  private String fileName;
  private String databaseType;
  private String databaseName;
  private LoadingBarWidget loadingBar;

  /**
    * Constructs a new Database object setting the fileName, databaseName and
    * databaseType. Throws an IllegalArgumentException if any of the three
    * parameters are invalid.
    */
  Database(String fileName, String databaseName, String databaseType) {
    this.databaseType = databaseType.toLowerCase();
    this.databaseName = databaseName;
    if (!"h2".equals(databaseType) && !"mysql".equals(databaseType) && databaseName != null && "".equals(databaseName)) {
      throw new IllegalArgumentException();
    }
    this.fileName = fileName;
    this.loadingBar = loadingBar;
  }

  /** Retrieves a story from the database using id. */
  Story getStory(int id) throws SQLException {
    PreparedStatement getStory = connection.prepareStatement(String.format("SELECT * FROM stories WHERE id='%d' ", id));
    ResultSet resultSet = getStory.executeQuery();
    if (resultSet.next()) {
      return getStory(resultSet);
    }
    return null;
  }

  /** Overloaded method which creates a Story object from a ResultSet. */
  Story getStory(ResultSet resultSet) throws SQLException {
    return new Story(resultSet.getString("kids"), resultSet.getInt("descendants"), resultSet.getInt("score"), resultSet.getInt("time"), resultSet.getInt("id"), resultSet.getString("url"), resultSet.getString("title"), resultSet.getString("by"));
  }

  /** Retrieves a comment from the database using id. */
  Comment getComment(int id) throws SQLException {
    PreparedStatement getComment = connection.prepareStatement(String.format("SELECT * FROM comments WHERE id='%d' ", id));
    ResultSet resultSet = getComment.executeQuery();
    if (resultSet.next()) {
      return getComment(resultSet);
    }
    return null;
  }

  /** Overloaded method which creates a Comment object from a ResultSet. */
  Comment getComment(ResultSet resultSet) throws SQLException {
    return new Comment(resultSet.getString("kids"), resultSet.getInt("parent"), resultSet.getInt("time"), resultSet.getInt("id"), resultSet.getString("text"), resultSet.getString("by"));
  }

  /** Calls other functions which in conjunction initialises the database.*/
  void readFile() throws SQLException {
    println("Reading JSON file...");
    createTables();
    parseJSONFile();
    createIndexes();
  }

  /** Connects to the SQL server and creating the database if required. */
  void initialiseConnection() throws SQLException {
    try {
      if ("h2".equals(databaseType)) {
        Class.forName("org.h2.Driver");
        connection = DriverManager.getConnection("jdbc:h2:" + sketchPath("data/h2/" + databaseName), "root", "root"); // h2
      } else if ("mysql".equals(databaseType)){
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost/?rewriteBatchedStatements=true", "root", "root"); // mysql
        createDatabase();
        PreparedStatement useDatabase = connection.prepareStatement("USE " + databaseName);
        useDatabase.executeQuery();
      }
      println("Connection successful.");
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
    }
  }

  /** Creates the indexes which will speed up the SQL queries. */
  private void createIndexes() throws SQLException {
    println("Creating indexes...");
    setPercentFinished(0);
    long startTime = System.currentTimeMillis();
    if ("h2".equals(databaseType)) {
      initialiseLucene();
    }
    Statement statement = connection.createStatement();
    statement.executeUpdate("CREATE INDEX idx_stories_score_asc ON stories(score)");
    statement.executeUpdate("CREATE INDEX idx_stories_score_desc ON stories(score DESC)");
    statement.executeUpdate("CREATE INDEX idx_stories_time_asc ON stories(time)");
    statement.executeUpdate("CREATE INDEX idx_stories_time_desc ON stories(time DESC)");
    statement.executeUpdate("CREATE INDEX idx_stories_descendants_asc ON stories(descendants)");
    statement.executeUpdate("CREATE INDEX idx_stories_descendants_desc ON stories(descendants DESC)");
    statement.executeUpdate("CREATE INDEX idx_stories_by_asc ON stories(`by`)");
    statement.executeUpdate("CREATE INDEX idx_stories_by_desc ON stories(`by` DESC)");
    setPercentFinished(1);
    long endTime = System.currentTimeMillis();
    println("Finished creating indexes in " + (endTime - startTime) + " milliseconds.");
  }

  /**
   * Creates the stories and comments table overwriting the conents of the
   * overwriting the contents of the table.
   */
  private void createTables() throws SQLException {
    Statement statement = connection.createStatement();
    statement.executeUpdate("DROP TABLE IF EXISTS stories");
    statement.executeUpdate("DROP TABLE IF EXISTS comments");
    if ("mysql".equals(databaseType)) {
      statement.executeUpdate("CREATE TABLE stories(id int, descendants int, score int, time int, url TEXT(10000) NOT NULL, title VARCHAR(10000) NOT NULL, `by` varchar(255), kids TEXT(100000), PRIMARY KEY (id), FULLTEXT (title))");
    } else if ("h2".equals(databaseType)) {
      statement.executeUpdate("CREATE TABLE stories(id int, descendants int, score int, time int, url TEXT(10000) NOT NULL, title VARCHAR(10000) NOT NULL, `by` varchar(255), kids TEXT(100000), PRIMARY KEY (id))");
    }
    statement.executeUpdate("CREATE TABLE comments(id int, time int, parent int, text TEXT(100000), `by` varchar(255), kids TEXT(100000), PRIMARY KEY (id))");
  }

  /**
   * Reads the JSON file specified by the constructor line by line and inserts
   * either the comment or the story into the SQL server. This function
   * serializes the data.
   */
  private void parseJSONFile() throws SQLException {
    long startTime = System.currentTimeMillis();
    try {
      int count = 0;
      File file = new File(dataPath(fileName));
      long totalBytes = file.length();
      long currentByte = 0;
      Statement statement = connection.createStatement();
      PreparedStatement insertStory = connection.prepareStatement("INSERT INTO stories(id, descendants, score, time, url, title, `by`, kids) VALUES(?, ?, ?, ?, ?, ?, ?, ?)");
      PreparedStatement insertComment = null;
      if ("h2".equals(databaseType)) {
        insertComment = connection.prepareStatement("MERGE INTO comments(id, time, parent, text, `by`, kids) VALUES(?, ?, ?, ?, ?, ?)"); // h2
      } else {
        insertComment = connection.prepareStatement("INSERT INTO comments(id, time, parent, text, `by`, kids) VALUES(?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE time = time, parent = parent, text = text, `by` = `by`, kids = kids"); // mysql
      }
      BufferedReader bufferedReader = new BufferedReader(new FileReader(file));
      boolean endOfFile = false;
      while (!endOfFile) {
        String line = bufferedReader.readLine();
        if (line != null) {
          currentByte += line.getBytes().length;
          percentFinished = (float) currentByte / totalBytes;
          if (!JSONParser.getBoolean("deleted", false, line)) {
            String type = JSONParser.getString("type", "", line);
            String by = JSONParser.getString("by", "", line);
            String kids = JSONParser.getIntArrayAsString("kids", null, line);
            String title = JSONParser.getString("title", "", line).replace("\\", "");
            int time = JSONParser.getInt("time", 0, line);
            int id = JSONParser.getInt("id", 0, line);
            if ("story".equals(type) && !"".equals(title)) {
              insertStory.setInt(1, id);
              insertStory.setInt(2, JSONParser.getInt("descendants", 0, line));
              insertStory.setInt(3, JSONParser.getInt("score", 0, line));
              insertStory.setInt(4, time);
              insertStory.setString(5, JSONParser.getString("url", "", line));
              insertStory.setString(6, title);
              insertStory.setString(7, by);
              insertStory.setString(8, kids);
              insertStory.addBatch();
            } else if ("comment".equals(type)) {
              insertComment.setInt(1, id);
              insertComment.setInt(2, time);
              insertComment.setInt(3, JSONParser.getInt("parent", 0, line));
              insertComment.setString(4, JSONParser.getString("text", "", line).replace("\\", ""));
              insertComment.setString(5, by);
              insertComment.setString(6, kids);
              insertComment.addBatch();
            }
          }
        } else {
          endOfFile = true;
          bufferedReader.close();
        }
        if (count++ % 10000 == 0) {
          insertStory.executeBatch();
          insertComment.executeBatch();
        }
      }
      insertStory.executeBatch();
      insertComment.executeBatch();
    } catch (IOException e) {
      e.printStackTrace();
    }
    long endTime = System.currentTimeMillis();
    println("Finished parsing JSON file in " + (endTime - startTime) + " milliseconds");
  }

  /** Returns the number of stories from the database */
  int getNumberOfStories() throws SQLException {
    Statement statement = connection.createStatement();
    ResultSet numberOfStories = statement.executeQuery("SELECT COUNT(id) FROM stories");
    if (numberOfStories.next()) {
      return numberOfStories.getInt(1);
    }
    return 0;
  }

  /** Deletes the database folder and its contents */
  void delete() throws IOException {
    File databaseFolder = new File(dataPath(databaseType));
    if (databaseFolder.exists()) {
      File[] databaseFiles = databaseFolder.listFiles();
      for (File file : databaseFiles) {
        file.delete();
      }
      databaseFolder.delete();
    }
  }

  /** Initialises the search engine by creating a new table and indexes */
  void initialiseLucene() throws SQLException {
    Statement statement = connection.createStatement();
    statement.executeUpdate("CREATE ALIAS IF NOT EXISTS FTL_INIT FOR \"org.h2.fulltext.FullTextLucene.init\"");
    statement.executeUpdate("CALL FTL_INIT()");
    statement.executeUpdate("CALL FTL_DROP_ALL()");
    statement.executeUpdate("CALL FTL_CREATE_INDEX('PUBLIC', 'STORIES', 'TITLE')");
  }

  void createDatabase() throws SQLException {
    if ("mysql".equals(databaseType)) {
      PreparedStatement createDatabase = connection.prepareStatement("CREATE DATABASE IF NOT EXISTS " + databaseName);
      createDatabase.executeUpdate();
    }
  }

  float getPercentFinished() {
    return percentFinished;
  }

  void setPercentFinished(float percentFinished) {
    this.percentFinished = percentFinished;
  }

  Connection getConnection() {
    return connection;
  }

  String getDatabaseType() {
    return databaseType;
  }

  String getFileName() {
    return fileName;
  }

  String getDatabaseName() {
    return databaseName;
  }
}
