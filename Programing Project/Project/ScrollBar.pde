/**
  * Widget which allows to scroll the stories/comments on the screen.
  * ----------------------------------------------------------------------------
  *
  * Maintained by Lexes Mantiquilla
  */
class ScrollBar extends Widget {
  private float scrollerY;
  private float percentScrolled;
  private float speed;
  private float topOfBar;
  private float bottomOfBar;
  private int scrollerHeight;
  private boolean isScrollingPressed;
  private boolean isAbleToScroll;

  /**
    * Constructs a ScollBar object and initialises the instance variables using
    * the parameters passed.
    */
  ScrollBar(int x, int y, int width, int height, int scrollerHeight, float speed) {
    super(x, y, width, height, "", 255, 0);
    scrollerY = this.y + scrollerHeight / 2;
    percentScrolled = 0;
    this.speed = speed;
    topOfBar = this.y;
    bottomOfBar = this.y + height;
    isScrollingPressed = false;
    this.scrollerHeight = scrollerHeight;
  }

  /** Draws scroll bar background and the scroller. */
  void draw() {
    noStroke();
    fill(225);
    rect(x, y, width, height);
    fill(190);
    if (isAbleToScroll) {
      if (isScrollingPressed) {
        rect(x, scrollerY - scrollerHeight / 2, width, scrollerHeight);
      } else {
        rect(x + width / 4, scrollerY - scrollerHeight / 2, width / 2, scrollerHeight);
      }
    }
  }

  /**
    * Moves the scroll bar scroller on the if the mouse is on top of the
    * scroller.
    */
  void move(int mouseX, int mouseY) {
    if (mouseX >= x && mouseX <= x + width && isAbleToScroll) {
      move(mouseY);
      isScrollingPressed = true;
    }
  }

  /**
    * Moves the scroll bar scroller regardless if the mouse is on top of the
    * scroller. Used when moving the scroller while the mouse is held.
    */
  void move(float y) {
    if (isAbleToScroll) {
      float distanceBetweenScrollerAndY = y - scrollerY;
      float upperLimit = topOfBar + scrollerHeight / 2;
      float lowerLimit = bottomOfBar - scrollerHeight / 2;
      if (y >= upperLimit && y <= lowerLimit && distanceBetweenScrollerAndY != 0) {
        scrollerY += distanceBetweenScrollerAndY;
      } else if (y <= upperLimit) {
        scrollerY = upperLimit;
      } else if (y >= lowerLimit) {
        scrollerY = lowerLimit;
      }
      percentScrolled = (float) (scrollerY - this.y - scrollerHeight / 2) / (height - scrollerHeight);
    }
  }

  float getScrollerY() {
    return scrollerY;
  }

  float getPercentScrolled() {
    return percentScrolled;
  }

  float getTopOfBar() {
    return topOfBar;
  }

  boolean getIsScrollingPressed() {
    return isScrollingPressed;
  }

  void setIsScrollingPressed(boolean isScrollingPressed) {
    this.isScrollingPressed = isScrollingPressed;
  }

  void setIsAbleToScroll(boolean isAbleToScroll) {
    this.isAbleToScroll = isAbleToScroll;
  }

  boolean getIsAbleToScroll() {
    return isAbleToScroll;
  }
}
