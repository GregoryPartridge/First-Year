/** //<>//
  * A subclass of Widget which is used for presenting the widgets. It contains
  * the code for te widget shape, the shadow when hovered, change in colour of
  * text in widget and the opening of widget.
  *----------------------------------------------------------------------------
  *
  * Created by Gregory Partridge & Conall Tuohy
  */

PImage openWidget; //<>//

class StoryWidget extends Widget {
  private String url;
  private Story story;
  private String  potentialTitleLine1;
  private String  potentialTitleLine2;
  private String  potentialUrlLine1;
  private String  potentialUrlLine2;
  private float   titleHeightOffset;
  private float   urlHeightOffset;
  private PFont   urlFont, storyFont;
  private boolean linkClickedOn;
  private Screen screen;
  private int widgetPosition;
  private Database database;
  private PieChart pieChart;
  private BarChart barChart;
  boolean widgetOpened, canOpenWidget;
  float yPosition;
  float widgetWidth;
  boolean blueText;
  int maxPossibleTitleLength;
  int maxPossibleUrlLength;
  int titleFontSize;
  int urlFontSize;
  int originalX;
  int finalX;
  int speed;
  float openWidgetHeight = displayHeight/1.8;
  StoryWidget(int x, int y, int width, int height, String title, color widgetColor, int event, String url, int widgetPosition, Story story, Screen screen, Database database) {
    super(x, y, width, height, title, widgetColor, event);
    originalX = x;
    this.url = url;
    this.story = story;
    yPosition = y;
    titleHeightOffset= yPosition+height-35;
    urlHeightOffset= yPosition+height-15;
    storyFont = loadFont("Dubai-Regular-18.vlw");
    urlFont = loadFont("Dubai-Regular-11.vlw");
    blueText = false;
    linkClickedOn = false;
    widgetWidth = ((displayWidth/19)*16);
    openWidget = loadImage("OpenWidget.png");
    titleFontSize = 16;
    maxPossibleTitleLength = round(widgetWidth/(titleFontSize/2));
    urlFontSize = 12;
    maxPossibleUrlLength = round(widgetWidth/(urlFontSize/2));
    widgetOpened = false;
    canOpenWidget = false;
    this.screen = screen;
    this.widgetPosition = widgetPosition;
    this.database = database;
    finalX = (int)-widgetWidth;
    speed = 1;
  }

  boolean titleLengthOverMaxChecker() {
    if (story != null && story.getTitle().length()>maxPossibleTitleLength)
    {
      int positionOfNearestSpace = story.getTitle().indexOf(" ", maxPossibleTitleLength-5);
      if (positionOfNearestSpace==-1)return false;
      potentialTitleLine1 = story.getTitle().substring(0, positionOfNearestSpace);
      if (story.getTitle().length()>150) {
        potentialTitleLine2 = story.getTitle().substring(positionOfNearestSpace, 150);
        potentialTitleLine2 += "...";
      } else {
        potentialTitleLine2 = story.getTitle().substring(positionOfNearestSpace);
      }
      return true;
    } else return false;
  }

  boolean urlLengthOverMaxChecker() {
    if (story != null && story.getUrl().length()>maxPossibleUrlLength)
    {
      potentialUrlLine1 = story.getUrl().substring(0, maxPossibleUrlLength);
      if (story.getUrl().length()>320) {
        potentialUrlLine2 = story.getUrl().substring(maxPossibleUrlLength, 320);
        potentialUrlLine2 += "...";
      } else {
        potentialUrlLine2 = story.getUrl().substring(maxPossibleUrlLength);
      }
      return true;
    } else return false;
  }

