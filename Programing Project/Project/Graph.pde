class Graph {
 private  ArrayList<Story> storiesArray;
 private int amountOfBars;
 int maxNumberOfComments;
 String user;
 Stories stories;
 Graph(String user, Stories stories) {
   this.user = user;
   this.stories = stories;
   storiesArray = stories.getStoriesByUser(user);
   amountOfBars = storiesArray.size();
   int currentComments;
   println(user);
   for (int commentChecker= 0; commentChecker<storiesArray.size(); commentChecker++)
   {
     currentComments = storiesArray.get(commentChecker).getDescendants();
     if (currentComments>maxNumberOfComments) maxNumberOfComments = currentComments;
   }
 }

 void displayGraph() {
   fill(225);
   float circleRadius = HOW_CURVEY_IS_GRAPH;
   rect(GRAPH_STARTX, GRAPH_STARTY, GRAPH_displayWidth, GRAPH_displayHeight);

   rect((GRAPH_STARTX - circleRadius), (GRAPH_STARTY + circleRadius), (circleRadius), GRAPH_displayHeight - (2*circleRadius));
   rect(GRAPH_STARTX + GRAPH_displayWidth, GRAPH_STARTY + circleRadius, circleRadius, GRAPH_displayHeight - (2*circleRadius));
   ellipse((GRAPH_STARTX), GRAPH_STARTY + circleRadius, 2 * circleRadius, 2 * circleRadius);
   ellipse((GRAPH_STARTX + GRAPH_displayWidth), GRAPH_STARTY + circleRadius, 2 * circleRadius, 2 * circleRadius);
   ellipse((GRAPH_STARTX), (GRAPH_STARTY + GRAPH_displayHeight) - circleRadius, 2 * circleRadius, 2 * circleRadius);
   ellipse((GRAPH_STARTX + GRAPH_displayWidth), (GRAPH_STARTY + GRAPH_displayHeight) - circleRadius, 2 * circleRadius, 2 * circleRadius);
   float barWidth = ((displayWidth-200)/(float)amountOfBars);
   int commentAmountChecker = 0;
   stroke(0);
   for (float currentWidth = 0; currentWidth < (displayWidth -200) && commentAmountChecker<storiesArray.size(); currentWidth+=barWidth)
   {
     float barHeight = 0.9 * (GRAPH_displayHeight)*((storiesArray.get(commentAmountChecker++)).getDescendants()/(float)maxNumberOfComments);
     if (mouseX>GRAPH_STARTX+currentWidth && mouseY> GRAPH_STARTY+(GRAPH_displayHeight-barHeight) && mouseX < ((GRAPH_STARTX+currentWidth) + barWidth) && mouseY <(GRAPH_STARTY+(GRAPH_displayHeight-barHeight)+ barHeight)) fill(0, 0, 255);
     else fill(0);
     rect((GRAPH_STARTX+currentWidth), GRAPH_STARTY+(GRAPH_displayHeight-barHeight), barWidth, barHeight);
   }
 }
 void setNewUser(String user)
 {
   this.user = user;
   storiesArray = stories.getStoriesByUser(user);
   amountOfBars = storiesArray.size();
   int currentComments;
   println(user);
   maxNumberOfComments=0;
   for (int commentChecker= 0; commentChecker<storiesArray.size(); commentChecker++)
   {
     currentComments = storiesArray.get(commentChecker).getDescendants();
     if (currentComments>maxNumberOfComments) maxNumberOfComments = currentComments;
   }
 }
}
