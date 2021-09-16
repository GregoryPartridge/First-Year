import java.util.Comparator;
import java.util.Collections;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.PreparedStatement;

/**
  * Class which stores a collection of Stories and allows to sort them. Also
  * interfaces with the Database which allows story queries.
  * ----------------------------------------------------------------------------
  *
  * Maintained by Lexes Mantiquilla
  */
class Stories {
  private ArrayList<Story> stories;
  private int offset;
  private String currentQuery;
  private String currentDirection;
  private String userToSearch;
  private String titleToSearch;
  private ResultSet results;
  private Database database;

  /**
    * Constructs a Stories object and sets the database instance variable and
    * default values.
    */
  Stories(Database database) throws SQLException {
    this.database = database;
    stories = new ArrayList();
    offset = 0;
    loadByMostComments();
  }

  /**
    * Constructs a Stories object and sets the ArrayList of stories to the
    * parameter passed.
    */
  Stories(ArrayList<Story> stories) {
    this.stories = stories;
  }

  ArrayList<Story> getStories() {
    return stories;
  }

  void setStories(ArrayList<Story> stories) {
    this.stories = stories;
  }

  void setCurrentQuery(String query) {
    currentQuery = query;
  }

  void setCurrentDirection(String direction) {
    currentDirection = direction;
  }

  /** Returns the stories which match the user name passed. */
  ArrayList<Story> getStoriesByUser(String user) {
    ArrayList<Story> userStories = new ArrayList();
    for (Story story : stories) {
      if (story.getBy() != null && story.getBy().equals(user)) {
        userStories.add(story);
      }
    }
    return userStories;
  }

  /** Returns the ArrayList of stories sorted by score. */
  ArrayList<Story> getStoriesSortedByScore() {
    ArrayList<Story> sortedStories = (ArrayList<Story>) stories.clone();
    Collections.sort(sortedStories, new StoryScoreComparator());
    return sortedStories;
  }

  /** Returns the ArrayList of stories sorted by time. */
  ArrayList<Story> getStoriesSortedByTime() {
    ArrayList<Story> sortedStories = (ArrayList<Story>) stories.clone();
    Collections.sort(sortedStories, new StoryTimeComparator());
    return sortedStories;
  }

  /** Returns the ArrayList of stories sorted by number of comments. */
  ArrayList<Story> getStoriesSortedByDescendants() {
    ArrayList<Story> sortedStories = (ArrayList<Story>) stories.clone();
    Collections.sort(sortedStories, new StoryDescendantsComparator());
    return sortedStories;
  }

  /** Returns an ArrayList of stories which match the title passed. */
  ArrayList<Story> getStoriesByTitle(String title) {
    ArrayList<Story> matchedStories = new ArrayList();
    for (Story story : stories) {
      if(story.getTitle() != null && story.getTitle().toLowerCase().contains(title.toLowerCase())) {
        matchedStories.add(story);
      }
    }
    return matchedStories;
  }

  /** Reverses the order of the query */
  void reverseOrder() {
    if (currentDirection.equals(DESCENDING)) {
      currentDirection = ASCENDING;
    } else {
      currentDirection = DESCENDING;
    }
  }

  /** Sorts all the comments and subcomments by time. */
  void sortCommentsByTime() {
    for (Story story : stories) {
      story.sortCommentsByTime();
    }
  }

  /** Retrieves stories from the database based on the query selected. */
  void queryDatabase() throws SQLException{
    database.setPercentFinished(0);
    PreparedStatement statement = null;
    Connection connection = database.getConnection();
    if (userToSearch != null) {
      statement = connection.prepareStatement(String.format("SELECT * FROM stories WHERE `by` = ? ORDER BY %s %s LIMIT %d OFFSET %d",  currentQuery, currentDirection, AMOUNT_OF_WIDGETS_ON_SCREEN, offset));
      statement.setString(1, userToSearch);
    } else if (titleToSearch != null) {
      if ("mysql".equals(database.getDatabaseType())) {
        statement = connection.prepareStatement(String.format("SELECT * FROM stories WHERE Match(title) Against(? IN BOOLEAN MODE) ORDER BY %s %s LIMIT %d OFFSET %d", currentQuery, currentDirection, AMOUNT_OF_WIDGETS_ON_SCREEN, offset));
        statement.setString(1, String.format("%s*", titleToSearch));
      } else if("h2".equals(database.getDatabaseType())) {
        statement = connection.prepareStatement(String.format("SELECT S.* FROM FTL_SEARCH_DATA(?, 0, 0) FTL, STORIES S WHERE S.ID=FTL.KEYS[0] ORDER BY %s %s LIMIT %d OFFSET %d", currentQuery, currentDirection, AMOUNT_OF_WIDGETS_ON_SCREEN, offset));
        statement.setString(1, String.format("%s*", titleToSearch));
      }
    } else {
      statement = connection.prepareStatement(String.format("SELECT * FROM stories ORDER BY %s %s LIMIT %d OFFSET %d", currentQuery, currentDirection, AMOUNT_OF_WIDGETS_ON_SCREEN, offset));
    }
    results = statement.executeQuery();
    updateStories();
  }

