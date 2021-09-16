# Documentation

## The User Interface

### Displaying the Stories

Most of the work on how the individual stories should look was done by Gregory Partridge and Conall Tuohy but everybody in the group had a say in how they wanted the stories to be displayed. We looked through several different forum-based websites and information displaying techniques and decided on having an individual widget for each story and basing our design off the original Hacker News website (where the stories came from) while also implementing different features from the other websites that we felt were either needed or just wanted.

The main parts of the Story Widget class are taken up by the two different ways to draw the widgets. This is dependant on the size of the  title. If the title is too long to fit, the widget increases in size and gets two lines long. Anything beyond two lines cuts off and is replaced with a “...”. The full title can be seen when you click into the post.

A lot of small optimisations and features were added by Greg Partridge such as the indentation and changing colour of the text when hovered over, and adding the drop-down tab where the graph and bar chart can be seen.

Since we set a limit on the amount of widgets that could be displayed at once we added buttons in the main Project file. The  animations on these stories were added in much later to these buttons by Eoin Pinaqui to try to give a seamless transition from one page to the next.

### Story Screen and Displaying Comments

The story screen class was created by Eoin Pinaqui but was maintained by both Eoin and Conall Tuohy, with some help from the rest of the group. The constructor for this class has a story passed in as a parameter, which is used to get most of the data needed to display the comments.The updateYAxis() and updateHeight() functions are used by the scroll bar to scroll the stories.

The most important functions in this class are the commentFormatter() and the run() functions. The run() function goes through all of the comments, and the replies to those comments and calls the commentFormatter() function for each comment. The commentFormatter() function sets the y values for each comment and also changes the text so that the text of each comment has a number of lines of around the same length. This function also sets a global variable which is equal to the y value for the next comment in the list. Finally, the draw method draws the comments and indents the replies to the comments accordingly.

### Rectangle Widget and Rectangle Widget Subclasses

The RectangleWidget class and all of the subclasses of RectangleWidget were created by Eoin Pinaqui, with some help maintaining these classes from the rest of the group. The subclasses of rectangle widget include DropDownWidget, HomeButton, PageDirections. Each of these classes has an integer called event that is associated with it and uses the getEvent method in the RectangleWidget superclass that is used to implement the functionality of each widget in the main project class.

The DropDownWidget subclass has functions that allow you to add options to the menu, open and close the menu and draw the menu in its open and closed state. When a drop-down menu opens, the opening of the widget is animated.

The HomeButton subclass loads in the home icon image and has a function which draws a square with the icon in it. 

The PageDirections subclass has a string called label, which indicates to the user the functionality of the widget. The draw function in this subclass will draw a rectangle and draws the label in the centre of the rectangle.

### Open Widget

In StoryWidget there is a choice to open the widget showing a pie graph and a bar chart that represent the user comments as  a percentage.

### The Mouse Pressed and Get Event System

The Mouse Pressed function in the main project class was written by everyone in the group. When the mouse is pressed, the function is called. This function will try to get the event integer from each widget on the appropriate screen. If the event integer returned by one of the widgets indicates that the widget has been clicked, the function will enter a switch statement to implement the functionality of the widget that has been clicked. It will also unclick or close any other menus or widgets, such as the search bar and the drop-down menus. This function is quite long, as it has to cope with every widget for two separate screens but is a quite simple implementation structure for a series of homemade widgets on homemade screens.

### ScrollBar, PieChart and BarChart Classes

The user has two ways of interacting with the scrollbar which was to click and drag, the scrollbar or use the mouse wheel. The scrollbar worked by adjusting the y values of the StoryWidget objects. To calculate the distance to scroll down, the hidden screen height was found (the part of the screen which contained StoryWidgets but could not be seen). The percentScrolled() function calculates the distance the scrollbar has scrolled and adds or subtracts the appropriate values from the y values of the StoryWidgets. The mouse wheel is tied to the scrollbar and simply moves it up or down by calculating its velcity.

The PieChart class was used to display the percent of comments a user had on the specific story. The arc() function in PIE mode was used to create the slices of the PieChart object when drawn. The comments were retrieved using the getAllComments() function from the Stories class. Each comment was paired to each author using HashMaps. The percentages were then calculated which is used when drawing the Pie Chart. The Pie Chart also displays the name of the users and their colour beside it. If there are more than 20 users, the Pie Chart will only show the top 19 users and put the rest into OTHERS. The Pie Chart also will query the user the mouse clicked on.

