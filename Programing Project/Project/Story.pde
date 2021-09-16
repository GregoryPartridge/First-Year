import java.text.SimpleDateFormat;
import java.text.DateFormat;
import java.util.Date;
import org.jsoup.Jsoup;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

/**
  * Class which stores the information obtained from the story type of JSON.
  * ----------------------------------------------------------------------------
  *
  * Maintained by Lexes Mantiquilla
  */
class Story {
  private int[] kids;
  private int descendants, score, time, id;
  private String url, title, by;
  private Comments comments;
  private String date;
  boolean commentsInitialised;

  /** Constructs a Story object using a JSONObject as a parameter. */
  Story(JSONObject story) {
    id = story.getInt("id");
    url = story.getString("url");
    title = story.getString("title");
    by = story.getString("by");
    try {
      time = story.getInt("time");
    }
    catch (RuntimeException exception) {
      time = 0;
      date = "";
    }
    try {
      kids = story.getJSONArray("kids").getIntArray();
    }
    catch (RuntimeException exception) {
      kids = new int[0];
    }
    try {
      descendants = story.getInt("descendants");
    }
    catch (RuntimeException exception) {
      descendants = 0;
    }
    try {
      score = story.getInt("score");
    }
    catch (RuntimeException exception) {
      score = 0;
    }
    comments = new Comments();
    commentsInitialised = false;
  }

  /** Constructs a Story object using a JSON String as a parameter. */
  Story(String story) {
    kids = JSONParser.getIntArray("kids", null, story);
    descendants = JSONParser.getInt("descendants", 0, story);
    score = JSONParser.getInt("score", 0, story);
    time = JSONParser.getInt("time", 0, story);
    id = JSONParser.getInt("id", 0, story);
    url = JSONParser.getString("url", "", story);
    title = JSONParser.getString("title", "", story);
    by = JSONParser.getString("by", "", story);
    comments = new Comments();
    date = new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date (time*1000L));
    commentsInitialised = false;
  }

  /**
    * Constructs a Story object using serveral parameters to initialise the
    * appropriate member variables.
    */
  Story(String kids, int descendants, int score, int time, int id, String url, String title, String by) {
    this.descendants = descendants;
    this.score = score;
    this.time = time;
    this.id = id;
    this.url = url;
    this.title = Jsoup.parse(title).text();
    this.by = by;
    date = new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date (time*1000L));
    if (kids != null) {
      String[] kidsString = kids.split("\\s?,\\s?");
      this.kids = new int[kidsString.length];
      for (int i = 0; i < this.kids.length; i++) {
        this.kids[i] = Integer.parseInt(kidsString[i].trim());
      }
    }
    comments = new Comments();
    commentsInitialised = false;
  }

  /** Retrieves all the comments from a story. */
  Comments getAllComments() throws SQLException {
    Comments allComments = new Comments(database);
    for (Comment comment : comments.getComments()) {
      comment.getAllComments(allComments);
      allComments.add(comment);
    }
    return allComments;
  }

  /**
    * Obtains all the kids a comment has and adds them to the subComments object.
    * This also retrieves all the kids a comment's subcomments.
    */
  void initialiseSubComments(Database database) throws SQLException {
    if (kids != null && !commentsInitialised) {
      database.setPercentFinished(0);
      for (int i = 0; i < kids.length; i++) {
        database.setPercentFinished((float) i / (kids.length - 1));
        int commentId = kids[i];
        Comment comment = database.getComment(commentId);
        if (comment != null) {
          comments.add(comment);
          comment.initialiseSubComments(database);
        }
      }
      commentsInitialised = true;
    }
  }

  /** Sorts all the comments by time. */
  void sortCommentsByTime() {
    comments.setComments(comments.getCommentsSortedByTime());
    for (Comment comment : comments.getComments()) {
      comment.sortSubCommentsByTime();
    }
  }

  /** Reverses the order of comments and their subcomments. */
  void reverseCommentsOrder() {
    comments.reverseOrder();
    for (Comment comment : comments.getComments()) {
      comment.reverseSubCommentsOrder();
    }
  }

  int[] getKids() {
    return kids;
  }

  int getDescendants() {
    return descendants;
  }

  int getScore() {
    return score;
  }

  int getTime() {
    return time;
  }

  String getDateAndTime()
  {
    DateFormat converter = new SimpleDateFormat("dd/MM/yyyy:HH:mm:ss");
    converter.setTimeZone(TimeZone.getTimeZone("GMT"));
    Date date = new Date((long) time * 1000);
    return converter.format(date).toString();
  }
  int getId() {
    return id;
  }

  String getUrl() {
    return url;
  }

  String getTitle() {
    return title;
  }

  String getBy() {
    return by;
  }

  Comments getComments() {
    return comments;
  }

  String getDate()
  {
    return date;
  }

}
