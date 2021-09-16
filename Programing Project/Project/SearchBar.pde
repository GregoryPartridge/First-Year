/*
This class was created and maintained by Eoin Pinaqui.
 This class is used to create and draw the search bar and store the search label. The functionality of the search bar was written by Lexes Mantiquilla and can be found in Project.pde
 */

class SearchBar extends Widget
{
  private PFont searchFont;
  boolean isClicked;
  String toDisplay;

  SearchBar(float width, float height, int x, int y, color searchBarColor, int event, String search, PFont searchFont)
  { 
    super(x, y, width, height, search, searchBarColor, event);
    this.searchFont = searchFont;
    isClicked = false;
    toDisplay = label;
  }

  void draw()
  {
    if (label.length () > 14)
    {
      toDisplay = "...";
      toDisplay += label.substring(label.length() - 14, label.length());
    } else
    {
      toDisplay = label;
    }
    float searchBarPosition = HOW_FAR_DOWN_IS_SEARCH_BAR * (displayHeight/6);
    textFont(searchFont);
    fill(widgetColor);
    textAlign(LEFT, CENTER);
    noStroke();
    rect      (x, searchBarPosition - ((height/2) * SCALE_OF_SEARCH_BAR), width * SCALE_OF_SEARCH_BAR, height * SCALE_OF_SEARCH_BAR);
    ellipse   (x, searchBarPosition, height * SCALE_OF_SEARCH_BAR, height * SCALE_OF_SEARCH_BAR);
    ellipse   (x + (width * SCALE_OF_SEARCH_BAR), searchBarPosition, height * SCALE_OF_SEARCH_BAR, height * SCALE_OF_SEARCH_BAR);    
    stroke    (255);
    line      (x + (height-10)/2, searchBarPosition + (height/4), (x +(height-10)/2 +(4* SCALE_OF_SEARCH_BAR)), (searchBarPosition + (9 * SCALE_OF_SEARCH_BAR)) );  
    ellipse   (x + 2, searchBarPosition, (height/2) * SCALE_OF_SEARCH_BAR, (height/2) * SCALE_OF_SEARCH_BAR);
    fill      (255);
    text      (toDisplay, x + ((height/2)* SCALE_OF_SEARCH_BAR), searchBarPosition);
  }

  color getSearchBarColor()
  {
    return widgetColor;
  }

  String getLabel()
  {
    return label;
  }

  boolean getIsClicked()
  {
    return isClicked;
  }

  int getEvent(int mx, int my)
  {
    if(mx > x-10 && mx < x + width + 10 && my > y && my < y + height)
    {
      return event;
    }
    return 0;
  }

  void searchQuery()
  {
    if (label.equals("Search"))
    {
      label= "";
    }
    isClicked = true;
  }

  void unClick()
  {
    if (label.equals(""))
    {
      label = "Search";
    }
    isClicked = false;
  }

  int getEndX()
  {
    return (int) (x + width);
  }

  int getY()
  {
    return (int) y;
  }
}