  void draw() {
    if (story != null) {
      titleHeightOffset= yPosition+height-35;
      urlHeightOffset= yPosition+height-15;

      if (!titleLengthOverMaxChecker()) {
        thinWidgetDraw();

        text(story.getScore(), x + widgetWidth - 20, yPosition + height - 25);
      } else {
        thickWidgetDraw();
      }

      if (pieChart != null && widgetOpened) {
        pieChart.draw();
        pieChart.y = getYPosition() + getHeight() / 2;
        pieChart.x = x + (widgetWidth/5);
      }
      if (barChart != null && widgetOpened) {
        barChart.draw();
        barChart.y = getYPosition() + (3 * getHeight() / 4);
        barChart.x = x + (widgetWidth/2);
      }
    }
  }

/*
The next few functions were created by Eoin Pinaqui to animate the swiping motion of the story widgets
*/
  int getFinalX()
  {
    return finalX;
  }
  void decreaseX()
  {
    x-= speed;
    speed+=2;
  }

  int getOriginalX()
  {
    return originalX;
  }
  void setX(int x)
  {
    this.x = x;
  }
  void increaseX()
  {
    x+= speed;
    speed+=2;
  }

  int getX()
  {
    return (int) x;
  }

  void restoreX()
  {
    x = originalX;
    speed = 1;
  }
  /*The previous function was the last function created by Eoin Pinaqui*/
  
  void thinWidgetDraw() {
    if (mouseY >=yPosition && mouseY < yPosition + height && mouseX >= x - height && mouseX <= x+widgetWidth)
    {
      noStroke();
      fill(0);
      rect(x-(height/2), yPosition, (widgetWidth+(OFFSET_FOR_SHADOW/2))+(height), (height+OFFSET_FOR_SHADOW/2), 10);
      //ellipse(x, yPosition+((height+OFFSET_FOR_SHADOW)/2), (height), (height));
      //ellipse(x+(widgetWidth), yPosition+((height+OFFSET_FOR_SHADOW)/2), (height), (height));
      blueText=true;
    } else {
      blueText=false;
    }
    fill(widgetColor);
    noStroke();


    rect(x-(height/2), yPosition, widgetWidth+(height), height, 10);
    //ellipse(x, yPosition+(height/2), height, height);
    //ellipse(x+widgetWidth, yPosition+(height/2), height, height);

    if (widgetOpened)
    {
      rect(x-(height/2), yPosition, widgetWidth+(height), height + openWidgetHeight, 10);
      rect(x, yPosition + height/2, widgetWidth, openWidgetHeight, 10);
      //ellipse(x, yPosition+(height/2) + openWidgetHeight, height, height);
      //ellipse(x+widgetWidth, yPosition+(height/2) + openWidgetHeight, height, height);
    }
    fill(195);
    ellipse(x+((24 * widgetWidth)/25) + 20, yPosition + ((height - 40)/2) + 20, 40, 40);
    if (mouseY >=yPosition + ((height - 40)/2) && mouseY <yPosition + ((height - 40)/2) + 40 && mouseX >=(x+((24 * widgetWidth)/25))&& mouseX <= (x+((24 * widgetWidth)/25)) + 40)
    {
      fill(155);
      ellipse(x+((24 * widgetWidth)/25) + 20, yPosition + ((height - 40)/2) + 20, 40, 40);
      canOpenWidget=true;
    } else canOpenWidget = false;
    if (blueText)
    {
      fill(0, 0, 255);
    } else fill(0);
    if (linkClickedOn) fill(125, 11, 94);
    image(openWidget, x+((24 * widgetWidth)/25), yPosition + ((height - 40)/2));
    textFont(urlFont);
    if (!urlLengthOverMaxChecker()) {
      text(story.getUrl(), x-10, urlHeightOffset);
    } else {
      text(potentialUrlLine1, x-10, urlHeightOffset-5);
      text(potentialUrlLine2, x-10, urlHeightOffset+5);
    }
    if (blueText)
    {
      char[] firstCharacterArray = story.getUrl().toCharArray();
      textUnderliner(firstCharacterArray, (urlHeightOffset+5), 5.0);
    }
    textFont(storyFont);
    if (story.getBy() != "")
    {
      text("By: "+story.getBy(), x + widgetWidth - 200, yPosition + height - 40);
    } else
    {
      text("Unknown User", x + widgetWidth - 200, yPosition + height - 40);
    }
    textFont(urlFont);
    if (story.getTime() != 0)
      text(story.getDateAndTime(), x + widgetWidth - 200, yPosition + height - 10);
    else text("Unknown Date", x + widgetWidth - 200, yPosition + height - 10);
    textFont(storyFont);
    text(story.getTitle(), x-10, titleHeightOffset);

    if (blueText)
    {
      String theTitle=story.getTitle();
      char[] secondCharacterArray = theTitle.toCharArray();
      textUnderliner(secondCharacterArray, (titleHeightOffset+7), 7.5);
    }
  }

