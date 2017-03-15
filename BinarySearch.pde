import de.bezier.guido.*;
TargetButton [] targets = new TargetButton[32];
ArrayList <Integer> nums = new ArrayList <Integer>();
int numNums = int(random(900)+100);
int startNum = int(random(900));
int numToFind= startNum+int(random(numNums));
int numGuesses = 0;
boolean numFound = false;
int low = 0;
int high = 31;
public void setup()
{
  size(1000, 300);
  textAlign(CENTER, CENTER);
  Interactive.make( this );
  while(nums.size()<32)
  {
    int num = startNum+int(random(numNums));
    if(!nums.contains(num))
      nums.add(num);
  }
  int[] numsArray = new int[32];
  for(int i = 0; i < 32; i++)
    numsArray[i] = nums.get(i);
  numsArray = sort(numsArray);
  for(int i = 0; i < 32; i++)
    nums.set(i,numsArray[i]);
  if (!nums.contains(numToFind) && random(1)<.6)
    while (!nums.contains(numToFind))
      numToFind=startNum+int(random(numNums));
  int i = 0;
  for (int x = 20; x< 980; x+=30)
  {
    targets[i] = new TargetButton(x, 30,nums.get(i) );
    new SearchButton(x, 70, i);
    i++;
  }
  
}
public void draw()
{
  background(192);
  fill(0);
  textSize(32);
  text("Try to find: "+numToFind,140,160);
  text("Number of Guesses: "+numGuesses, 600, 160);
  
  if (numFound) 
    text("Number found after " + numGuesses + " guesses. Refresh browser to play again", 500, 260);
  else if (notInList())
    text("Number not in list. Refresh browser to play again", 500, 260);
  textSize(18);
  text("Low Index: " + low,100,200);
  text("High Index: " + high,105,220);
  textSize(10);
}
public class SearchButton
{
  private float x, y, width, height;
  private boolean clicked;
  private String label;
  private int index;
  public SearchButton ( int xx, int yy, int i )
  {
    width = height = 30;
    x = xx;
    y = yy;
    index = i;
    label = "["+i+"]";
    clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isClicked()
  {
    return clicked;
  }
  public void mousePressed () 
  {
    if (numFound || notInList()) return;
    if (clicked == false)
      numGuesses++;
    clicked = true;    
    targets[index].pressed();
    if(targets[index].value < numToFind)
    {
      low = index + 1;
    }
    else if(targets[index].value > numToFind)
    {
      high = index - 1;
    }
    else
      numFound = true;
    
    targets[index].pressed();
    if(targets[index].value < numToFind)
    {
      low = index + 1;
      tooLow(index,targets[index].value);  
    }
    else if(targets[index].value > numToFind)
    {
      high = index - 1;
      tooHigh(index,targets[index].value);
    }
  }
  public void draw () 
  {    
    if (clicked)
      fill( 255 );
    else 
    fill( 150 );
    rect(x, y, width, height);
    fill(0);
    text(label, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    label = newLabel;
  }
}

public class TargetButton
{
  private float x, y, width, height;
  private boolean clicked;
  private String label;
  private int value;

  public TargetButton ( int xx, int yy, int v )
  {
    width = height = 30;
    x = xx;
    y = yy;
    label = "";
    clicked = false;
    value = v;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isClicked()
  {
    return clicked;
  }
  public void mousePressed () {}
  public void pressed()
  {
    setLabel(""+value);
    clicked = true;
  }
  public void draw () 
  {    
    if (clicked)
    {
      if(value==numToFind)
        fill(255,255,0);
      else
        fill( 255 );
    }
    else 
    fill( 150 );
    rect(x, y, width, height);
    fill(0);
    text(label, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    label = newLabel;
  }
}
public void tooLow(int pos, int val)
{
  for(int i = pos-1; i >= 0; i--)
    if(targets[i].label.equals("") || (val < Integer.parseInt(targets[i].label.substring(1)) && targets[i].label.substring(0,1).equals("<")))
      targets[i].setLabel("<"+val); 
}
public void tooHigh(int pos, int val)
{
  for(int i = pos+1; i < 32; i++)
    if(targets[i].label.equals("") || (val > Integer.parseInt(targets[i].label.substring(1))&& targets[i].label.substring(0,1).equals(">")))
      targets[i].setLabel(">"+val); 
}
public boolean notInList()
{
  for(int i = 0; i < 32; i++)
    if(targets[i].label.equals(""))
      return false;
  return true;
}
  