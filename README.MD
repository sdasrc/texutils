Simple tex utilities.

## COMPILE TEX

      Usage : runtex [param:-bpxlc] [filename]
      [filename] to be entered without .tex extension.
      List of [param] :
      -ma [filename]: Will create dir 'filename' with article .tex and .bib.
      -mb [filename]: Will create dir 'filename' with beamer .tex and .bib.
      -b [filename]: Will run pdf -> bib -> pdf -> pdf [Default]
      -p [filename]: Will run only pdf on filename.tex
      -x [filename]: Will run only xe on filename.tex
      -l [filename]: Will run only lua on filename.tex
      -c [filename]: Clear the temporary files.
      pdf (pdflatex), bib (bibtex), xe (xelatex), lua (lualatex).


## GENERATE AUTHORLIST

      Use as :: python generate_authors.py <csvfile>
      - CSV file with 3 columns - Col1 Names, Col2 Affiliations, Col3 Acknowledgements
         - Names can be either Firstname Lastname or Lastname, Firstname (comma sep)
         - Multiple affiliations are to be separated by semi-colons
         - Acknowledgements are optional
         
      (Note : Please copy this script to the folder with the csvfile)
         
      Necessary variables
      - filenames (with .tex extension) for the authorlist, affiliation list, acknowledgement list
      - email
      - linelim : How many characters in printed in each line of authors before newline is added
      - doseparate : Do you want separate files for author and affiliations
      - doinitials : Print only author initials
      - extrastr : Reference the separate affiliation section, if doseparate

      Outputs
      - The files, as described above