  void thickWidgetDraw() {
    if (mouseY >=yPosition && mouseY < yPosition + 2*height && mouseX >=x && mouseX <= x+widgetWidth)
    {
      noStroke();
      fill(0);
      rect(x-(height/2), yPosition, (widgetWidth+(OFFSET_FOR_SHADOW/2))+(height), (height+OFFSET_FOR_SHADOW/2)+height, 10);
      //ellipse(x, yPosition+((height+OFFSET_FOR_SHADOW)/2)+height, (height), (height));
      //ellipse(x+(widgetWidth), yPosition+((height+OFFSET_FOR_SHADOW)/2)+height, (height), (height));
      blueText=true;
    } else {
      blueText=false;
    }
    fill(widgetColor);
    noStroke();
    rect(x-(height/2), yPosition, widgetWidth+(height), height, 10);
    //ellipse(x, yPosition+(height/2), height, height);
    //ellipse(x+widgetWidth, yPosition+(height/2), height, height);
    rect(x-(height/2), yPosition+height, widgetWidth+(height), height, 10);
    //ellipse(x, yPosition+(height/2)+height, height, height);
    //ellipse(x+widgetWidth, yPosition+(height/2)+height, height, height);
    rect(x-(height/2), yPosition+(height/2), widgetWidth+(height*2), height, 10);



    if (widgetOpened)
    {
      rect(x - height/2, yPosition + height/2, widgetWidth+height, openWidgetHeight, 10);
      //ellipse(x, yPosition+(height/2) + openWidgetHeight, height, height);
      //ellipse(x+widgetWidth, yPosition+(height/2) + openWidgetHeight, height, height);
    }
    fill(195);
    ellipse(x+((24 * widgetWidth)/25) + 20, yPosition + ((height - 40)/2) + 20, 40, 40);
    if (blueText)
    {
      if (mouseY >=yPosition + ((height - 40)/2) && mouseY <yPosition + ((height - 40)/2) + 40 && mouseX >=(x+((24 * widgetWidth)/25)) && mouseX <= (x+((24 * widgetWidth)/25)) + 40)
      {
        fill(155);
        ellipse(x+((24 * widgetWidth)/25) + 20, yPosition + ((height - 40)/2) + 20, 40, 40);
        canOpenWidget=true;
      } else canOpenWidget=false;
      fill(0, 0, 255);
    } else fill(0);

    if (linkClickedOn) fill(125, 11, 94);
    image(openWidget, x+((24 * widgetWidth)/25), yPosition + ((height - 40)/2));
    textFont(urlFont);
    if (!urlLengthOverMaxChecker()) {
      text(story.getUrl(), x-10, urlHeightOffset+height);
    } else {
      text(potentialUrlLine1, x-10, urlHeightOffset-5+height);
      text(potentialUrlLine2, x-10, urlHeightOffset+5+height);
    }
    if (blueText)
    {
      char[] secondCharacterArray = story.getUrl().toCharArray();
      textUnderliner(secondCharacterArray, (urlHeightOffset+height+5), 5.0);
    } else
      textFont(storyFont);
    text(potentialTitleLine1, x-10, titleHeightOffset);
    if (blueText)
    {
      char[] secondCharacterArray = potentialTitleLine1.toCharArray();
      textUnderliner(secondCharacterArray, ( titleHeightOffset + 7), 7.5);
    } else
      text(potentialTitleLine2, x-10, titleHeightOffset+(height/2));
    if (blueText)
    {
      char[] thirdCharacterArray = potentialTitleLine2.toCharArray();
      textUnderliner(thirdCharacterArray, (titleHeightOffset + 7 + (height/2)), 7.5);
    }
  }

