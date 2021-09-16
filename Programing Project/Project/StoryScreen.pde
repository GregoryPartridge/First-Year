/*
This class was created by Eoin Pinaqui, but was maintained by Eoin Pinaqui and Conall Tuohy.
 This class is used to create the screen with that displays the comments of a story
 */


class StoryScreen implements Runnable
{
  private PFont   urlFont, storyFont;
  private float x, comment0Y, startingY, width, height, hiddenScreenHeight;
  Story theStory;
  int commentsX;
  int headlineX;
  int headlineY;
  ArrayList<Comment> storyComments;
  int maxPossibleCommentLength;
  int commentOverlapAmount;
  String commentLine;
  int previousCommentLineCounter;
  int positionOfNearestSpace2;
  ScrollBar scrollBar;
  int gapBetweenComments;
  int newY;


  StoryScreen(Story theStory, int commentsX)
  {
    storyFont = loadFont("Dubai-Regular-18.vlw");
    urlFont = loadFont("ArialMT-16.vlw");
    this.theStory = theStory;
    this.commentsX = commentsX;
    this.headlineX = displayWidth / 2;
    this.headlineY = theBanner.getHeight() - displayWidth/100;
    maxPossibleCommentLength = round(displayWidth/(15));
    //println(maxPossibleCommentLength);
    commentOverlapAmount=40;
    scrollBar = new ScrollBar(displayWidth - 12, displayHeight / 6, 12, displayHeight-(displayHeight / 6), 60, 2);
    x = 0;
    comment0Y = headlineY + 100;
    width = displayWidth;
    startingY = comment0Y;
    gapBetweenComments = 20;
    textFont(urlFont);
    newY = (int) startingY;
  }


  void draw()
  {
    textAlign(LEFT, TOP);
    textFont(storyFont);
    fill(0);

    //text(theStory.getTitle(), commentsX, headlineY);
    if (storyComments != null) {
      commentOverlapAmount+=20;
    }
    textFont(urlFont);
    scrollBar.draw();
    fill(0);
    for (int i = 0; storyComments != null && i <storyComments.size(); i++)
    {
      if ((storyComments.get(i).getY() + (storyComments.get(i).getNumberOfLines()+1)*(textAscent()+textDescent()+5) +5 )>theBanner.getHeight() && storyComments.get(i).getY()<displayHeight) {
        //rect(commentsX + 20, comment0Y, 50, storyComments.get(0).getNumberOfLines()*(textAscent() + textDescent() + 6));
        fill(215);
        rect(commentsX-5, storyComments.get(i).getY()-5, maxPossibleCommentLength*10, ((storyComments.get(i).getNumberOfLines()+1)*(textAscent()+textDescent()+5) +5 ), 10);
        fill(0);
        text((i+1) + ") " +storyComments.get(i).getBy()+ "\n \t"+storyComments.get(i).getText(), commentsX, storyComments.get(i).getY());
      }
      if (storyComments.get(i).getSubComments()!=null && storyComments.get(i).getSubComments().getComments().size() > 0)
      {
        ArrayList<Comment> firstSubComments = storyComments.get(i).getSubComments().getCommentsSortedByTime();
        for (int j = 0; j < storyComments.get(i).getSubComments().getComments().size(); j++)
        {
          if ((firstSubComments.get(j).getY() + (firstSubComments.get(j).getNumberOfLines()+1)*(textAscent()+textDescent()+5) +5 )>theBanner.getHeight() && firstSubComments.get(j).getY()<displayHeight) {
            fill(225);
            rect(commentsX + 50 -5, firstSubComments.get(j).getY() -5, maxPossibleCommentLength*10, ((firstSubComments.get(j).getNumberOfLines()+1)*(textAscent()+textDescent()+5) +5 ), 10);
            fill(0);
            text((i+1) + " - " + (j+1) +") " +firstSubComments.get(j).getBy()+  storyComments.get(i).getBy()+"\n \t" +firstSubComments.get(j).getText(), commentsX + 50, firstSubComments.get(j).getY());
          }
          //if (firstSubComments.get(j).getSubComments()!=null && firstSubComments.get(j).getSubComments().getComments().size() > 0)
          //{
          //  ArrayList<Comment> secondSubComments = firstSubComments.get(j).getSubComments().getCommentsSortedByTime();
          //  for (int k = 0; k < secondSubComments.size(); k++)
          //  {
          //    text(i +") " +secondSubComments.get(k).getBy()+ "\n \t" +secondSubComments.get(k).getText(), commentsX + 100, secondSubComments.get(k).getY());
          //  }
          //}
        }
        if (i!= storyComments.size()-1 && storyComments.get(i).getSubComments() != null) {
          fill(225);
          rect(commentsX + 25, storyComments.get(i).getY() + ((storyComments.get(i).getNumberOfLines()+1)*(textAscent()+textDescent()+5) +5), 5, storyComments.get(i+1).getY()-15, 2.5);
        } else {
          fill(225);
          rect(commentsX + 25, storyComments.get(i).getY() + 10, 5, 500, 2.5);
        }
      }
    }
    if (storyComments!= null)
      text("Whats up ;)", 20, storyComments.get(storyComments.size() - 1).getY() + ((storyComments.get(storyComments.size() - 1).getNumberOfLines() + 1)*(textAscent() + textDescent() + 5) + 5));

    if (storyComments == null || storyComments.size() == 0)
    {
      textAlign(CENTER, CENTER);
      // text("This story has no comments :(", displayWidth/2, displayHeight/2);
    }
  }


