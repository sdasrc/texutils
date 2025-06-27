import numpy as np
import csv, sys, os
'''
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
'''
# ==================================== #
#       V A L I D A T E   I N P        #
# ==================================== #
workdir = os.getcwd()
if workdir[-1]!='/': workdir=workdir+'/'
    
if len(sys.argv) < 2:
    print("Use as :: python generate_authors.py <csvfile>")
    exit()

inpcsvfile = str(sys.argv[1].strip())
print(inpcsvfile)
if inpcsvfile[-4:].lower() != '.csv': inpcsvfile=inpcsvfile+'.csv'
    
if not os.path.isfile(inpcsvfile):
    inpcsvfile = workdir+inpcsvfile
    if not os.path.isfile(inpcsvfile):
        print("Please supply a valid csv file with inputs")
        exit()


# ==================================== #
#       D E F I N E   V A R S          #
# ==================================== #
authfile = workdir+'authlist.tex'
instfile = workdir+'instlist.tex'
ackfile = workdir+'acklist.tex'
authemail = 'soumyadeep.das.m44@gmail.com'
linelim = 112 # how many characters can be in one line before it goes to a new line
doseparate = False
doinitials = False
# needed only if we do separate sections
extraStr = "\\textit{Affiliations are listed in Appendix \\ref{sec:affiliations}}." 

# ==================================== #
#       R E A D   F I L E              #
# ==================================== #
authors, instis, acknos = [], [], []
# read values from the CSV file
with open(inpcsvfile) as csvfile:
    tt = csv.reader(csvfile)
    for row in tt:
        autharr = row[0].split(',')
        aname = autharr[1].strip()+' '+autharr[0].strip() if len(autharr) == 2 else row[0].strip()
        if doinitials:
            autharr = aname.split(' ')
            aname = ''
            if len(autharr) > 1:
                for aa in autharr[:-1]: aname=aname+aa[0].upper()+'. '
            aname =  aname+autharr[-1]  
        
        authors.append(aname)
        instis.append(row[1].strip())
        acknos.append(row[2].strip())
        
authors, instis, acknos  = np.array(authors[1:]), np.array(instis[1:]), np.array(acknos[1:])    

# ==================================== #
#       H A N D L E  A F F I L         #
# ==================================== #
instis_individual = []
for ti in instis: 
    instarr = [tt.strip() for tt in ti.split(';')]
    instis_individual.extend(instarr)
insti_dict = {}
cnt = 1
for tt in instis_individual:
    if tt not in insti_dict.keys():
        insti_dict[tt.strip()] = str(cnt)
        cnt+=1
        
if doseparate:
    # write into a separate tex file
    with open(instfile,'w') as f:
        for tt in insti_dict:
            print("$^{"+str(insti_dict[tt])+"}$\\footnotesize{\\textit{"+tt+"}} \\\\",file=f)
    print("Affiliations saved into "+instfile)     
    print("Include the following in your tex:")
    print("\\section{Author Affiliations} \\label{sec:affiliations}")
    print("\\input{"+instfile.split('/')[-1]+"}")
                
else:
    instiStr = ""
    for tt in insti_dict:
        instiStr = instiStr+"$^{"+str(insti_dict[tt])+"}$"+tt+" \\\\ \n"
        
# ==================================== #
#       H A N D L E  A U T H O R S     #
# ==================================== #
authstrs = []
nauthstr, dispauthstr = "", ""


for ii in range(len(authors)):
    auth_insts = instis[ii].split(';')
    if len(auth_insts) > 1:
        auth_instids = [insti_dict[ta.strip()] for ta in auth_insts]
        auth_instid = ','.join(np.unique(auth_instids))
    else:
        auth_instid = insti_dict[auth_insts[0]]
        
    dispauthstr = dispauthstr + authors[ii]+auth_instid+', '
    if len(dispauthstr) > linelim:
        authstrs.append(nauthstr)
        nauthstr = ""
        dispauthstr = authors[ii]+auth_instid+', '
        nauthstr = "\\newauthor "
        
    if ii == 0:
        nauthstr = "\\author["+authors[ii]+" et al.]{"+authors[ii]+\
                   "$^{"+auth_instid+"}$\\thanks{E-mail: "+authemail+"},\n"
    else:
        nauthstr = nauthstr+authors[ii]+'$^{'+auth_instid+'}$, '

if doseparate:
    nauthstr = nauthstr[:-2]+"\\vspace{0.4cm}\\\\\\\\ \n "+extraStr+"\n}"  
else:
    nauthstr =  nauthstr[:-2]+"\n \\vspace{0.4cm}\\\\\\\\ \n "+instiStr+"}" 
authstrs.append(nauthstr)

with open(authfile,'w') as f:
    for aa in authstrs:
        print(aa, file=f)
        
print("Authorlist saved into "+authfile)     
print("Include the following in your tex :: \\input{"+authfile.split('/')[-1]+"}")
        
# ==================================== #
#       H A N D L E  A C K N O W S     #
# ==================================== #    
ackStr_static_pre = ""
ackStr_static_post = ""    
ackStr = ""
for aa in acknos:
    if len(aa) > 1:
        aa = " ".join(aa.split())
        if aa[-1] != '.': aa = aa+'.'
        ackStr = ackStr+" "+aa

ackStr = ackStr_static_pre.rstrip()+" "+ackStr+" "+ackStr_static_post.lstrip()

with open(ackfile,"w") as f:
    print(ackStr,file=f)
    
print("Affiliations saved into "+ackfile)    