import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private final static int NUM_ROWS = 15;
private final static int NUM_COLS = 15;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined
private PImage one, two, three, four, five, six, seven, eight, flag, mine, none, click, winner, loser;
private boolean pressed = false;
private int minenum = 40;
private int status = 0;

void setup ()
{
  size(480, 480);
  textAlign(CENTER, CENTER);
  one = loadImage("ms1.png");
  two = loadImage("ms2.png");
  three = loadImage("ms3.png");
  four = loadImage("ms4.png");
  five = loadImage("ms5.png");
  six = loadImage("ms6.png");
  seven = loadImage("ms7.png");
  eight = loadImage("ms8.png");
  flag = loadImage("msflag.png");
  none = loadImage("msnone.png");
  mine = loadImage("msmine.png");
  click = loadImage("msclick.png");
  loser = loadImage("mslose.png");
  winner = loadImage("mswin.png");

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r =0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c]= new MSButton(r, c);
    }
  }
  for (int m = 0; m < minenum; m++) {
    setMines();
  }
}
public void setMines()
{
  //your code
  int row = (int)(Math.random()*NUM_ROWS);
  int col = (int)(Math.random()*NUM_COLS);
  if (!mines.contains(buttons[row][col])) {
    mines.add(buttons[row][col]);
  } else setMines();
}

public void draw ()
{
  background( 255, 196, 206 );
  if (isWon() == true)
    displayWinningMessage();
}

public void keyPressed() {
  if (keyCode == ENTER||keyCode==RETURN) {
    for (int r =0; r < NUM_ROWS; r++) {
      for (int c = 0; c < NUM_COLS; c++) {
        buttons[r][c]= new MSButton(r, c);
      }
    }
    for (int m = 0; m < minenum; m++) {
      mines.remove(0);
    }
    for (int m = 0; m < minenum; m++) {
      setMines();
    }
    status =0;
  }
  loop();
}

public void keyReleased() {
  if (keyCode == CONTROL) {
    pressed = false;
  }
}

public boolean isWon()
{
  //your code here
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (!mines.contains(buttons[r][c]) && !buttons[r][c].clicked) 
        return false;
    }
  }
  return true;
}
public void displayLosingMessage()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (mines.contains(buttons[r][c]) && !buttons[r][c].clicked) {
        buttons[r][c].mousePressed();
      }
    }
  }
  status = 1;
  noLoop();
}
public void displayWinningMessage()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (buttons[r][c].myLabel.equals("")){
        buttons[r][c].setLabel("w");
      }
    }
  }
  status = 2;
  noLoop();
}
public boolean isValid(int r, int c)
{
  //your code here
  if (r>=0&&r<NUM_ROWS&&c>=0&&c<NUM_COLS) return true;
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  //your code here
  for (int r = row-1; r<=row+1; r++) {
    for (int c = col-1; c<=col+1; c++) {
      if (isValid(r, c)&&mines.contains(buttons[r][c])) numMines++;
    }
  }
  if (mines.contains(buttons[row][col])) numMines--;
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 480/NUM_COLS;
    height = 480/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    //your code here
    if (mouseButton == RIGHT||pressed==true) {
      clicked = false;
      flagged = !flagged;
    }
    if (flagged) clicked = false;
    else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) setLabel(countMines(myRow, myCol));
    else {
      for (int r = myRow -1; r<= myRow+1; r++) {
        for (int c = myCol - 1; c<=myCol+1; c++) {
          if (isValid(r, c)&&buttons[r][c].clicked==false) {
            buttons[r][c].mousePressed();
          }
        }
      }
    }
  }
  public void draw () 
  { 
    if (flagged)
      image(flag, x, y);
    else if (clicked && myLabel.equals("1"))
      image(one, x, y);
    else if (clicked && myLabel.equals("2"))
      image(two, x, y);
    else if (clicked && myLabel.equals("3"))
      image(three, x, y);
    else if (clicked && myLabel.equals("4"))
      image(four, x, y);
    else if (clicked && myLabel.equals("5"))
      image(five, x, y);
    else if (clicked && myLabel.equals("6"))
      image(six, x, y);
    else if (clicked && myLabel.equals("7"))
      image(seven, x, y);
    else if (clicked && myLabel.equals("8"))
      image(eight, x, y);
    else if ( clicked && mines.contains(this) ) 
      image(mine, x, y);
    else if (myLabel.equals("w"))
      image(winner, x, y);
    else if (clicked)
      image(click, x, y);
    else if (status==1)
      image(loser, x, y);
    else 
    image(none, x, y);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
