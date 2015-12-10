/* WoodBlock class

   Represents a lowercase letter in the English language
   Has attributes describing its form and vowel/consonant
   status, and a cloning constructor to instantiate new copies
   of itself that won't point at the originals' attributes.
---------------------------------------------------------*/


class WoodBlock {
  
/* attributes
---------------------------------------------------------*/
String letter; //roman alphabet character
String lowerLetter; //lowercase version of it
String capsLetter; //uppercase

//default type anatomy; value always occurs in the lowercase letter
boolean hasAscender, hasDescender, hasCounter, isVowel;

//to store anatomy information for lowercase and uppercase
boolean lowerAscender, capsAscender, lowerDescender, capsDescender;
  
  
/* constructors
---------------------------------------------------------*/
//main constructor
WoodBlock(String tempLetter, boolean as, boolean des, boolean count, boolean vowel) {
  letter = tempLetter; //initial letter String
  capsLetter = letter.toUpperCase(); //capital/uppercase version
  lowerLetter = letter.toLowerCase(); //lowercase version
  
  hasAscender = as; //ascender: re-assigned based on case
  lowerAscender = as; //lowercase ascender depends on constructor
  capsAscender = true; //caps are always ascenders themselves
  
  hasDescender = des; //descender: re-assigned based on case
  lowerDescender = des; //lowercase descender depends on constructor
  capsAscender = false; //no caps have descenders
  
  hasCounter = count; //counter: consistent between cases
  isVowel = vowel; //vowel or consonant
}
  
//copy constructor; make a new copy of the object so the original
//won't be affected by attribute re-assignment such as capitalize()
WoodBlock(WoodBlock orig) {
  this(orig.letter, orig.hasAscender, orig.hasDescender, orig.hasCounter, orig.isVowel);
}
  
/* methods
---------------------------------------------------------*/
  
//capitalize WoodBlock's letter and indicate
//it now qualifies as an ascender (as all capitals do)
void capitalize() {
  letter = capsLetter; //assign letter as uppercase
  
  //assign ascender and descender as the caps version
  hasAscender = capsAscender;
  hasDescender = capsDescender;
}



//make WoodBlock's letter lowercase
//and revert its ascender/descender booleans to their
//original form
void lowerCase() {
  letter = lowerLetter; //assign letter as lowercase
  
  //assign ascender and descender as original argument
  hasAscender = lowerAscender; 
  hasDescender = lowerDescender;
}

} //end of Wood Block