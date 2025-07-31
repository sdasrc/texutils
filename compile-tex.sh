# RUNTEX SCRIPT - FOR EASILY COMPILING TEX FILES WITHOUT 
# THE HASSLE OF IDES
# WRITTEN BY SOUMYADEEP DAS
# -------------------------------------------
# No Arguments given
if [[ -z "$1" ]] ; then  
    echo "Welcome to runtex, cli script for running tex files."
    mycase=99
# Single Argument
elif [ "$#" -eq 1 ]; then
    if [[ $1 = "-c" ]]; then
        mycase=5
        filename="NoFilenameGiven"        
    else
        echo "Will run pdf,bib,pdf,pdf on $1.tex"
        filename=$1
        mycase=1
    fi
# Two arguments
elif [ "$#" -eq 2 ]; then
    if [ $1 = "-b" ]; then
        mycase=1
        filename=$2
    elif [ $1 = "-p" ]; then
        mycase=2
        filename=$2
    elif [ $1 = "-x" ]; then
        mycase=3
        filename=$2
    elif [ $1 = "-l" ]; then
        mycase=4
        filename=$2
    elif [ $1 = "-c" ]; then
        mycase=5
        filename=$2
    elif [ $1 = "-ma" ]; then
        mycase=6
        filename=$2
    elif [ $1 = "-mb" ]; then
        mycase=7
        filename=$2
    else
        echo "Please check your inputs and try again."
        mycase=99
    fi
else    
    echo "Please check your inputs and try again."
    mycase=99
fi

if [ $mycase -eq 99 ]; then
    echo "Usage : runtex [param:-bpxlc] [filename]"
    echo "[filename] to be entered without .tex extension."
    echo "List of [param] :"
    echo "-ma [filename]: Will create dir 'filename' with article .tex and .bib."
    echo "-mb [filename]: Will create dir 'filename' with beamer .tex and .bib."
    echo "-b [filename]: Will run pdf -> bib -> pdf -> pdf [Default]"
    echo "-p [filename]: Will run only pdf on filename.tex"
    echo "-x [filename]: Will run only xe on filename.tex"
    echo "-l [filename]: Will run only lua on filename.tex"
    echo "-c [filename]: Clear the temporary files."
    echo "pdf (pdflatex), bib (bibtex), xe (xelatex), lua (lualatex)."
else
    echo "Welcome to Runtex!"
    filename=${filename%.tex}        
    echo "File is $(pwd)/$filename.tex"
    mkdir -p "$(pwd)/.statsfornerds"
    echo ""
    echo "Cleaning please wait ..."
    rm -f *~
    find . -name \*.aux -type f -delete 
    find . -name \*.blg -type f -delete 
    find . -name \*.d -type f -delete 
    find . -name \*.fls -type f -delete 
    find . -name \*.ilg -type f -delete 
    find . -name \*.ind -type f -delete 
    find . -name \*.toc* -type f -delete 
    find . -name \*.lot* -type f -delete 
    find . -name \*.lof* -type f -delete 
    find . -name \*.log -type f -delete 
    find . -name \*.idx -type f -delete 
    find . -name \*.out* -type f -delete 
    find . -name \*.nlo -type f -delete 
    find . -name \*.nls -type f -delete 
    rm -rf $filename.pdf
    rm -rf $filename.ps
    rm -rf $filename.dvi
    rm -rf *#* 
    echo "Cleaning complete!"
    echo ""
    echo "Compiling your tex file...please wait...!"
fi

thistime=$(date +%s)

if [ $mycase -eq 1 ] ; then
    pdflatex -interaction=nonstopmode $filename.tex
    bibtex $filename.aux    
    makeindex $filename.aux
    makeindex $filename.idx
    makeindex $filename.nlo -s nomencl.ist -o $filename.nls
    pdflatex -interaction=nonstopmode $filename.tex
    makeindex $filename.nlo -s nomencl.ist -o $filename.nls
    pdflatex -interaction=nonstopmode $filename.tex
    echo " ------ "
    echo ""
    bibwarncount=$(grep "Warning--missing publisher in" "$filename.blg" | wc -l)
    biberrcount=$(grep "Warning--I didn't find a database entry for" "$filename.blg" | wc -l)
    echo "============================================="
    echo "I found $biberrcount errors and $bibwarncount warnings in your bibs:"
    echo ""
    grep "Warning--I didn't find a database entry for" "$filename.blg"
    echo ""
    grep "Warning--missing publisher in" "$filename.blg"
    echo ""
    citcount=$(grep -P "You've used [0-9]+ entries," -m 1 "$filename.blg" | grep -P "[0-9]+" -o)
    wordcount=$(texcount $filename.tex -inc -incbib -sum -1)
    echo "Word count : $wordcount, citations : $citcount"
    echo "$thistime    $wordcount" >> "$(pwd)/.statsfornerds/wordcount.dat"
    echo "$thistime    $citcount" >> "$(pwd)/.statsfornerds/citcount.dat"
elif [ $mycase -eq 2 ] ; then
    pdflatex $filename.tex