  /**
    * Retrieves the next n stories to fill the next page of StoryWidgets.
    * Synchronized prevents threads from breaking the object.
    */
  synchronized void loadNextStories() throws SQLException {
    if (stories.size() == AMOUNT_OF_WIDGETS_ON_SCREEN) {
      setOffset(getOffset() + AMOUNT_OF_WIDGETS_ON_SCREEN);
    }
    queryDatabase();
  }

  /**
    * Retrieves the previous n stories to fill the next page of StoryWidgets.
    * Synchronized prevents threads from breaking the object.
    */
  synchronized void loadPreviousStories() throws SQLException {
    setOffset(getOffset() - AMOUNT_OF_WIDGETS_ON_SCREEN);
    queryDatabase();
  }

  int getOffset() {
    return offset;
  }

  void setOffset(int offset) throws SQLException {
    if (offset >= 0 && offset <= database.getNumberOfStories()) {
      this.offset = offset;
    }
  }

  /** Queries the database by newest. */
  void loadByNewest() throws SQLException {
    setCurrentQuery(TIME);
    setCurrentDirection(DESCENDING);
    setOffset(0);
    queryDatabase();
  }

  /** Queries the database by oldest. */
  void loadByOldest() throws SQLException {
    setCurrentQuery(TIME);
    setCurrentDirection(ASCENDING);
    setOffset(0);
    queryDatabase();
  }

  /** Queries the database by highest scores. */
  void loadByMostUpvoted() throws SQLException {
    setCurrentQuery(SCORE);
    setCurrentDirection(DESCENDING);
    setOffset(0);
    queryDatabase();
  }

  /** Queries the database by lowest scores. */
  void loadByLeastUpvoted() throws SQLException {
    setCurrentQuery(SCORE);
    setCurrentDirection(ASCENDING);
    setOffset(0);
    queryDatabase();
  }

  /** Queries the database by most comments. */
  void loadByMostComments() throws SQLException {
    setCurrentQuery(DESCENDANTS);
    setCurrentDirection(DESCENDING);
    setOffset(0);
    queryDatabase();
  }

  /** Queries the database by least comments. */
  void loadByLeastComments() throws SQLException {
    setCurrentQuery(DESCENDANTS);
    setCurrentDirection(ASCENDING);
    setOffset(0);
    queryDatabase();
  }

  /** Replaces the old comments with the new comments from the query. */
  void updateStories() throws SQLException {
    int count = 0;
    stories.clear();
    while (results.next() && count < AMOUNT_OF_WIDGETS_ON_SCREEN) {
      Story story = database.getStory(results);
      stories.add(story);
      database.setPercentFinished((float) count++ / (AMOUNT_OF_WIDGETS_ON_SCREEN - 1));
    }
    database.setPercentFinished(1);
  }

  /**
    * Queries the database and finds all stories by the specified user.
    * Synchronized prevents threads from breaking the object.
    */
  synchronized void searchByUser(String user) throws SQLException {
    resetQuery();
    if ("".equals(user)) {
      userToSearch = null;
    } else {
      userToSearch = user;
    }
    setOffset(0);
    queryDatabase();
  }

  /**
    * Queries the database and finds all stories by the specified title.
    * Synchronized prevents threads from breaking the object.
    */
  synchronized void searchByTitle(String title) throws SQLException {
    resetQuery();
    if ("".equals(title)) {
      titleToSearch = null;
    } else {
      titleToSearch = title;
    }
    setOffset(0);
    queryDatabase();
  }

  void resetQuery() {
    userToSearch = null;
    titleToSearch = null;
  }
}

/** Allows stories to be sorted by score. */
class StoryScoreComparator implements Comparator<Story> {
  int compare(Story story, Story storyToCompare) {
    return story.getScore() - storyToCompare.getScore();
  }
}

/** Allows stories to be sorted by time. */
class StoryTimeComparator implements Comparator<Story> {
  int compare(Story story, Story storyToCompare) {
    return story.getTime() - storyToCompare.getTime();
  }
}

/** Allows stories to be sorted by number of comments. */
class StoryDescendantsComparator implements Comparator<Story> {
  int compare(Story story, Story storyToCompare) {
    return story.getDescendants() - storyToCompare.getDescendants();
  }
}
