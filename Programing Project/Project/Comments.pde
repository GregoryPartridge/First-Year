import java.util.Map;
import java.util.Comparator;
import java.util.Collections;

/**
  * Class which stores a collection of Comments and allows to sort them.
  * ----------------------------------------------------------------------------
  * 
  * Maintained by Lexes Mantiquilla
  */
class Comments {
  private ArrayList<Comment> comments;
  Database database;

  /** Constructs a Comments object and sets the database instance variable. */
  Comments(Database database) {
    comments = new ArrayList();
    this.database = database;
  }

  /**
    * Constructs a Comments object and sets the ArrayList of comments to the
    * parameter passed.
    */
  Comments(ArrayList<Comment> comments) {
    this.comments = comments;
  }

  /** Constructs an empty Comments object. */
  Comments() {
    comments = new ArrayList();
  }

  /** Adds the comment passed into the ArrayList of comments. */
  void add(Comment comment) {
    comments.add(comment);
  }

  /** Returns the comments which match the user name passed. */
  ArrayList<Comment> getCommentsByUser(String user) {
    ArrayList<Comment> userComments = new ArrayList();
    for (Comment comment : comments) {
      if (comment.getBy() != null && comment.getBy().equals(user)) {
        userComments.add(comment);
      }
    }
    return userComments;
  }

  /** Returns the ArrayList of comments sorted by time. */
  ArrayList<Comment> getCommentsSortedByTime() {
    ArrayList<Comment> sortedComments = (ArrayList<Comment>) comments.clone();
    Collections.sort(sortedComments, new CommentTimeComparator());
    return sortedComments;
  }

  /** Reverses the order of the comments. */
  ArrayList<Comment> reverseOrder() {
    Collections.reverse(comments);
    return comments;
  }

  ArrayList<Comment> getComments() {
    return comments;
  }

  void setComments(ArrayList<Comment> comments) {
    this.comments = comments;
  }
}

/** Allows the Comment objects in Comments to be sorted by time. */
class CommentTimeComparator implements Comparator<Comment> {
  int compare(Comment comment, Comment commentToCompare) {
    return comment.getTime() - commentToCompare.getTime();
  }
}
