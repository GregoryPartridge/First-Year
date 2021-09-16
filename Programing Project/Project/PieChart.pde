import java.util.Map;
import java.util.List;
import java.util.LinkedList;
import java.util.LinkedHashMap;

/**
  * A Widget which displays the percentage of comments owned by a user on a
  * story.
  * ----------------------------------------------------------------------------
  *
  * Maintained by Lexes Mantiquilla
  */
class PieChart extends Widget {
  private Comments allCommentsFromStory;
  private HashMap<String, Comments> users;
  private LinkedHashMap<String, Float> percentages;
  private LinkedList<Map.Entry<String, Float>> percentagesList;
  private float radius, textSize, maxRadian, minRadian;
  private int[] colours;
  private boolean hasOneStoryOnly;
  private int maxNumComments;

  /**
    * Constructs a PieChart object, sets the member variables using the
    * parameters and initialises the colours and percentages.
    */
  PieChart(float x, float y, float width, float height, String title, color backgroundColor, Story story, int maxNumComments) throws SQLException {
    super(x, y, width, height, title, backgroundColor, 0);
    users = new HashMap();
    radius = width / 2;
    textSize = width / 20;
    allCommentsFromStory = story.getAllComments();
    matchCommentsToUser();
    initialisePercentages();
    initialiseColours();
    sortPercentages();
    this.maxNumComments = maxNumComments;
    if (percentages.size() == 1) {
      hasOneStoryOnly = true;
    } else {
      hasOneStoryOnly = false;
    }
    if(percentages.size() > this.maxNumComments) {
      showTopN(this.maxNumComments);
      initialiseColours();
    }
    percentagesList = new LinkedList(percentages.entrySet());
  }

  /**
    * Gets all the comments from the Story and stores them into a HashMap
    * using the 'by' as the key and the Comment object as the value.
    */
  void matchCommentsToUser() {
    for (Comment comment : allCommentsFromStory.getComments()) {
      String by = comment.getBy();
      Comments userComments = users.get(by);
      if (users.containsKey(by)) {
        userComments.add(comment);
      } else {
        users.put(by, new Comments());
        users.get(by).add(comment);
      }
    }
  }

  /**
    * Calculates and stores the percentage of comments a user has on the story
    * into a HashMap with the 'by' as the key and the percentage as the value.
    */
  void initialisePercentages() {
    percentages = new LinkedHashMap();
    for (Map.Entry<String, Comments> entry : users.entrySet()) {
      percentages.put(entry.getKey(), (float) entry.getValue().getComments().size() / allCommentsFromStory.getComments().size());
    }
  }

  /** Draws the pie chart and the names of the users to the right of it. */
  void draw() {
    stroke(0);
    float currentRadian = 0;
    for (int i = 0; i < percentagesList.size() && currentRadian < maxRadian; i++) {
      Map.Entry<String, Float> entry = percentagesList.get(i);
      float offset = i * textAscent() * 1.5;
      float totalTextHeight = textAscent() * 1.5 * percentages.size();
      float textX = x + radius * 1.75;
      float textY = y - totalTextHeight / 2 + offset;
      float percent = entry.getValue();
      float userRadians = RADIANS_IN_CIRCLE * percent;
      float scalar = 0;
      String user = entry.getKey();
      fill(colours[i]);
      if (mouseX > textX - textAscent() * 2 && mouseX < textX + textWidth(user) && mouseY > textY - textAscent() && mouseY < textY + textDescent()) {
        if (mousePressed) {
          firstScreen.userToSearch = user;
          searchDatabaseByClick();
        }
        // fill(color(255 - red(colours[i]), 255 - green(colours[i]), 255 - blue(colours[i])));
        if(darkThemeOn) fill(color(0));
        else fill(color(255));
        scalar = 1.25f;
      } else {
        scalar = 0.75f;
      }
      if (hasOneStoryOnly) {
        arc(x, y, width, height, currentRadian, ((maxRadian < currentRadian + userRadians) ? maxRadian : currentRadian + userRadians));
      } else {
        arc(x, y, width, height, currentRadian, ((maxRadian < currentRadian + userRadians) ? maxRadian : currentRadian + userRadians), PIE);
      }
      ellipse(textX - textAscent(), textY - textAscent() / 2, textAscent(), textAscent());
      fill(0);
      textAlign(CENTER);
      if (maxRadian > currentRadian + userRadians / 2) {
        if (hasOneStoryOnly) {
          text(entry.getValue() * 100 + "%", x, y);
        } else {
          float percentValue = percent * 100;
          String percentString = "";
          if (scalar == 1.25f) {
            percentString = String.format("%.2f%%", percentValue);
          } else if (percentValue > 4.5f) {
            percentString = String.format("%.0f%%", percentValue);
          }
          text(percentString, x + (float) (radius * scalar * Math.cos(currentRadian + userRadians / 2)), y + (float) (radius * scalar * Math.sin(currentRadian + userRadians / 2)));
        }
      }
      text(label, x, y - radius * 1.4);
      textAlign(BASELINE);
      text(user, textX, textY);
      currentRadian += userRadians;
    }
    maxRadian += 1 / (RADIANS_IN_CIRCLE * 2);
  }

  /** Assigns each user a colour. */
  void initialiseColours() {
    colours = new int[percentages.size()];
    colorMode(HSB);
    for (int i = 0; i < colours.length; i++) {
      colours[i] = color(255 * i / colours.length, 255, 255);
    }
    colorMode(RGB);
  }

  /** Sorts the persentages in descending order */
  void sortPercentages() {
    List<Map.Entry<String, Float>> userPercentages = new LinkedList(percentages.entrySet());
    Collections.sort(userPercentages, new Comparator<Map.Entry>() {
      public int compare(Map.Entry percent, Map.Entry percentToCompare) {
        float percentComparison = (float) percentToCompare.getValue() - (float) percent.getValue();
        if (percentComparison < 0) {
          return -1;
        } else if (percentComparison > 0) {
          return 1;
        }
        return 0;
      }
    });
    percentages = new LinkedHashMap();
    for (Map.Entry entry : userPercentages) {
      percentages.put((String) entry.getKey(), (float) entry.getValue());
    }
  }

  /** Show only N number of comments and show the rest as OTHERS*/
  void showTopN(int n) {
    float totalPercent = 0;
    List<Map.Entry<String, Float>> userPercentages = new LinkedList(percentages.entrySet());
    List<Map.Entry<String, Float>> topNPercentages = new LinkedList();
    for (int i = 0; i < userPercentages.size() && i < n; i++) {
      topNPercentages.add(userPercentages.get(i));
      totalPercent += userPercentages.get(i).getValue();
    }
    percentages = new LinkedHashMap();
    for (Map.Entry entry : topNPercentages) {
      percentages.put((String) entry.getKey(), (float) entry.getValue());
    }
    percentages.put((String) "OTHERS", (float) 1 - totalPercent);
  }

  int getMaxNumComments() {
   return maxNumComments;
  }
}
