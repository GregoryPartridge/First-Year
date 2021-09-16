import java.awt.event.KeyEvent;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

PFont logo, Search;
PImage search;

int rectWidth;
int index, screenLength;
int currentScreen;
boolean fullyLoaded;
ArrayList<Widget> widgets;
Database database;
Stories allStories;
Banner theBanner;
SearchBar theSearchBar;
Story story;
Screen firstScreen;
DropDownWidget dropDown;
StoryScreen storyScreen1;
boolean isKeyPressed, searchByUser, searchByTitle;
boolean isMouseHeld;
DarkTheme darkTheme;
HomeButton homeButton;
PageDirections nextPage;
PageDirections previousPage;
PieChart pieChart;
LoadingBarWidget loadingBar;
DropDownWidget searchBy;
ExecutorService executor;
HashMap<String, Runnable> threads;
boolean loadNextPage, loadPreviousPage;
int[] previousKeys;
int newColour1;
int newColour2;
int newColour3;
int count;
boolean iHateYouMode;

//Graph graph;

void settings() {
  size(1920, 1080);
  fullScreen();
  search= loadImage("Search-Icon.png");
}

void setup()
{
  loadNextPage = false;
  loadNextPage = false;
  initialiseThreads();
  searchByUser = true;
  searchByTitle = false;
  fullyLoaded = false;
  widgets = new ArrayList();
  screenLength = BANNER_HEIGHT;
  loadingBar = new LoadingBarWidget(0, (displayHeight / 6), displayWidth, 8, "", color(0, 255, 0), 1);
  initialiseDatabase("sgiut.json", "hackerNews", "h2");
  darkTheme = new DarkTheme();
  logo = loadFont("Dialog.bold-30.vlw");
  Search = loadFont("Dubai-Regular-12.vlw");
  theBanner = new Banner(displayWidth, BANNER_HEIGHT, 0, 0, logo, color(255, 123, 4));
  theSearchBar = new SearchBar(125 * SCALE_OF_SEARCH_BAR, 20 * SCALE_OF_SEARCH_BAR, 30, 70, color(206, 95, 4), 1, "Search", Search);
  widgets.add(theSearchBar);
  dropDown = new DropDownWidget(displayWidth - displayWidth/9, theBanner.getHeight() - displayHeight/30, displayWidth/10, displayHeight/30, "Sort By:", color(206, 95, 4), 2, Search);
  dropDown.addOption("Newest", theBanner);
  dropDown.addOption("Oldest", theBanner);
  dropDown.addOption("Most upvoted", theBanner);
  dropDown.addOption("Least upvoted", theBanner);
  dropDown.addOption("Most comments", theBanner);
  dropDown.addOption("Least comments", theBanner);
  currentScreen = 1;
  homeButton = new HomeButton(displayWidth - 60, 10, 50, 50, "Home", color(206, 95, 4), 3, Search);
  previousPage = new PageDirections(displayWidth/2 - displayWidth/10 - 5, theBanner.getHeight()- displayHeight/30, displayWidth/10, displayHeight/30, "Previous Page", color(206, 95, 4), 4, Search);
  nextPage = new PageDirections(displayWidth/2 + 5, theBanner.getHeight() - displayHeight/30, displayWidth/10, displayHeight/30, "Next Page", color(206, 95, 4), 5, Search);
  searchBy = new DropDownWidget(20, theBanner.getHeight() - 70, theSearchBar.getEndX() - 10, displayHeight/50, "Search By:", color(206, 95, 4), 10, Search);
  searchBy.addOption("User", theBanner);
  searchBy.addOption("Story", theBanner);
  initialisePreviousKeys();
  newColour1=0;
  newColour2=0;
  newColour3=0;
  count = 5;
  iHateYouMode=false;
}