  void textUnderliner(char[] stringToBeUnderlined, float heightOfStringToBeWritten, float textSizeAmount) {
    //Takes text and position of all text and underlines it catering to it's font size
    for (int count1=0; count1<stringToBeUnderlined.length; count1++)
    {
      if (stringToBeUnderlined[count1]!=32) rect(x-10, heightOfStringToBeWritten, textSizeAmount*count1, 1);
    }
  }

  boolean mousePressed() {
    if (story != null) {

      if (blueText && !canOpenWidget && mouseY>displayHeight/6) {
        linkClickedOn=true;
        //If the Story has a Url, it checks where that Url is. If the mouse is over it while clicked, it will open the link to it, otherwise, do nothing.
        if (story.getUrl()!="") {
          if (!titleLengthOverMaxChecker()) {
            //^Check if Widget is Thick or Not
            if (!urlLengthOverMaxChecker() && mouseX>x-10 && mouseY>urlHeightOffset && mouseX<x-10+textWidth(story.getUrl()) && mouseY<urlHeightOffset+10)
              link(story.getUrl());
            else if (mouseX>x-10 && mouseY>urlHeightOffset-5 && mouseX<x-10+textWidth(story.getUrl()) && mouseY<urlHeightOffset+15)
              link(story.getUrl());
          } else if (!urlLengthOverMaxChecker() && mouseX>x-10 && mouseY>urlHeightOffset+height && mouseX<x-10+textWidth(story.getUrl()) && mouseY<urlHeightOffset+height+10)
            link(story.getUrl());
          else if (mouseX>x-10 && mouseY>urlHeightOffset-5+height && mouseX<x-10+textWidth(story.getUrl()) && mouseY<urlHeightOffset+height+15)
            link(story.getUrl());
          //println("Hit this");
          return true;
        } else return true;
      }
      if (canOpenWidget && mouseY>displayHeight/6)
      {
        if (!widgetOpened) openWidget();
        else if (widgetOpened) closeWidget();
      }
    }
    return false;
  }


  int getEvent(int mX, int mY) {
    if (mX>x && mX < x+widgetWidth && mY >yPosition&& mY <yPosition+height)
    {
      return event;
    }
    return 0;
  }
  float getYPosition()
  {
    return yPosition;
  }
  void changeYPosition(float yChange)
  {
    yPosition-= 20*yChange;
  }

  void setYPosition(float y)
  {
    yPosition = y;
  }

  void setStory(Story story) {
    this.story = story;
  }

  Story getStory()
  {
    return this.story;
  }

  int getEvent()
  {
    if (blueText && yPosition > BANNER_HEIGHT)
    {
      return event;
    }
    return 0;
  }

  float getHeight() {
    if (widgetOpened) {
      return height + openWidgetHeight;
    }
    return height;
  }

  void openWidget() {
    if (!widgetOpened) {
      pieChart = null;
      barChart = null;
      widgetOpened = true;
      for (int i = widgetPosition + 1; i < widget.length; i++) {
        widget[i].setYPosition(widget[i].getYPosition() + openWidgetHeight);
      }
      screen.updateHeight();
      initialiseStories();
    }
  }

  void closeWidget() {
    if (widgetOpened) {
      widgetOpened = false;
      for (int i = widgetPosition + 1; i < widget.length; i++) {
        widget[i].setYPosition(widget[i].getYPosition() - openWidgetHeight);
      }
      screen.updateHeight();
    }
  }

  synchronized void initialiseStories() {
    Thread initialiseStories = new Thread(new Runnable() {
      public void run() {
        try {
          story.initialiseSubComments(database);
          int maxNumComments = 19;
          pieChart = new PieChart(x + (widgetWidth/5), -100, widgetWidth / 5, widgetWidth / 5, "User Comments on Story: Top "+(maxNumComments + 1), color(255), story, maxNumComments);
          barChart = new BarChart(x + (widgetWidth/2), -100, (2 * widgetWidth) / 5, widgetWidth / 5, "User Comments on Story", color(255), story);
        }
        catch(SQLException e) {
          e.printStackTrace();
        }
      }
    }
    );
    initialiseStories.start();
  }
}
