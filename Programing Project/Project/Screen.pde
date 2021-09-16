StoryWidget[] widget;
Stories allScreenStories;
float scrollLevel;
int maxScrollDistance;
int currentPosition;
float verticalOffsetOfWidgets;


class Screen {
  boolean startLeftAnimation, startRightAnimation, endLeftAnimation, endRightAnimation, animationFinished;
  private float x, y, startingY, width, height, hiddenScreenHeight;
  int finalX;
  private ScrollBar scrollBar;
  int backgroundColour;
  String userToSearch;
  Screen() {
    endLeftAnimation = false;
    endRightAnimation = false;
    animationFinished = false;
    startLeftAnimation = false;
    startRightAnimation = false;
    finalX = -widgetWidth;
    verticalOffsetOfWidgets = 0;
    int scrollBarWidth = 13;
    scrollBar = new ScrollBar(displayWidth - scrollBarWidth, displayHeight / 6, scrollBarWidth, displayHeight-(displayHeight / 6), 60, 2);
    widget = new StoryWidget[AMOUNT_OF_WIDGETS_ON_SCREEN];
    backgroundColour = 100;
    maxScrollDistance=150;
    for (int i=0; i<AMOUNT_OF_WIDGETS_ON_SCREEN; i++)
    {
      if (i-1>0 && widget[i-1]!=null && widget[i-1].titleLengthOverMaxChecker())
      {
        widget[i]=new StoryWidget(50, (displayWidth/6)/2 +50+(2*VERTICAL_OFFSET_BETWEEN_WIDGETS*i), 600, 50, "Green", color(225), 1, "just text", i, allStories.getStories().get(i), this, database);
        maxScrollDistance += (2*VERTICAL_OFFSET_BETWEEN_WIDGETS+100) + 250;
        } else {
          widget[i]=new StoryWidget(50, (displayWidth/6)/2 +50+(VERTICAL_OFFSET_BETWEEN_WIDGETS*i), 600, 50, "Green", color(225), 1, "just text", i, allStories.getStories().get(i), this, database);
          maxScrollDistance += (VERTICAL_OFFSET_BETWEEN_WIDGETS+50) + 250;
        }
      }
      x = 0;
      y = widget[0].getYPosition();
      width = displayWidth;
      startingY = y;
      updateHeight();
      resetScrollBar();
      println(maxScrollDistance);
      //maxScrollDistance = (VERTICAL_OFFSET_BETWEEN_WIDGETS*AMOUNT_OF_WIDGETS_ON_SCREEN)+(AMOUNT_OF_WIDGETS_ON_SCREEN*50/*Thickness of Each Widget*/);
    }
    
    /*
    This function is used to draw the story widgets on the main screen
    When the directional arrows are clicked, the story widgets are animated to swipe off of the screen. This was done by Eoin Pinaqui
    */
    void draw() {
      for (int i = 0; i< widget.length; i++) {
        mouseMoved();
        widget[i].draw();
        stroke(0);
        if(startLeftAnimation && widget[i].getX() >= widget[i].getFinalX())
        {
          widget[i].decreaseX();
        }
        else if(startRightAnimation && widget[i].getX() <= displayWidth)
        {
          widget[i].increaseX();
        }
        else if(widget[i].getX() < widget[i].getFinalX())
        {
          animationFinished = true;
          endLeftAnimation = true;
          widget[i].setX(displayWidth);
        }
        else if(widget[i].getX() > displayWidth)
        {
          animationFinished = true;
          endRightAnimation = true;
          widget[i].setX(widget[i].getFinalX());
        }
        else if(endLeftAnimation && widget[i].getX() > widget[i].getOriginalX())
        {
          widget[i].decreaseX();
          if(widget[i].getX() < widget[i].getOriginalX())
          {
            widget[i].restoreX();
            endLeftAnimation = false;
            endRightAnimation = false;
            animationFinished = false;
            startLeftAnimation = false;
            startRightAnimation = false;
          }
        }
        else if(endRightAnimation && widget[i].getX() < widget[i].getOriginalX())
        {
          widget[i].increaseX();
          if(widget[i].getX() > widget[i].getOriginalX())
          {
            widget[i].restoreX();
            endLeftAnimation = false;
            endRightAnimation = false;
            animationFinished = false;
            startLeftAnimation = false;
            startRightAnimation = false;
          }
        }
        else
        {
           widget[i].restoreX();
            endLeftAnimation = false;
            endRightAnimation = false;
            animationFinished = false;
            startLeftAnimation = false;
            startRightAnimation = false;
        }
      }
      scrollBar.draw();
    }