void draw()
{
  if(iHateYouMode)
  {
    if(count == 5)
    {
        newColour1 = (int)(Math.random() * 256);
        newColour2 = (int)(Math.random() * 256);
        newColour3 = (int)(Math.random() * 256);
        count=0;
      }
      count++;
      background(newColour1, newColour2, newColour3);
  }
  else
  {
    background(255);
  }
  if (currentScreen == 1)
  {
    for (Widget widget : widgets) {
      widget.draw();
      if (firstScreen!=null) {
        firstScreen.draw();
        fullyLoaded = true;
      }
    }
    if(firstScreen != null && firstScreen.getAnimationFinished() && loadPreviousPage)
    {
      loadPreviousPage();
      loadPreviousPage = false;
      firstScreen.setRightAnimation(false);
      firstScreen.setAnimationFinished(false);
    }
    else if(firstScreen != null && firstScreen.getAnimationFinished() && loadNextPage)
    {
      loadNextPage();
      loadNextPage = false;
      firstScreen.setLeftAnimation(false);
      firstScreen.setAnimationFinished(false);
    }
  } else if (currentScreen == 2)
  {
    //println("Got here");
    storyScreen1.draw();
  }
  theBanner.draw();

  homeButton.draw();
  if (currentScreen == 2)
  {
    textAlign(CENTER, CENTER);
    textFont(storyScreen1.getStoryFont());
    fill(0);
    text(storyScreen1.getHeadline(), storyScreen1.getStoryX(), storyScreen1.getStoryY());
  }

  loadingBar.draw(database.getPercentFinished());
  if (currentScreen == 1)
  {
    theSearchBar.draw();
    searchBy.draw();
    nextPage.draw();
    previousPage.draw();
    dropDown.draw();

  }

  darkTheme.draw();
  if (currentScreen == 1 && isMouseHeld && fullyLoaded) {
    firstScreen.mouseHeld();
  } else if (currentScreen == 2 && isMouseHeld && fullyLoaded)
  {
    storyScreen1.mouseHeld();
  }
}

void mouseDragged() {
  if (fullyLoaded) {
    isMouseHeld = true;
  }
}

void mouseReleased() {
  isMouseHeld = false;
  if (fullyLoaded && currentScreen == 1) {
    firstScreen.getScrollBar().setIsScrollingPressed(false);
  } else if (fullyLoaded && currentScreen == 2)
  {
    storyScreen1.getScrollBar().setIsScrollingPressed(false);
  }
}

void keyTyped() {

  if (theSearchBar.getIsClicked() && key == BACKSPACE)
  {
    if (theSearchBar.label != null && theSearchBar.label.length() > 0)
    {
      theSearchBar.label = theSearchBar.label.substring(0, theSearchBar.label.length() - 1);
    }
    searchDatabase();
  } else if (theSearchBar.getIsClicked())
  {
    if (key != ENTER && key != CONTROL_C) {
      theSearchBar.label += key;
      searchDatabase();
    } else if (key == ENTER) {
      searchDatabase();
    }
  }

  if (fullyLoaded && !theSearchBar.getIsClicked() && !isKeyPressed) {
    if ((key == 'n' || key == 'N') && allStories.getStories().size() == AMOUNT_OF_WIDGETS_ON_SCREEN) {
      firstScreen.setLeftAnimation(true);
      loadNextPage = true;
    }
    if ((key == 'p' || key == 'P') && allStories.getOffset() > 0) {
      firstScreen.setRightAnimation(true);
      loadPreviousPage = true;
    }
  }
  if ((key == 'i' || key == 'I') && !theSearchBar.getIsClicked()) {
    theSearchBar.searchQuery();
  }
  if (key == 'j' || key == 'J' && !theSearchBar.getIsClicked()) {
    if (currentScreen == 1) {
      firstScreen.scrollStories(2);
    } else {
      storyScreen1.scrollStories(2);
    }
  }
  if (key == 'k' || key == 'K' && !theSearchBar.getIsClicked()) {
    if (currentScreen == 1) {
      firstScreen.scrollStories(-2);
    } else {
      storyScreen1.scrollStories(-2);
    }
  }
  if (key == CONTROL_D) {
    if (currentScreen == 1) {
      firstScreen.scrollStories(5);
    } else {
      storyScreen1.scrollStories(5);
    }
  }
  if (key == CONTROL_U) {
    if (currentScreen == 1) {
      firstScreen.scrollStories(-5);
    } else {
      storyScreen1.scrollStories(-5);
    }
  }
  if (key == CONTROL_C && theSearchBar.getIsClicked()) {
    theSearchBar.unClick();
  }
  isKeyPressed = true;
}