  //String foundLink(String currentComment)
  //{
  //  //println("Hit here");
  //  int startPositionOfUrl = currentComment.indexOf("<a href=");
  //  if (startPositionOfUrl!=-1) {
  //    int endPositionOfUrl = currentComment.indexOf("</a>");
  //    if (endPositionOfUrl!=-1) {
  //      String beforeUrl = currentComment.substring(0, startPositionOfUrl);
  //      String afterUrl = currentComment.substring(endPositionOfUrl, currentComment.length());
  //      String badUrl = currentComment.substring(startPositionOfUrl, endPositionOfUrl);
  //      //String url = badUrl.substring(currentComment.indexOf("\"")-1, currentComment.indexOf("\""));
  //      //println(beforeUrl + ": Is before" );
  //      //println( afterUrl + ": Is after" );
  //      //println(      url + ": Is full url" );
  //      //currentComment = beforeUrl + url + afterUrl;
  //      return currentComment;
  //    } else return currentComment;
  //  } else return currentComment;
  //}


  //The next few functions are used for the functionaloty of the search bar. These are the same ones found in Screen.pde
  void updateYAxis(float newY) {
    for (int i = 0; storyComments != null && i < storyComments.size(); i++) {
      storyComments.get(i).setY(storyComments.get(i).getY() - (newY - this.comment0Y));
      if (storyComments.get(i).getSubComments()!=null && storyComments.get(i).getSubComments().getComments().size() > 0)
      {
        for (int j = 0; j < storyComments.get(i).getSubComments().getComments().size(); j++)
        {
          storyComments.get(i).getSubComments().getComments().get(j).setY(storyComments.get(i).getSubComments().getComments().get(j).getY() - (newY - this.comment0Y));
        }
      }
    }
    this.comment0Y = newY;
  }

  void updateHeight() {
    int lastCommentIndex = 0;
    boolean finished = false;
    if (storyComments!= null) {
      for (int i = 0; i < storyComments.size() && !finished; i++) {
        if (storyComments.get(i) != null) {
          lastCommentIndex = i;
        } else {
          if (i != 0) {
            lastCommentIndex = i - 1;
          }
          finished = true;
        }
        // println(lastCommentIndex);
      }
      // println( storyComments.get(storyComments.size() - 1).getY());
      if (storyComments.size() != 0) {
        height = storyComments.get(storyComments.size() - 1).getY() + ((storyComments.get(storyComments.size() - 1).getNumberOfLines() + 1)*(textAscent() + textDescent() + 5) + 5) - theBanner.getHeight();
      }
      // println(height);
      hiddenScreenHeight = 20 + height - (displayHeight - (displayHeight / 6));
      // println(hiddenScreenHeight);
      if (hiddenScreenHeight > 0) {
        scrollBar.setIsAbleToScroll(true);
      } else {
        scrollBar.setIsAbleToScroll(false);
      }
    }
  }

  void resetScrollBar() {
    scrollBar.move(scrollBar.getTopOfBar());
    updateYAxis(startingY + hiddenScreenHeight * scrollBar.getPercentScrolled());
  }

  ScrollBar getScrollBar() {
    return scrollBar;
  }

  void scrollStories(float scrollLevel) {
    scrollBar.move(scrollBar.getScrollerY() + scrollLevel * 20);
    updateYAxis(startingY + hiddenScreenHeight * scrollBar.getPercentScrolled());
  }

  void mousePressed() {
    scrollBar.move(mouseX, mouseY);
    updateYAxis(startingY + hiddenScreenHeight * scrollBar.getPercentScrolled());
  }

  void mouseHeld() {
    if (scrollBar.getIsScrollingPressed()) {
      scrollBar.move(mouseY);
      updateYAxis(startingY + hiddenScreenHeight * scrollBar.getPercentScrolled());
    }
  }


  /*
This function formats the text of the comments to go to new lines instead of continuing off the screen.
   It also sets a global variable for what the next comments y value should be
   */
  String commentFormatter(String currentComment)
  {
    int lineCounter = 1;
    if (currentComment.length() > maxPossibleCommentLength)
    {
      int indexOfChar = 0;
      int counter = 0;
      while (indexOfChar < currentComment.length())
      {
        if (currentComment.charAt(indexOfChar) == '\n')
        {
          lineCounter++;
          counter = 0;
        }

        if (counter >= maxPossibleCommentLength && currentComment.charAt(indexOfChar) == ' ')
        {
          char[] charArray = currentComment.toCharArray();
          charArray[indexOfChar] = '\n';
          currentComment = new String(charArray);
          lineCounter++;
          counter = 0;
        }
        counter++;
        indexOfChar++;
      }
    }

    previousCommentLineCounter = lineCounter;
    return currentComment;
  }



