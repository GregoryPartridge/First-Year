import org.jsoup.Jsoup;

/**
  * Class which stores the information obtained from the comment type of JSON.
  * ----------------------------------------------------------------------------
  *
  * Maintained by Lexes Mantiquilla
  */
class Comment {
  private int[] kids;
  private int parent, id, time;
  private String text, by;
  private Comments subComments;
  private float y;
  private int numberOfLines;

  /** Constructs a Comment object using a JSONObject as a parameter. */
  Comment(JSONObject comment) {
    parent = comment.getInt("parent");
    id = comment.getInt("id");
    time = comment.getInt("time");
    text = comment.getString("text");
    by = comment.getString("by");
    try {
      kids = comment.getJSONArray("kids").getIntArray();
    }
    catch (RuntimeException exception) {
      kids = new int[0];
    }
    subComments = new Comments();
  }

  /** Constructs a Comment object using a JSON String as a parameter. */
  Comment(String comment) {
    kids = JSONParser.getIntArray("kids", null, comment);
    parent = JSONParser.getInt("parent", 0, comment);
    time = JSONParser.getInt("time", 0, comment);
    id = JSONParser.getInt("id", 0, comment);
    text = JSONParser.getString("text", "", comment);
    by = JSONParser.getString("by", "", comment);
    subComments = new Comments();
  }

  /**
    * Constructs a Comment object using serveral parameters to initialise the
    * appropriate member variables.
    */
  Comment(String kids, int parent, int time, int id, String text, String by) {
    this.parent = parent;
    this.time = time;
    this.id = id;
    this.text = Jsoup.parse(text).text();
    this.by = by;
    if (kids != null) {
      String[] kidsString = kids.split("\\s?,\\s?");
      this.kids = new int[kidsString.length];
      for (int i = 0; i < this.kids.length; i++) {
        this.kids[i] = Integer.parseInt(kidsString[i].trim());
      }
    }
    subComments = new Comments();
  }

  /**
    * Recursive function which will retrieve each comment in the kids
    * array and add it to the subComments object. This will then call itself
    * for each comment retrieved. This will continue until no more comments
    * are found.
    */
  void initialiseSubComments(Database database) throws SQLException {
    if (kids != null) {
      for (int commentId : kids) {
        Comment comment = database.getComment(commentId);
        if(comment != null) {
          subComments.add(comment);
          comment.initialiseSubComments(database);
        }
      }
    }
  }

  /** Sorts the comments by time in ascending order. */
  void sortSubCommentsByTime() {
    subComments.setComments(subComments.getCommentsSortedByTime());
    for (Comment comment : subComments.getComments()) {
      comment.sortSubCommentsByTime();
    }
  }

  /**
    * Recursive function which reverses the order of each comment and their
    * subcomments.
    */
  void reverseSubCommentsOrder() {
    subComments.reverseOrder();
    for (Comment comment : subComments.getComments()) {
      comment.reverseSubCommentsOrder();
    }
  }

  /**
    * Recursive function which adds all the comment and its subcomments into
    * the Comments object passed.
    */
  void getAllComments(Comments allComments) {
    for (Comment comment : subComments.getComments()) {
      allComments.add(comment);
      comment.getAllComments(allComments);
    }
  }

  int[] getKids()
  {
    return kids;
  }

  int getParent()
  {
    return parent;
  }

  int getId()
  {
    return id;
  }

  int getTime()
  {
    return time;
  }

  String getText()
  {
    return text;
  }
  
  String getDateAndTime()
  {
    DateFormat converter = new SimpleDateFormat("dd/MM/yyyy:HH:mm:ss");
    converter.setTimeZone(TimeZone.getTimeZone("GMT"));
    Date date = new Date((long) time * 1000);
    return converter.format(date).toString();
  }

  String getBy()
  {
    return by;
  }

  void setY(int y)
  {
    this.y = y;
  }

  float getY()
  {
   return y;
  }

  void setY(float y)
  {
    this.y = y;
  }

  Comments getSubComments() {
    return subComments;
  }

  void setText(String text)
  {
    this.text = text;
  }
  
  void setNumberOfLines(int num)
  {
    this.numberOfLines = num;
  }
  
  int getNumberOfLines()
  {
    return this.numberOfLines;
  }
}