void keyPressed() {
  if (keyCode == F5) {
    reloadDatabase();
  }
  insertKey(keyCode);
  if (isKonamiSequence()) {
    //TODO do something
    if (iHateYouMode) {
      iHateYouMode = false;
    } else {
      iHateYouMode = true;
    }

  }
}

void keyReleased() {
  isKeyPressed = false;
}

void mousePressed()
{
  if (currentScreen == 1 && fullyLoaded)
  {
    if (firstScreen.mouseClicked())
    {
      for (int i = 0; i < widget.length; i++)
      {
        int event = firstScreen.getWidgets()[i].getEvent();
        if (event != 0)
        {
          storyScreen1 = new StoryScreen(firstScreen.getWidgets()[i].getStory(), 20);
          Thread initialiseComments = new Thread(storyScreen1);
          initialiseComments.start();
          currentScreen = 2;
        }
      }
    }

  }

 if (!darkThemeChangingAnimation && mouseX > (14 * displayWidth)/15 -( displayHeight/60) && mouseX < (14 * displayWidth)/15 + displayHeight/20 + (displayHeight/60) && mouseY > (14 * displayHeight)/15 && mouseY < (14 * displayHeight)/15 + displayHeight/30)
    {
      if (darkThemeOn)
      {
        darkThemeOn=false;
        darkThemeChangingAnimation=true;
      }
      else
      {
        darkThemeOn=true;
        darkThemeChangingAnimation=true;
      }
    }
  int event = -1;

  event = theSearchBar.getEvent(mouseX, mouseY);

  if (event <= 0 && currentScreen == 1)
  {
    event = dropDown.getEvent(mouseX, mouseY);
  }

  if (event <= 0)
  {
    event = homeButton.getEvent(mouseX, mouseY);
  }

  if (currentScreen == 1 && event <= 0)
  {
    event = previousPage.getEvent(mouseX, mouseY);
  }

  if (currentScreen == 1 && event <= 0)
  {
    event = nextPage.getEvent(mouseX, mouseY);
  }

  if (currentScreen == 1 && event <= 0)
  {
    event = searchBy.getEvent(mouseX, mouseY);
  }

  //println(event);

  switch (event)
  {
  case 0:
    theSearchBar.unClick();
    if (dropDown.isOpen())
    {
      int dropEvent = -1;
      ArrayList<RectangleWidget> dropDownWidgets = dropDown.getWidgets();
      int index = 0;
      while (index < dropDownWidgets.size() && dropEvent <= 0)
      {
        if (mouseX >= dropDown.getX())
          dropEvent = dropDownWidgets.get(index).getEvent(mouseX, mouseY);
        index++;
      }
      //println(dropEvent);
      if (dropEvent > 0)
      {
        switch(dropEvent)
        {
        case 3:
          loadByNewest();
          break;
        case 4:
          loadByOldest();
          break;
        case 5:
          loadByMostUpvoted();
          break;
        case 6:
          loadByLeastUpvoted();
          break;
        case 7:
          loadByMostComments();
          break;
        case 8:
          loadByLeastComments();
          break;
        }
      }
    }

    int index = 0;
    int dropEvent = -1;
    while (index < searchBy.getWidgets().size() && dropEvent <= 0)
    {
      dropEvent = searchBy.getWidgets().get(index).getEvent(mouseX, mouseY);
      index++;
    }
    switch(dropEvent)
    {
    case 11:
      searchByUser = true;
      searchByTitle = false;
      break;
    case 12:
      println("Search by title");
      searchByTitle = true;
      searchByUser = false;
      break;
    }
    dropDown.closeMenu();
    searchBy.closeMenu();
    break;
  case 1:
    theSearchBar.searchQuery();
    dropDown.closeMenu();
    break;
  case 2:
    theSearchBar.unClick();
    if (dropDown.isOpen())
    {
      dropDown.closeMenu();
    } else {
      dropDown.open();
    }
    break;
  case 3:
    dropDown.closeMenu();
    theSearchBar.unClick();
    if(currentScreen == 2)
    {
    currentScreen = 1;
    }
    else
    {
      theSearchBar.label = "";
      searchDatabase();
    }

    firstScreen.updateHeight();
    firstScreen.resetScrollBar();
    break;
  case 4:
    dropDown.closeMenu();
    theSearchBar.unClick();
    if (allStories.getOffset() > 0)
    {
      firstScreen.setRightAnimation(true);
      loadPreviousPage = true;
    }
    break;
  case 5:
    dropDown.closeMenu();
    theSearchBar.unClick();
    if (allStories.getStories().size() == AMOUNT_OF_WIDGETS_ON_SCREEN)
    {
      firstScreen.setLeftAnimation(true);
      loadNextPage = true;
    }
    break;
  case 10:
    println("Clicked");
    dropDown.closeMenu();
    theSearchBar.unClick();
    if (searchBy.isOpen())
    {
      searchBy.closeMenu();
    } else
    {
      searchBy.open();
    }
  }
  if (fullyLoaded && currentScreen == 1)
  {
    firstScreen.mousePressed();
  } else if (fullyLoaded && currentScreen == 2)
  {
    storyScreen1.mousePressed();
  }
}