The BarChart class displays the data similarly to PieChart. It displays it with the comments  done as a percentage with the tallest corresponding to the percentage at the top. Hovering a a bar will link it with a line to the name and percentage. If it is clicked on it will search the user.

The ScrollBar, Pie Chart and BarChart classes were created by Lexes Mantiquilla. The ScrollBar and PieChart class was maintained by Lexes Mantiquilla. The BarChart class was maintained by Gregory Partridge.

### Dark Theme

The DarkTheme works by simply inverting the colours on the screen when the button is pressed. The reason the toggle button doesn’t change colour as it turns to the inverse of the original colour so its set back to the original value.

### Loading Bar

The LoadingBar was originally there when we were loading the medium JSON file but as the program got more efficient it was no longer used. We decided to then use it for when we loaded the comments. The LoadingBar wheel works by first pushing the matrix. After this I translate it to the centre of the screen. I then drew an array of shapes and rotated them at speed proportional to the loading bar. After the loading bar pass eighty percent the shapes will reduce in size until there are equal to zero. At the end I pop the matrix. This is so there was a smooth transition.
The loading bar works similarly and the size of the rectangle is dependent on the percentage loaded variable. 

## The Database

### Reading the JSON File
The program initially read the JSON file using the loadStrings() function and parsed the Strings into JSONObject objects. The values were retrieved using the JSONObject functions. These values were then stored into new objects, the Story and the Comment class. These were initially stored into an ArrayList and later into a HashMap. The HashMap allowed for random access of the Comments and Story objects. The id was used as the key. The HashMap was stored into the Database class. The Comments and Stories classes were ArrayLists which stored a collection of comments and stories. These classes allowed us to sort and retrieve data. These classes were used for queries and as a medium to easily access the data. Each Story and Comment object contained a Comments object which structured the data (it allowed us to easily show the comments of a story and replies to comments and comments of those comments…). 

Using a combination of the Collections sort function and Comparators, the Story and Comment objects are able to be sorted by score, descendants and time. This worked pretty well up to the hackerNews1M.json file, however the initial loading times were subpar. In order to decrease the loading time, the BufferedReader is used in conjunction with the JSONParser class. The static class JSONParser provided functions which parsed the JSONs straight from the String instead of creating JSONObjects and retrieving the data. To further decrease the initial loading time, the data was parsed and stored into the HashMaps as the BufferedReader was reading each line. This cut the loading time in half as only one for loop was used to parse the data. To initialise the story comments and comments of comments, a recursive function was used. This retrieved all the kids a story had and retrieved each comment a comment had.

To perform queries, a combination of the Collections sort function and String operations were used to obtain the required data from the Database class.

Upon receiving the largest dataset, it was apparent that it would take too much RAM to store all the JSONs parsed. An attempt was made to create a low-level database by using the RandomAccessFile class which allowed us to retrieve the comment or story from the JSON file without parsing all of the data. Each JSON contained an id which corresponded to the line that JSON was in the file. The BufferedReader was used to create pointers to each line as each line was not the same size.

This allowed the program to retrieve the comment or story needed from a given id. In order to sort the file, A script was created initially which would divide the file into equal pieces. Each piece of the file was sorted and then merged together to create a fully sorted file. The file was sorted into the different queries planned and depending on the query, the specific file was read. However this took up more space and was undesirable. Instead of sorting the file, the pointers were sorted instead.

However it was too troublesome to create a low-level database and instead we used the h2 SQL database. The Database class was converted into an interface which retrieved data from the SQL database. 

The Story and Comment classes were created by Eoin Pinaqui and is maintained by Lexes Mantiquilla. The Stories, Comments and JSONParser classes were created and maintained by Lexes Mantiquilla.

### SQL Database
The Database class is now used connect to the SQL database and serialize the JSON file. The Database class is used initially create the two tables stories and comments. At the start of the main program, the a Database object is created. The initialiseConnection() function is used to connect to the local embedded SQL database. A function in the main program detects if a h2 / MySQL database was initialised. If not, the two tables are created. The parseJSONFile() function is then called. This reads each line of the JSON file and inserts it to the appropriate table. 

Indexes were created. This greatly sped up the queries. The Apache Lucene library was used to create the full-text indexes which greatly sped up the wildcard search for titles.

The Stories class was used to query the database and store the information which was displayed by the StoryWidgets class. The Stories class was used query the SQL database by time, score or descendants. It was also used to query the database to retrieve stories by a certain author or stories which contained a word in the title. The buttons used the Stories class to adjust the user query.