  String getHeadline()
  {
    return theStory.getTitle();
  }

  PFont getStoryFont()
  {
    return storyFont;
  }

  int getStoryX()
  {
    return headlineX;
  }

  int getStoryY()
  {
    return headlineY;
  }

  /*
This function goes through each comment, and the replies to these comments and calls the commentFormatter() function for them.
It also sets the y value for the comments and updates the height of the scroll bar
   */
  void run() {

    try {
      theStory.initialiseSubComments(database);
      if (theStory.getComments().getCommentsSortedByTime().size() != 0)
      {
        this.storyComments = theStory.getComments().getCommentsSortedByTime();
        storyComments.get(0).setY(newY);
        storyComments.get(0).setText(commentFormatter(storyComments.get(0).getText()));
        storyComments.get(0).setNumberOfLines(previousCommentLineCounter);
        newY = (int) (storyComments.get(0).getY() + (previousCommentLineCounter + 1)*(textAscent()+textDescent()+5) +15);
        if (storyComments.get(0).getSubComments()!=null && storyComments.get(0).getSubComments().getComments().size() > 0)
        {
          ArrayList<Comment> firstSubComments = storyComments.get(0).getSubComments().getCommentsSortedByTime();
          println("0th comment amout of subcomments: " + firstSubComments.size());
          firstSubComments.get(0).setY(newY);
          firstSubComments.get(0).setText(commentFormatter(firstSubComments.get(0).getText()));
          firstSubComments.get(0).setNumberOfLines(previousCommentLineCounter);
          newY = (int) (firstSubComments.get(0).getY() + (previousCommentLineCounter + 1)*(textAscent()+textDescent()+5) +15);

          for (int j = 1; j < firstSubComments.size(); j ++)
          {
            firstSubComments.get(j).setY(newY);
            firstSubComments.get(j).setText(commentFormatter(firstSubComments.get(j).getText()));
            firstSubComments.get(j).setNumberOfLines(previousCommentLineCounter);
            newY = (int) (firstSubComments.get(j).getY() + (previousCommentLineCounter + 1)*(textAscent()+textDescent()+5) +15);
          }
        }


        for (int i = 1; i < storyComments.size(); i ++)
        {
          storyComments.get(i).setY(newY);
          storyComments.get(i).setText(commentFormatter(storyComments.get(i).getText()));
          storyComments.get(i).setNumberOfLines(previousCommentLineCounter);
          newY = (int) (storyComments.get(i).getY() + (previousCommentLineCounter+1)*(textAscent()+textDescent()+5)+15);

          if (storyComments.get(i).getSubComments()!=null && storyComments.get(i).getSubComments().getComments().size() > 0) {
            ArrayList<Comment> firstSubComments = storyComments.get(i).getSubComments().getCommentsSortedByTime();
            firstSubComments.get(0).setY(newY);
            firstSubComments.get(0).setText(commentFormatter(firstSubComments.get(0).getText()));
            firstSubComments.get(0).setNumberOfLines(previousCommentLineCounter);
            newY = (int) (firstSubComments.get(0).getY() + (previousCommentLineCounter + 1)*(textAscent()+textDescent()+5) +15);
            for (int j = 1; j < firstSubComments.size(); j ++)
            {
              firstSubComments.get(j).setY(newY);
              firstSubComments.get(j).setText(commentFormatter(firstSubComments.get(j).getText()));
              firstSubComments.get(j).setNumberOfLines(previousCommentLineCounter);
              newY = (int) (firstSubComments.get(j).getY() + (previousCommentLineCounter + 1)*(textAscent()+textDescent()+5) +15);
            }

            //if (firstSubComments.get(j).getSubComments()!=null && firstSubComments.get(j).getSubComments().getComments().size() > 0) {
            //  ArrayList<Comment> secondSubComments = firstSubComments.get(j).getSubComments().getCommentsSortedByTime();
            //  secondSubComments.get(0).setY(newY);
            //  secondSubComments.get(0).setText(commentFormatter(firstSubComments.get(0).getText()));
            //  secondSubComments.get(0).setNumberOfLines(previousCommentLineCounter);
            //  newY = (int) (secondSubComments.get(0).getY() + (previousCommentLineCounter + 1)*(textAscent()+textDescent()+5) +5);

            //  for (int k = 1; k < secondSubComments.size(); k ++)
            //  {
            //    secondSubComments.get(k).setY(newY);
            //    secondSubComments.get(k).setText(commentFormatter(storyComments.get(k).getText()));
            //    secondSubComments.get(k).setNumberOfLines(previousCommentLineCounter);
            //    newY = (int) (secondSubComments.get(k).getY() + (previousCommentLineCounter + 1)*(textAscent()+textDescent()+5) +5);
            //  }
            //  updateHeight();
            //}
          }
        }
      }
      updateHeight();
      resetScrollBar();
    }
    catch(SQLException e) {
      e.printStackTrace();
    }
  }
}