void mouseWheel(MouseEvent event) {
  scrollLevel = event.getCount();
  switch(currentScreen)
  {
  case 1:
    if (fullyLoaded)
    {
      firstScreen.scrollStories(scrollLevel);
    }
    break;
  case 2:
    storyScreen1.scrollStories(scrollLevel);
    break;
  }
}

synchronized void loadNextPage() {
  executor.execute(threads.get("loadNextPage"));
}

synchronized void loadPreviousPage() {
  executor.execute(threads.get("loadPreviousPage"));
}

synchronized void loadByNewest() {
  executor.execute(threads.get("loadByNewest"));
}

synchronized void loadByOldest() {
  executor.execute(threads.get("loadByOldest"));
}

synchronized void loadByMostUpvoted() {
  executor.execute(threads.get("loadByMostUpvoted"));
}

synchronized void loadByLeastUpvoted() {
  executor.execute(threads.get("loadByLeastUpvoted"));
}

synchronized void loadByMostComments() {
  executor.execute(threads.get("loadByMostComments"));
}

synchronized void loadByLeastComments() {
  executor.execute(threads.get("loadByLeastComments"));
}

void reloadDatabase() {
  executor.execute(threads.get("reloadDatabase"));
}

void searchDatabaseByClick() {
  executor.execute(threads.get("searchDatabaseByClick"));
}

synchronized void refreshPage() {
  firstScreen.updateStories();
  firstScreen.resetScrollBar();
  firstScreen.updateHeight();
}

void initialiseDatabase(String fileLocation, String databaseName, String databaseType) {
  database = new Database(fileLocation, databaseName, databaseType);
  executor.execute(threads.get("initialiseDatabase"));
}

synchronized void searchDatabase() {
  executor.execute(threads.get("searchDatabase"));
}

