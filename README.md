#Typo Automata

*Typo Automata* is a two-dimensional cellular automaton made in Processing that's roughly modeled on Conway's *Game of Life*, but constructed out of English letters instead of dead-or-alive cells. Each letter is an object with a collection of attributes both typographical and linguistic. 

The generational rules of the automaton create a field of letters based on their parent's formal relationship to its neighbours (such as the presence of ascenders, counters, etc) as a first pass, and in the second pass the newly created generation is searched for undesirable letter combinations to be replaced with more suitable letters. The goal of this second pass is to create a field of letters that is fairly readable — not as English words necessarily, but as sounds you could say outloud or parse as more than random gibberish at a glance.

The original goal of *Typo Automata* was to create a template for a printmaker to reference to create a letterpress print, in the collaborative style of Sol le Witt's *Wall Drawings*. The challenge was to write a program that could still surprise the programmer with novel output without resorting to total randomness. However, it's now more of an experiment in combining typographical aesthetics with linguistic rules, and finding rules that will yield shape-patterns (alternating ascenders and descenders, diagonals of letters with counters, etc) that have a certain type of readability.

##using the program
Left click creates new generations, and changing the global variable wantPDF to equal *true* will export a PDF to the program folder for every new generation. Right click exits the program, which is important if you're generating PDFs to save them correctly. If you want the PDF to be mirrored horizontally (useful as a letterpress type-setting template), change wantMirror to true also.

##examples
![one generation](http://ft3.fckitupload.com/k/black_static.png)

*a single generation*

![animation of several generations](http://ft3.fckitupload.com/kb/coloured_animation.gif)

*an animation of several generations, colour-coded to help identify how formal attributes change: green are letters with ascenders, purple are letters with descenders, and pink are letters with neither.*

Note: there is currently a logical error where letter objects that have been separated from allBlocks[] by being duplicated (to preserve the attributes of the parent if the child becomes capitalized, etc) will be the wrong colour when colour is enabled.