  boolean getAnimationFinished()
  {
    return animationFinished;
  }

  void setAnimationFinished(boolean set)
  {
    animationFinished = set;
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
  void setLeftAnimation(boolean set)
  {
    this.startLeftAnimation = set;
  }

  void setRightAnimation(boolean set)
  {
    this.startRightAnimation = set;
  }
  void scrollStories(float scrollLevel) {
    scrollBar.move(scrollBar.getScrollerY() + scrollLevel * 20);
    updateYAxis(startingY + hiddenScreenHeight * scrollBar.getPercentScrolled());

    // if ((widget[AMOUNT_OF_WIDGETS_ON_SCREEN - 1].getYPosition() >= displayHeight - 100) && (widget[0].getYPosition() <= 150))
    // {
    //   println(scrollLevel);
    //   for (int i = 0; i < widget.length; i++)
    //   {
    //     widget[i].changeYPosition(scrollLevel);
    //   }
    //   newScroll.moveBar((map(scrollLevel, 140, displayHeight-30, 150, maxScrollDistance)-widget[0].getYPosition())/20);
    // } else if ((widget[AMOUNT_OF_WIDGETS_ON_SCREEN-1].getYPosition()<displayHeight-100)) {
    //   for (int i = 0; i<(widget.length); i++) {
    //     widget[i].changeYPosition(-1);
    //   }
    // } else if ((widget[0].getYPosition()>200)) {
    //   for (int i = 0; i<(widget.length); i++) {
    //     widget[i].changeYPosition(1);
    //   }
    // } else if (widget[AMOUNT_OF_WIDGETS_ON_SCREEN - 1].getYPosition() <= displayHeight - 100 && scrollLevel <0)
    // {
    //   for (int i = 0; i < widget.length; i++)
    //   {
    //     widget[i].changeYPosition(scrollLevel);
    //   }
    //   newScroll.moveBar((map(scrollLevel, 140, displayHeight-30, 150, maxScrollDistance)-widget[0].getYPosition())/20);
    // } else if (widget[0].getYPosition() >= 150 && scrollLevel >0)
    // {
    //   for (int i = 0; i < widget.length; i++)
    //   {
    //     widget[i].changeYPosition(scrollLevel);
    //   }
    //   newScroll.moveBar((map(scrollLevel, 140, displayHeight-30, 150, maxScrollDistance)-widget[0].getYPosition())/20);
    // }
  }

  boolean mouseClicked() {
    boolean clicked = false;
    boolean perm = false;
    for (int i = 0; i<(widget.length); i++) {
      mouseMoved();
      clicked = widget[i].mousePressed();
      stroke(0);
      if (clicked)
      {
        perm = clicked;
      }
    }
    return perm;
  }

  void updateStories() {
    ArrayList<Story> stories = allStories.getStories();
    for (int i = 0; i < widget.length && i < stories.size(); i++) {
      widget[i].setStory(stories.get(i));
      widget[i].linkClickedOn=false;
      widget[i].closeWidget();
    }
    if (stories.size() < widget.length) {
      for (int i = stories.size(); i < widget.length; i++) {
        widget[i].setStory(null);
      }
    }
  }

  StoryWidget[] getWidgets()
  {
    return widget;
  }

  void updateYAxis(float newY) {
    for (int i = 0; i < widget.length; i++) {
      widget[i].setYPosition(widget[i].getYPosition() - (newY - this.y));
    }
    this.y = newY;
  }

  void updateHeight() {
    int lastStoryIndex = 0;
    boolean finished = false;
    for (int i = 0; i < widget.length && !finished; i++) {
      if (widget[i].getStory() != null) {
        lastStoryIndex = i;
      } else {
        if (i != 0) {
          lastStoryIndex = i - 1;
        }
        finished = true;
      }
    }
    height = widget[lastStoryIndex].getYPosition() + widget[lastStoryIndex].getHeight() - widget[0].getYPosition() + widget[0].height;
    hiddenScreenHeight = height - (displayHeight - (displayHeight / 6));
    if (hiddenScreenHeight > 0) {
      scrollBar.setIsAbleToScroll(true);
    } else {
      scrollBar.setIsAbleToScroll(false);
    }
  }

  void resetScrollBar() {
    scrollBar.move(scrollBar.getTopOfBar());
    updateYAxis(startingY + hiddenScreenHeight * scrollBar.getPercentScrolled());
  }

  ScrollBar getScrollBar() {
    return scrollBar;
  }
}