void initialiseThreads() {
  executor = Executors.newSingleThreadExecutor();
  threads = new HashMap();
  Runnable loadNextPage = new Runnable() {
    public void run() {
      try {
        allStories.loadNextStories();
        refreshPage();
      }
      catch (SQLException e) {
        e.printStackTrace();
      }
    }
  };
  Runnable loadPreviousPage = new Runnable() {
    public void run() {
      try {
        allStories.loadPreviousStories();
        refreshPage();
      }
      catch (SQLException e) {
        e.printStackTrace();
      }
    }
  };
  Runnable loadByNewest = new Runnable() {
    public void run() {
      try {
        allStories.loadByNewest();
        refreshPage();
      }
      catch (SQLException e) {
        e.printStackTrace();
      }
    }
  };
  Runnable loadByOldest = new Runnable() {
    public void run() {
      try {
        allStories.loadByOldest();
        refreshPage();
      }
      catch (SQLException e) {
        e.printStackTrace();
      }
    }
  };
  Runnable loadByMostUpvoted = new Runnable() {
    public void run() {
      try {
        allStories.loadByMostUpvoted();
        refreshPage();
      }
      catch (SQLException e) {
        e.printStackTrace();
      }
    }
  };
  Runnable loadByLeastUpvoted = new Runnable() {
    public void run() {
      try {
        allStories.loadByLeastUpvoted();
        refreshPage();
      }
      catch (SQLException e) {
        e.printStackTrace();
      }
    }
  };
  Runnable loadByMostComments = new Runnable() {
    public void run() {
      try {
        allStories.loadByMostComments();
        refreshPage();
      }
      catch (SQLException e) {
        e.printStackTrace();
      }
    }
  };
  Runnable loadByLeastComments = new Runnable() {
    public void run() {
      try {
        allStories.loadByLeastComments();
        refreshPage();
      }
      catch (SQLException e) {
        e.printStackTrace();
      }
    }
  };
  Runnable reloadDatabase = new Runnable() {
    public void run() {
      try {
        database.readFile();
        allStories.setOffset(0);
        allStories.queryDatabase();
        refreshPage();
      }
      catch (SQLException e) {
        e.printStackTrace();
      }
    }
  };
  Runnable initialiseDatabase = new Runnable() {
    public void run() {
      try {
        database.initialiseConnection();
        if ("h2".equals(database.getDatabaseType())) {
          File file = new File(dataPath("h2/true"));
          if (!file.exists()) {
            database.readFile();
            file.createNewFile();
          }
        } else if ("mysql".equals(database.getDatabaseType())) {
          File file = new File(dataPath("mysql/true"));
          if (!file.exists()) {
            database.readFile();
            file.getParentFile().mkdir();
            file.createNewFile();
          }
        }
        long startTime = System.currentTimeMillis();
        allStories = new Stories(database);
        long endTime = System.currentTimeMillis();
        println("Finished adding to ArrayList in " + (endTime - startTime) + " milliseconds");
        firstScreen = new Screen();
      }
      catch (SQLException e) {
        e.printStackTrace();
        println("The database is corrupt. Rebuilding...");
        try {
          database.delete();
        }
        catch(IOException exception) {
          exception.printStackTrace();
        }
        initialiseDatabase(database.getFileName(), database.getDatabaseName(), database.getDatabaseType());
      }
      catch (IOException e) {
        e.printStackTrace();
      }
    }
  };
  Runnable searchDatabase = new Runnable() {
    public void run() {
      try {
        if (searchByUser)
        {
          allStories.searchByUser(theSearchBar.label);
          refreshPage();
        } else if (searchByTitle)
        {
          allStories.searchByTitle(theSearchBar.label);
          refreshPage();
        }
      }
      catch(SQLException e) {
        e.printStackTrace();
      }
    }
  };
  Runnable searchDatabaseByClick = new Runnable() {
    public void run() {
      try {
        allStories.searchByUser(firstScreen.userToSearch);
        refreshPage();
      }
      catch(SQLException e) {
        e.printStackTrace();
      }
    }
  };
  threads.put("loadNextPage", loadNextPage);
  threads.put("loadPreviousPage", loadPreviousPage);
  threads.put("loadByNewest", loadByNewest);
  threads.put("loadByOldest", loadByOldest);
  threads.put("loadByMostUpvoted", loadByMostUpvoted);
  threads.put("loadByLeastUpvoted", loadByLeastUpvoted);
  threads.put("loadByMostComments", loadByMostComments);
  threads.put("loadByLeastComments", loadByLeastComments);
  threads.put("reloadDatabase", reloadDatabase);
  threads.put("initialiseDatabase", initialiseDatabase);
  threads.put("searchDatabase", searchDatabase);
  threads.put("searchDatabaseByClick", searchDatabaseByClick);
}

void initialisePreviousKeys() {
  previousKeys = new int[NUM_KEYS_FOR_KONAMI_CODE];
  for (int i = 0; i < previousKeys.length; i++) {
    previousKeys[i] = 0;
  }
}

void insertKey(int key) {
  int lastIndex = previousKeys.length - 1;
  for (int i = 1; i < previousKeys.length; i++) {
    previousKeys[i - 1] = previousKeys[i];
  }
  previousKeys[lastIndex] = key;
}

boolean isKonamiSequence() {
  boolean isKonamiSequence = true;
  if (previousKeys.length >= NUM_KEYS_FOR_KONAMI_CODE) {
    for (int i = 0; i < konamiCode.length; i++) {
      if (konamiCode[i] != previousKeys[i]) {
        isKonamiSequence = false;
      }
    }
    return isKonamiSequence;
  }
  return false;
}
