import java.util.Map;

/**
  * A Widget which displays the percentage of comments owned by a user on a
  * story. Displays them as a BarChart with the highest point corrosponding
  *  to the largest amout of comments.
  *----------------------------------------------------------------------------
  *
  * Created by Gregory Partridge
  */
class BarChart extends Widget {
  private Comments allCommentsFromStory;
  private HashMap<String, Comments> users;
  private HashMap<String, Float> percentages;
  private float radius, textSize;
  private int[] colours;
  private boolean hasOneStoryOnly;

  boolean mouseOnBar;

  /**
    * Constructs a PieChart object, sets the member variables using the
    * parameters and initialises the colours and percentages.
    */
  BarChart(float x, float y, float width, float height, String title, color backgroundColor, Story story) throws SQLException {
    super(x, y, width, height, title, backgroundColor, 0);
    users = new HashMap();
    radius = width / 2;
    textSize = width / 20;
    allCommentsFromStory = story.getAllComments();
    matchCommentsToUser();
    initialisePercentages();
    //initialiseColours();
    if (percentages.size() == 1) {
      hasOneStoryOnly = true;
    } else {
      hasOneStoryOnly = false;
    }
    mouseOnBar=false;
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
    percentages = new HashMap();
    for (Map.Entry<String, Comments> entry : users.entrySet()) {
      percentages.put(entry.getKey(), (float) entry.getValue().getComments().size() / allCommentsFromStory.getComments().size());
    }
  }

  /** Draws the pie chart and the names of the users to the right of it. */
  void draw() {
    fill(0);
    int amountOfUsers = percentages.size();
    int i = 0;
    float maxValue = 0;
    float divisor = width/amountOfUsers;
    for (Map.Entry<String, Float> entry : percentages.entrySet()) if(entry.getValue() > maxValue) maxValue = entry.getValue();
    float scale = height/maxValue;
    line(x,y,x,y - height);
    line(x-5, y-height,x+5,y-height);
    text((String.format("%.2f%%", maxValue * 100)),x - 60 ,y-height + 8);
    line(x,y,x+width,y);
    for (Map.Entry<String, Float> entry : percentages.entrySet()) {
      noStroke();
      fill(155,0,0);
      String user = entry.getKey();
      float percentWrote = entry.getValue();
      if(mouseX>x+ (i * divisor) && mouseX<x+(divisor)+ (i * divisor)&& mouseY>y-(maxValue * scale) && mouseY<y) {
        mouseOnBar=true;
        if (mousePressed) {
          firstScreen.userToSearch = user;
          searchDatabaseByClick();
        }
      }
      else mouseOnBar=false;
      if(mouseOnBar) stroke(0);
      else noStroke();
      rect(x+(divisor/5) + (i * divisor),y, 3*(divisor/5),  -(percentWrote * scale));

      fill(0);
      if(mouseOnBar)
      {
        line(x+width/2, y + height/5.5, x+(divisor/5) + (i * divisor) , y);
        ellipse(x+width/2, y + height/5.5, 5, 5);
      }
      text(label, x + width/4, y - radius * 1.4 + height/4);
      String userPercent= user + ": "+(String.format("%.2f%%", percentWrote * 100));
      //int newColour1 = (int)(Math.random() * 256);
      //int newColour2 = (int)(Math.random() * 256);
      //int newColour3 = (int)(Math.random() * 256);
      //fill(newColour1, newColour2, newColour3);
      if(mouseOnBar)
      {
        textAlign(CENTER,CENTER);
        text(userPercent, x+width/2, y + height/4);
        textAlign(LEFT);
      }
      fill(0);



      i++;
    }
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
}