elif [ $mycase -eq 3 ] ; then
    # xelatex $filename.tex
    xelatex -interaction=nonstopmode $filename.tex
    bibtex $filename.aux    
    makeindex $filename.aux
    makeindex $filename.idx
    makeindex $filename.nlo -s nomencl.ist -o $filename.nls
    xelatex -interaction=nonstopmode $filename.tex
    makeindex $filename.nlo -s nomencl.ist -o $filename.nls
    xelatex -interaction=nonstopmode $filename.tex
    echo " ------ "
    echo ""
    
    bibwarncount=$(grep "Warning--missing publisher in" "$filename.blg" | wc -l)
    biberrcount=$(grep "Warning--I didn't find a database entry for" "$filename.blg" | wc -l)
    echo "============================================="
    echo "I found $biberrcount errors and $bibwarncount warnings in your bibs:"
    echo ""
    grep "Warning--I didn't find a database entry for" "$filename.blg"
    echo ""
    grep "Warning--missing publisher in" "$filename.blg"
    echo ""
    citcount=$(grep -P "You've used [0-9]+ entries," -m 1 "$filename.blg" | grep -P "[0-9]+" -o)
    wordcount=$(texcount $filename.tex -inc -incbib -sum -1)
    echo "Word count : $wordcount, citations : $citcount"
    echo "$thistime    $wordcount" >> "$(pwd)/.statsfornerds/wordcount.dat"
    echo "$thistime    $citcount" >> "$(pwd)/.statsfornerds/citcount.dat"
elif [ $mycase -eq 4 ] ; then
    # lualatex $filename.tex
    lualatex -interaction=nonstopmode $filename.tex
    bibtex $filename.aux    
    makeindex $filename.aux
    makeindex $filename.idx
    makeindex $filename.nlo -s nomencl.ist -o $filename.nls
    lualatex -interaction=nonstopmode $filename.tex
    makeindex $filename.nlo -s nomencl.ist -o $filename.nls
    lualatex -interaction=nonstopmode $filename.tex
    echo " ------ "
    echo ""
    bibwarncount=$(grep "Warning--missing publisher in" "$filename.blg" | wc -l)
    biberrcount=$(grep "Warning--I didn't find a database entry for" "$filename.blg" | wc -l)
    echo "============================================="
    echo "I found $biberrcount errors and $bibwarncount warnings in your bibs:"
    echo ""
    grep "Warning--I didn't find a database entry for" "$filename.blg"
    echo ""
    grep "Warning--missing publisher in" "$filename.blg"
    echo ""
    citcount=$(grep -P "You've used [0-9]+ entries," -m 1 "$filename.blg" | grep -P "[0-9]+" -o)
    wordcount=$(texcount $filename.tex -inc -incbib -sum -1)
    echo "Word count : $wordcount, citations : $citcount"
    echo "$thistime    $wordcount" >> "$(pwd)/.statsfornerds/wordcount.dat"
    echo "$thistime    $citcount" >> "$(pwd)/.statsfornerds/citcount.dat"
elif [ $mycase -eq 5 ] ; then
    echo "Do you want to clear 'converted-to.pdf's? [Y = 1, N = 0] : "
    read CLRCONV
    if [ $CLRCONV -eq 1 ] ; then
        find . -name \*converted-to.pdf\* -type f -delete 
        echo "Removed converted-to.pdf files."
    fi
    echo "Temp and Output files cleared."
elif [ $mycase -eq 6 ] ; then
    echo "Do you want to add a date string at the beginning [Y = 1, N = 0] : "
    read AADDDATE
    if [ $AADDDATE -eq 1 ] ; then
        tdate=$(date '+%Y-%M-%d-')
        filename="$tdate$filename"
    fi
    mkdir $filename
    cp /home/overlord/git/bashscripts/tex_templates/article_template/2021-11-05-elaisn1-prospector-first-obj.tex "$PWD/$filename/$filename.tex"
    echo "\bibliography{$filename}" >> "$PWD/$filename/$filename.tex"
    echo "\end{document}" >> "$PWD/$filename/$filename.tex"
    cp /home/overlord/git/bashscripts/tex_templates/article_template/2021-11-05-elaisn1-prospector-first-obj.bib "$PWD/$filename/$filename.bib"
    cp /home/overlord/git/bashscripts/tex_templates/article_template/mnras.bst "$PWD/$filename/mnras.bst" 
    echo "LaTeX article $filename/$filename.tex created."
elif [ $mycase -eq 7 ] ; then
    echo "Do you want to add a date string at the beginning [Y = 1, N = 0] : "
    read BADDDATE
    if [ $BADDDATE -eq 1 ] ; then
        tdate=$(date '+%Y-%M-%d-')
        filename="$tdate$filename"
    fi
    mkdir $filename
    cp /home/overlord/git/bashscripts/tex_templates/beamer_template/sdas_interview_slides.tex "$PWD/$filename/$filename.tex"
    # echo "\bibliography{$filename}" >> "$PWD/$filename/$filename.tex"
    # echo "\end{document}" >> "$PWD/$filename/$filename.tex"
    # cp /home/overlord/git/bashscripts/tex_templates/beamer_template/2021-11-05-elaisn1-prospector-first-obj.bib "$PWD/$filename/$filename.bib"
    cp /home/overlord/git/bashscripts/tex_templates/beamer_template/combined.pdf "$PWD/$filename/mnras.bst"
    echo "LaTeX beamer $filename/$filename.tex created."    
fi




