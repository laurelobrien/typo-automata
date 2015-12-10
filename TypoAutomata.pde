/* TypoAutomata class

   Contains attributes and methods for drawing a
   field of objects, evaluating them against rule sets, 
   and re-assigning them through generations
   
   Based on Conway's Game of Life
---------------------------------------------------------*/


class TypoAutomata {

/* attributes
---------------------------------------------------------*/
 
WoodBlock[][] currentGen;
boolean[] xRules, yRules; //store the rule sets provided in constructor
int generation; //count generations that have transpired
int fontSize, spacing;
int columns, rows;

String typeBlock; //final String used to draw letters on canvas
float x, y; //coordinate positions for drawing grid of letters
PFont serif, sansSerif; //sans and serif monospace typefaces for simulating output

//////////////////////
//constructor
TypoAutomata(boolean[] x, boolean[] y, int font) {
  xRules = x;
  yRules = y;
  fontSize = font;
  spacing = int(fontSize * 1.5); //height and width of text() letters incl. padding
  
  //columns and rows of type, -2 for margin
  columns = int(width/spacing)-2;
  rows = int(height/spacing)-2;
  
  //create indices in currentGen that fit in canvas when drawn as text()
  currentGen = new WoodBlock[columns][rows];
  
  //font
  sansSerif = createFont("BrandonGrotesque-Bold.ttf", fontSize); //Brandon Grotesque
  
  //initialize currentGen[] with a seed array and generation as 0
  init();
}


/* methods
---------------------------------------------------------*/

//initialize currentGen[][] with fixed arrangement 
//of WoodBlock objects to act as a seed
void init() {
  //for each column (x-axis)
  for (int i = 0; i < columns; i ++) {
    //for each row (y-axis)
    for (int j = 0; j < rows; j ++) {
      //select the intersection in currentGen[][]
      //and assign as a full-stop WoodBlock
      currentGen[i][j] = allBlocks[26];
    }
  }
  
  //hello
  currentGen[3][rows/2-2] = allBlocks[7];
  currentGen[4][rows/2-2] = allBlocks[4];
  currentGen[5][rows/2-2] = allBlocks[11];
  currentGen[6][rows/2-2] = allBlocks[11];
  currentGen[7][rows/2-2] = allBlocks[14];
  //world
  currentGen[3][rows/2] = allBlocks[22];
  currentGen[4][rows/2] = allBlocks[14];
  currentGen[5][rows/2] = allBlocks[17];
  currentGen[6][rows/2] = allBlocks[11];
  currentGen[7][rows/2] = allBlocks[3];
} //end of init()



/* establish the locations of a letter's von Neumann neighbourhood
   (4 cardinal directions) and pass them through applyRules to generate
   a new generation of type. refine that grid with a second pass of
   specific changes concerning vowels, consonants, and capitalization.
---------------------------------------------------------*/
void generate() {
  //create an empty array for the new generation, same size as currentGen[][]
  WoodBlock[][] nextGen = new WoodBlock[columns][rows];
  
  //for every WoodBlock object in a 2D array (except the ones on the edges
  //who are without a full neighbourhood)
  for (int i = 1; i < columns-1; i ++) {
    for (int j = 1; j < rows-1; j ++) {
      WoodBlock me = currentGen[i][j]; //WoodBlock to evaluate
      
      //establish x-axis neighbours; left and right
      WoodBlock left = currentGen[i-1][j];
      WoodBlock right = currentGen[i+1][j];
      
      //establish y-axis neighbours; above and below
      WoodBlock above = currentGen[i][j-1];
      WoodBlock below = currentGen[i][j+1];
      
      //compute next generation based on rule sets
      nextGen[i][j] = applyRules(me, left, right, above, below);
      
      //ensure all letters are lowercase if their parent object
      //was assigned as uppercase last generation
      nextGen[i][j].lowerCase(); 
    }
  }
  
/* second-pass re-assignment: language-based.
   evaluate newest state of WoodBlocks and alter them so 
   the change is reflected in the current frame, rather 
   than as offspring in the next.
   1. The letter after a full-stop is always capitalized,
      as if starting a new sentence.
   2. The first letter of the automaton is always a capital, 
      as if starting a chapter.
   3. Three vowels in a row occurs in English so rarely
      that the middle vowel will be changed to a "t", the
      most common consonant in English
   4. Three consonants in a row will be changed to 
      a vowel plus a consonant pair such as "ily" or "uck", 
      enabling more complex words to possibly emerge
---------------------------------------------------------*/
  //1. capitalize letters that succeed a full-stop
  for (int i = 1; i < columns-2; i ++) {
    for (int j = 1; j < rows-1; j ++) {
      if (nextGen[i][j] == allBlocks[26] && generation > 1) {
        WoodBlock newType = new WoodBlock(nextGen[i+1][j]);
        newType.capitalize();
        nextGen[i+1][j] = newType;
      }
    }
  }
  
  /*2. always capitalize the first letter
  ---------------------------------------------------------*/
  WoodBlock firstLetter = new WoodBlock(nextGen[1][1]); //use copy constructor
  firstLetter.capitalize(); //alter case and ascender/descender
  nextGen[1][1] = firstLetter; //assign first letter as the new version
  
  /*3. re-assign vowels whose left and right neighbours are already vowels
       as the letter "t", most common consonant in English
  ---------------------------------------------------------*/
  for (int i = 2; i < columns-2; i ++) {
    for (int j = 1; j < rows-1; j ++) {
      //if the x-axis neighbourhood is all vowels
      if (nextGen[i-1][j].isVowel && nextGen[i][j].isVowel && nextGen[i+1][j].isVowel) {
        //create new duplicate of "t" WoodBlock
        WoodBlock newType = new WoodBlock(allBlocks[19]);
        //assign it to current location in nextGen[][]
        nextGen[i][j] = newType;
      }
    }
  }
  
  /*4. re-assign 3 consonants in a row as WoodBlocks for 
       a vowel, "l", and "y" or a vowel, "c", and "k"
  ---------------------------------------------------------*/
  for (int i = 3; i < columns-2; i ++) {
    for (int j = 2; j < rows-2; j ++) {
      //if a WoodBlock and its two x-axis neighbours are consonants
      if(!nextGen[i-2][j].isVowel && !nextGen[i-1][j].isVowel 
         && !nextGen[i][j].isVowel && !nextGen[i+1][j].isVowel) {
        WoodBlock newType, newType2, newType3; //3 new duplicates
        
        //~=50/50 split: if 1 out of 2
        if (int(random(2)) == 1) {
          //use "ily" reformatting
          newType = new WoodBlock(allBlocks[11]); //"l"
          newType2 = new WoodBlock(allBlocks[24]); //"y"
          newType3 = new WoodBlock(allBlocks[8]); //"i"
        } else {
          //flip another coin
          //if 1 out of 2
          if (int(random(2)) == 1) {
            //vowel is "u"
            newType = new WoodBlock(allBlocks[20]); //"u"
          } else {
            //vowel is "a"
            newType = new WoodBlock(allBlocks[0]); //"a"
          }
          newType2 = new WoodBlock(allBlocks[2]); //"c"
          newType3 = new WoodBlock(allBlocks[10]); //"k"
        }  
        //assign nextGen[][] as new duplicates of what they would be
        nextGen[i-1][j] = newType;
        nextGen[i][j] = newType2;
        nextGen[i+1][j] = newType3;
      }
    } 
  
  }
  
  /*copy this new generation, nextGen[][]. into the current one, 
  overwriting it. ignore edge WoodBlocks that will
  have gone unchanged
  ---------------------------------------------------------*/
  for (int i = 1; i < columns-1; i ++) {
    for (int j = 1; j < rows-1; j ++) {
      currentGen[i][j] = nextGen[i][j];
    }
  }
  
  generation ++; //increment generation counter
} //end of generate()



/* draw a simulation of the print on the canvas by drawing each
   WoodBlock's String representation in a grid. allow for fill colour
   to be modified externally.
---------------------------------------------------------*/
void render() {
  //for every WoodBlock in currentGen:
  for (int i = 0; i < columns; i ++) {
    for (int j = 0; j < rows; j ++) {
      //if user wants colour display, fill type using three colours.
      if (wantColour) {
        if (currentGen[i][j].hasAscender) {
          fill(#BCF2D4); //mint green ascenders
        } else if (currentGen[i][j].hasDescender) {
          fill(#C6CAF0); //lavender descenders
        } else {
          fill(#FFB090); //peachy red for having neither
        }
      } else {
        fill(0); //don't want colour: black
      }
      
      //assign object's .letter String for text() use
      typeBlock = currentGen[i][j].letter;
      
      //draw the typeBlock on canvas in a grid position, where 
      //spacing pads out out columns and rows
      textFont(sansSerif); //set font to a sans-serif
      textAlign(CENTER); //center-align text at coordinate position
      text(typeBlock, (i+1) * spacing, (j+1) * spacing, spacing, spacing);
    }
  }
}



/* match the state of WoodBlock "me" and its neighbours to a rule set which
   will return a new WoodBlock for "me" to be occupied by next frame.
---------------------------------------------------------*/
WoodBlock applyRules(WoodBlock me, WoodBlock left, 
                     WoodBlock right, WoodBlock above, WoodBlock below) {
  //local array list to store possible matches for the rules
  ArrayList<WoodBlock> possMatches = new ArrayList<WoodBlock>();
  
  WoodBlock selectedType; //will be returned
  
  boolean xReq = false; //stores result of x axis rule-check
  boolean yReq = false; //stores result of y axis rule-check
  
  
  //first pass: anatomy-based.
  if (!left.hasDescender && !me.hasDescender && !right.hasDescender) xReq = xRules[0];
  if (!left.hasDescender && !me.hasDescender && right.hasDescender) xReq = xRules[1];
  if (!left.hasDescender && me.hasDescender && !right.hasDescender) xReq = xRules[2];
  if (!left.hasDescender && me.hasDescender && right.hasDescender) xReq = xRules[3];
  if (left.hasDescender && !me.hasDescender && !right.hasDescender) xReq = xRules[4];
  if (left.hasDescender && !me.hasDescender && right.hasDescender) xReq = xRules[5];
  if (left.hasDescender && me.hasDescender && !right.hasDescender) xReq = xRules[6];
  if (left.hasDescender && me.hasDescender && right.hasDescender) xReq =  xRules[7];
                                         
  if (!above.hasAscender && !me.hasAscender && !below.hasAscender) yReq = yRules[0];
  if (!above.hasAscender && !me.hasAscender && below.hasAscender) yReq = yRules[1];
  if (!above.hasAscender && me.hasAscender && !below.hasAscender) yReq = yRules[2];
  if (!above.hasAscender && me.hasAscender && below.hasAscender) yReq = yRules[3];
  if (above.hasAscender && !me.hasAscender && !below.hasAscender) yReq = yRules[4];
  if (above.hasAscender && !me.hasAscender && below.hasAscender) yReq = yRules[5];
  if (above.hasAscender && me.hasAscender && !below.hasAscender) yReq = yRules[6];
  if (above.hasAscender && me.hasAscender && below.hasAscender) yReq = yRules[7];
  
  
  
  // if anything in allBlocks has attribute(s) that match xReq and yReq:
  for (int i = 0; i < allBlocks.length; i ++) { 
    if (allBlocks[i].isVowel == xReq || allBlocks[i].hasAscender == yReq) {
      //add it to the pool of possible matches
      possMatches.add(allBlocks[i]);
    }
  }
  
  //if there is anything stored in in possMatches
  if (possMatches.size() > 0) {
    //select one if its contents at random and return it
    selectedType = possMatches.get(int(random(possMatches.size())));
    return selectedType; 
  //if possMatches is empty, no letters qualified.
  //instead search exclusively for letters with descenders
  } else {
    for (int i = 0; i < allBlocks.length; i ++) {
      //if the letter has an ascender OR a counter (could have both)
      if (allBlocks[i].hasDescender || allBlocks[i].hasCounter) {
        possMatches.add(allBlocks[i]); //add to pool
      }
    }
    
    //select random object from newly-filled possMatches and return it
    selectedType = possMatches.get(int(random(possMatches.size())));
    return selectedType; 
  } 
} //end of applyRules


} //end of WoodBlock class definition