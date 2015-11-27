//Global Variables
int totalBubbles;              //total bubbles in level
int numBubbles = totalBubbles; // initial bubble count
final int BROKEN = -99; // code for "broken", may have other states later
int MAXDIAMETER; // maximum size of expanding bubble, variable depending on level
int clicksleft = 3; // number of clicks, presently not used
int score = 0;      //number of bubbles destroyed
int finalScore;      //score at end of level
ArrayList<Bubble> pieces; // all the bubbles
boolean gameOver = false; //true if the game is not in play
int second;                //used for counting the time to when the game should end
int currentSecond;          //used for counting the time to when the game should end
int difficulty = 0;        //difficulty, 1 = easy, 2 = normal, 3 = hard, 0 means it has not been chosen yet
color[] backGround = {color(12, 255, 0,150) , color(255,145,0,150) , color(255,0,0,150)};  //background colors for each different level
color[] name = {color(255, 0, 0,150) , color(105,0,255,150) , color(0,255,0,150)};        //colors for ball and name in the background for each different level
String endMessage[] = {
  "Perfect score!!!", "Awesome!!", "Great job!", "Good score", "Not bad", "Try harder!", "Failure!!", "CRITICAL FAILURE!!!"    //different ending messages for different results
};

void setup()         
{
  size(640, 640);    
  noStroke();
  smooth();
  textSize(24);
}

void initBubbles(int total) {          //initializes the bubbles to be used in the level, total is the total number of bubbles for the current level
  totalBubbles = total;       //total bubble count
  numBubbles = totalBubbles; // current bubble count

  pieces = new ArrayList(numBubbles);    //defines new array list
  for (int i = 0; i < numBubbles; i++) {
    pieces.add(new Bubble(random(width), random(height), 30, i, pieces));    //adds each piece
  }
}

void mousePressed()
{
  if (difficulty == 0) {    //if the dificulty has not been selected
    if (mouseX <= width/3){  //sets difficulty to easy
     difficulty = 1; 
     initBubbles(90);
     MAXDIAMETER = 120;
    } else if (mouseX <= width*2/3){//sets difficulty to normal
     difficulty = 2; 
     initBubbles(70);
     MAXDIAMETER = 110;
    }else{                    //sets difficulty to hard
      difficulty = 3;
      initBubbles(60);
      MAXDIAMETER = 100;
    }
  } else {
    if (clicksleft >0) {    //if there are clicks left to be used...
      // on click, create a new burst bubble at the mouse location and add it to the field
      clicksleft--;  
      score--;  //decreases score because a new bubble is being created, but it should not be counted in the final score
      Bubble b = new Bubble(mouseX, mouseY, 2, numBubbles, pieces);
      b.burst();//creates bubble that bursts
      pieces.add(b);
      numBubbles++;
      if ( clicksleft == 0) {  //if this is the last click
        second = second();    //takes the second that the last click is used, this is used later
      }
    } else {
      if (gameOver == true) {    //if the game is over, when the player clicks they return to the menu
        gameOver = false;
        clicksleft = 3;
        score = 0;
        difficulty = 0;
      }
    }
  }
}
void draw() 
{
  if (gameOver == false) {    //when game is in play
    if (difficulty == 0) {  //if difficulty has not been selected
      background(0);                                                          //SHOWS MENU
      fill(0, 255, 0, 200);
      rect(0, 0, width/3, height);
      fill(255, 255, 0, 200);
      rect(width/3, 0, width/3, height);
      fill(255, 0, 0, 200);
      rect(width*2/3, 0, width/3, height);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(64);
      text("BubblePopper", width/2, height/8);
      textSize(32);
      text("By Jeremy Melone", width/2, height/4);
      text("Click one of the difficulties to begin!", width/2, height/4 + 100);
      text("EASY", width/6, height*3/4);
      text("NORMAL", width/3 + width/6, height*3/4);
      text("HARD", width*2/3 + width/6, height*3/4);                          //End of menu
    } else {
      background(backGround[difficulty - 1]);                                //background of current difficulty
      fill(name[difficulty - 1]);                                            //color of current difficulty bubbles
      textSize(90);
      textAlign(CENTER, CENTER);
      text("BubblePopper", width/2, height/2);                                //displays "BubblePopper" in background
      for (int i = 0; i < numBubbles; i++) {
        Bubble b = (Bubble)pieces.get(i); // get the current piece
        if (b.diameter < 1) // if too small, remove
        {
          pieces.remove(i);
          numBubbles--;
          i--;
        } else
        {
          // check collisions, update state, and draw this piece
          if (b.broken == BROKEN)
            // only bother to check collisions with broken bubbles
            b.collide();
          b.update();
          b.display();
        }
      }
      textSize(24);
      fill(0);
      textAlign(LEFT, BOTTOM);
      text("Score: " + score, 10, height-10);        //displays score at bottom
      textAlign(RIGHT, BOTTOM);
      text("Clicks: " + clicksleft, width-10, height-10);    //displays clicks at bottom
      if (clicksleft <= 0) {
        currentSecond = second();                                    //if there are no clicks left, it checks how long it has been since there has been an explosion, 
                                                                      //and if it is longer than the time it takes an explosion to disappear, then there are no more explosions happening, and the game ends
        if ((currentSecond - second >= 2 && currentSecond - second <10) ||(currentSecond + 60) - second  >= 2 && (currentSecond + 60) - second < 10) {
          boolean end = true;
          for (int i = 0; i < numBubbles; i++) {
            Bubble check = (Bubble)pieces.get(i);
            if (check.broken == BROKEN) {
              end = false;
            }
          }  
          if (numBubbles == 0) end = true;                //also ends the game if there are no more bubbles on the screen
          if (end == true) {
            gameOver = true;
            finalScore = score;                          //sets finalScore as the current score
          }
        }
      }
    }
  } else {
    textAlign(CENTER, CENTER);                                                  //displays game over screen
    text("Game Over, click to play again", width/2, height/2 - 175);
    text("The final score was " + finalScore + " / " + totalBubbles, width/2, height/2 - 125);    //displays the final score
    float percent = (float(finalScore) / float(totalBubbles)) * 100;                              
    text("You got " + int(percent) + "% of the bubbles!", width/2, height/2 + 125);                //displays percent of bubbles popped
    int index;
    if (percent >= 100) index = 0;
    else if (percent >= 90) index = 1;
    else if (percent >= 80) index = 2;
    else if (percent >= 70) index = 3;
    else if (percent >= 60) index = 4;
    else if (percent >= 50) index = 5;
    else if (percent > 0) index = 6;
    else index = 7;
    text(endMessage[index], width/2, height/2 + 175);                //displays different messages depending on what percent the player got
  }
}
