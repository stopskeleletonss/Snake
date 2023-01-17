ArrayList<Integer> bodyx = new ArrayList<Integer>(), bodyy = new ArrayList<Integer>(); //arraylist for updating the position of the snake
PImage title1, title2, endscreen, tutorial; //images for the title screen (two for flickering text effect), game over screen, and the tutorial screen
boolean noleft, noup, nodown, noright; //booleans that stop the player from moving backwards into themselves
boolean gamestart, gameover; //booleans that say whether the game has started or not, as well as ended or not
boolean canmove, tutorialover; //booleans that say whether the player is allowed to move, and if the tutorial screen has been read
color green = (#00FF00), red = (#FF0000), yellow = (#FFFF00); //color variables for the colors red, green, and yellow using the hex values of their normal rgb values (#00FF00 is 0,256,0)
int sizex, sizey, direc; //variables for the size of the game in both x and y (keeps the game at a 20x20 grid no matter what) and direc variable to switch what part of the x and y direction array is in use
int foodx, foody; //variables for the x and y coordinate of the food square
int foodh=20, foodw=20; //width and height variables for food spawning
int score, highscore; //variables for the score in one game, and the highest amount of score achieved in a game while the program is open
int increase=50, changepoint=8; //variables for increasing the speed of the game per 50 points
int[] xdirec={0, -1, 0, 1, }; //array containing how x coordinate of the snake is affected in all 4 directions (paired with corresponding ydirec variable)
int[] ydirec={-1, 0, 1, 0, }; //array containing how y coordinate of the snake is affected in all 4 directions (paired with corresponding xdirec variable)


void setup() {
  size(600, 600);
  title1=loadImage("title1.png"); //title1 is assigned the title1 image
  title2=loadImage("title2.png"); //title2 is assigned the title2 image
  endscreen=loadImage("endscreen.png"); //endscreen is assigned the endscreen image
  tutorial=loadImage("tutorial.png"); //tutorial is assigned the tutorial image
  sizex=width/20; //sizex is equal to a 20th of the chosen screen width
  sizey=height/20; //sizey is equal to a 20th of the chosen screen height
  bodyx.add(int(random(20))); //starts the snake in a random row
  bodyy.add(int(random(20))); //starts the snake in a random column
  foodx=int(random(foodw)); //original x coordinate value is a random number between 0 and 19
  foody=int(random(foodh)); //original y coordinate value is a random number between 0 and 19 (20x20 game screen)
}

void draw() {
  background(0);
  if (gameover==false && gamestart==false) { //if the game has not started or ended
    titlescreen();
  }
  if (gameover==false && gamestart) { //if the game has started and has not ended
    movement();
    snakecollis();
    food();
    snake();
    tutorial();
    gamespeed();
  }
  if (gameover) { //if the game has ended
    endscreen();
  }
}

void titlescreen() { //function to display the title screen
  if (frameCount%20!=0) {
    image(title2, 0, 0, width, height);
  } else {
    image(title1, 0, 0, width, height);
  }
}

void endscreen() { //function to display the game over screen
  if (score>highscore) { //if the score achieved in the game that just ended is higher than the highscore
    highscore=score; //the new score is now the highscore
  }
  image(endscreen, 0, 0, width, height); //displays the game over screen
  fill(green); //writes text as green
  if (width<height || width==height) { //if the gamescreen is taller than it is wide, or if it is a perfect square
    textSize(width/10); //textsize is equal to a tenth of the gamescreen width
  } else if (height<width) { //else if the gamescreen is wider than it is tall
    textSize(height/10); //textsize is equal to a tenth of the gamescreen height
  }
  text(score, width/5, height/2); //text that displays the score for the game that just ended
  text(highscore, width/5, height/4*3); //text that displays the overall highscore
}

void tutorial() { //function to display the tutorial screen
  if (tutorialover==false) { //if the tutorial screen has not yet been read
    image(tutorial, 0, 0, width, height); //displays the tutorial screen
  }
}

void gamespeed() {
  if (score == increase) { //if the ovrall score of the current game is equal to the increase variable (initially 50)
   increase += 50; //add 50 to the increase variable
   changepoint -= 0.25; //subtract 0.25 from the changepoint variable (initially 8)
  }
}

void movement() { //function to allow the snake to move
  if (key=='w'&&noup==false) { //if the key pressed was "w" and the snake is not moving downwards
    direc=0; //snake position is updated using the [0] values of the xdirec and ydirec arrays (x = 0, y = -1)
    nodown=true; //the snake cannot be moved downwards
    noleft=false; //the snake can be moved to the left
    noright=false; //the snake can be moved to the right
  } else if (key=='a'&&noleft==false) { //if the key pressed was "a" and the snake is not moving to the right
    direc=1; //snake position is updated using the [1] values of the xdirec and ydirec arrays (x = -1, y = 0)
    noright=true; //the snake cannot be moved to the right
    noup=false; //the snake can be moved upwards
    nodown=false; //the snake can be moved downwards
  } else if (key=='s'&&nodown==false) { //if the key pressed was "s" and the snake is not moving upwards
    direc=2; //snake position is updated using the [2] values of the xdirec and ydirec arrays (x = 0, y = 1)
    noup=true; //the snake cannot be moved upwards
    noleft=false; //the snake can be moved to the left
    noright=false; //the snake can be moved to the right
  } else if (key=='d'&&noright==false) { //if the key pressed was "d" and the snake is not moving to the left
    direc=3; //snake position is updated using the [3] values of the xdirec and ydirec arrays (x = 1, y = 0)
    noleft=true; //the snake cannot be moved to the left
    noup=false; //the snake can be moved upwards
    nodown=false; //the snake can be moved downwards
  }
}

void food() { //function for the behavior and displaying of the food square
  fill(red);
  if (frameCount%changepoint==0) { //every changepoint frames (initially 8 meaning every 8 frames)
    if (canmove) { //if the snake is allowed to move
      bodyx.add(0, bodyx.get(0) + xdirec[direc]); 
      bodyy.add(0, bodyy.get(0) + ydirec[direc]); //creates another segment of the snake directly infront of the current first segment in the direction it is moving (following the 20x20 grid)
      if (foodx==bodyx.get(0) && foody==bodyy.get(0)) { //if the head of the snake has the same x and y coordinate as the food square (if the snake eats the food_
        foodx=int(random(foodw)); 
        foody=int(random(foodh)); //x and y coordinate of the food square are changed to a random point in the 20x20 grid
        score=score+10; //adds 10 the to overall score each time a food square is eaten
      } else { //if the snake is not currently eating a food square
        bodyx.remove(bodyx.size()-1);
        bodyy.remove(bodyy.size()-1); //removes the furthest back segment of the snake (not being run while a food square is being eaten allows the snake to grow a square longer each time)
      }
    }
  }
  rect(foodx*sizex, foody*sizey, sizex, sizey); //displays the food square at position in the 20x20 grid that it was placed in
}

void snakecollis() { //functon for the snake colliding with itself
  for (int index=1; index<bodyx.size(); index++) { //index1 variable has an initial value of 1, must be less than the length of bodyx arraylist, and increases by increments of 1
    if (bodyx.get(0)==bodyx.get(index) && bodyy.get(0)==bodyy.get(index)) { //if the head of the snake is in the same position of the 20x20 grid as another section of the snake
      gameover=true; //the game has ended
    }
  }
}

void snake() { //function for displaying the snake, the boundaries of the run window, to stop food from spawning in the snake, and goldsnake
  for (int index=0; index<bodyx.size(); index++) { //index1 variable has an initial value of 0, must be less than the length of bodyx arraylist, and increases by increments of 1
    if (foodx==bodyx.get(index) && foody==bodyy.get(index)) { //if the food square spawns in the same position on the 20x20 grid as the any section of the snake
      foodx=int(random(foodw)); 
      foody=int(random(foodh)); //resets the x and y coordinates of the food square to relocate it elsewhere in the 20x20 grid
    }
    if (highscore>290) { //if the highest score achieved while the program is open is over 290 (reaches 300)
      fill(yellow); //draw the snake as yellow
    } else {
      fill(green); //draw the snake as green
    }
    rect(bodyx.get(index)*sizex, bodyy.get(index)*sizey, sizex, sizey); //displays each segment of the snake at it's location in the 20x20 grid
    if (bodyx.get(0)>19 || bodyx.get(0)<0 || bodyy.get(0)>19 || bodyy.get(0)<0) { //if the head of the snake exits the run window in any direction (leaves the 20x20 grid)
      gameover=true; //the game has ended
    }
  }
}

void keyPressed() {
  if (gamestart) { //if the game has started
    canmove=true; //the snake can now move
    tutorialover=true; //the tutorial screen has been read, will not display again
  } else if (gamestart==false && gameover==false) { //if the game has not started and the game has not ended
    gamestart=true; //the game has started
  }
  if (gameover && key=='r') { //if the game is over and the "r" key is pressed
    bodyx.clear(); 
    bodyy.clear(); //resets the arraylists for the x and y coordinates of the snake completely
    score=0; //sets the score back to 0
    gamestart=false; //the game has not started
    canmove=false; //the snake cannot move
    gameover=false; //the game is no longer over
    bodyx.add(int(random(20))); //resets the snake in a random row
    bodyy.add(int(random(20))); //resets the snake in a random column
    foodx=int(random(foodw)); //x coordinate value is a random number between 0 and 19
    foody=int(random(foodh)); //y coordinate value is a random number between 0 and 19 (20x20 game screen)
    noup=false; //the snake can move upwards
    noleft=false; //the snake can move to the left
    noright=false; //the snake can move to the right
    nodown=false; //the snake can move downwards
  }
}
