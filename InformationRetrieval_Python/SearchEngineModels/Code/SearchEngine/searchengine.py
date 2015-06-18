'''
Created on Nov 9, 2013

@author: poonambhide
'''
#from __future__ import division
import string,collections,re,urllib,math
# Hard coded links : 
queryFileName= "queryfile.txt"
stopwordfileName="stoplist.txt"
docidmappingfile="doclist.txt"
queryidarr=[]
querytermcollection=dict()
# Difference in 2 Lists 
def list_difference(l1,l2):
    diff = lambda l1,l2: filter(lambda x: x not in l2, l1)
    return diff(l1,l2)

# Average Query Length 
def average_query_length(allQueries):
    cnt=0
    for q in queryidarr:
        cnt=cnt+len(allQueries[q])
    return float(cnt/float(len(allQueries)))  


# Average Query Length 
def formquerytermcollection(allQueries):    
    for q in queryidarr:
        querytermcollection[q]=allQueries[q]
    
specialword=dict()
# Removing the number and punctuations 
def queries_preprocess(allQueries):
    cnt=0 
    allQueriesCollection=dict()
    for q in allQueries:
        t=q.split()[0:1]
        if (len(t)==1 and t[0].endswith(".")):
            id1=t[0].rstrip(".")
            id1=int(id1)    
        q=q.split()[1:]
        cntterm=0
        p=[]
        for t in q:
            if("-" in t):
                jointword=t.split("-")
                for subword in jointword:
                    subword=subword.translate(None, string.punctuation)
                    subword=subword.lower()
                    p.append(subword)
                    cntterm=cntterm+1
            else:
                temp=t
                if("." in t and ( temp.count(".")>1 or (temp.count(".")==1 and not temp.endswith(".")))):
                    t=t.translate(None, string.punctuation)
                    if(id1 in specialword.keys()):
                        specialword[id1]= specialword[id1].append(t.lower());
                        t=t.lower()
                    else:
                        arr=[]
                        arr.append(t.lower())
                        specialword[id1]=arr
                        t=t.lower()
                else:
                    t=t.lower()
                    t=t.translate(None, string.punctuation)
                p.append(t)        
                cntterm=cntterm+1              
        allQueries[cnt]=p   
        allQueriesCollection[id1]=p
        queryidarr.append(id1)
        cnt=cnt+1
    return allQueriesCollection

def getvector(queryterms,type,avgquerylength):
    querycollection=collections.Counter(queryterms)
    querylength=float(len(queryterms))
    vectorarray = dict()
    if type==1:
        for term in list(set (queryterms)):
            tf=querycollection[term]
            OKTF=float(tf/(tf + 0.5 + 1.5*querylength/avgquerylength))
           # print OKTF
            vectorarray[term]=OKTF
    return vectorarray

def createqueryObjectArray(queryarr,type):
    avgquerylength=average_query_length(queryarr)
    vectordict=dict()
    for id1 in queryidarr:
        vectorarray=getvector(queryarr[id1],type,avgquerylength)
        vectordict[id1]=vectorarray
        
    return vectordict

def remove_stop_words(allQueries,stopwordarray):
    newc=dict()
    for q in allQueries:
        newc[q]=list_difference(allQueries[q],stopwordarray)
        if (q in specialword.keys()):
            old_list=newc[q]+specialword[q]
            newc[q]=old_list         
    return newc      
    
# Read the Query file
queryfile = open(queryFileName,"r")
allQueries=queryfile.readlines()

docmapping=open(docidmappingfile,"r")
docmappingdict=dict()
alldocs=docmapping.readlines()

for line in alldocs:
    splitLine = line.split()
    docmappingdict[splitLine[0].strip()]=splitLine[1].strip()
    
noofdocuments= len(alldocs)
allQueries=queries_preprocess(allQueries)
stopwordsArray = [line.rstrip() for line in open(stopwordfileName)]

allQueries=remove_stop_words(allQueries,stopwordsArray)


outputfile= open("outfilevectorspace.txt", "w")
outputfileidf= open("outfileidf.txt", "w")
outputfilemaxlike= open("outfilemaxlikelyhood.txt", "w")

querylist= open("queries.txt", "w")

urladdress="http://fiji5.ccs.neu.edu/~zerg/lemurcgi/lemur.cgi?d=3&g=p&v="   
print average_query_length(allQueries)
print "Please wait... It may take some time.."
formquerytermcollection(allQueries)

queryvectorarray=createqueryObjectArray(allQueries,1)

for qid in sorted(queryidarr):
    doc_collection=dict()
    doc_collection_idf=dict()
    doc_max_likelihood=dict()
    doc_len_dict=dict()
    documenttermcollection=dict()
    for (term,wt) in queryvectorarray[qid].items():
        urladdress="http://fiji5.ccs.neu.edu/~zerg/lemurcgi/lemur.cgi?d=3&g=p&v="
        urladdress=urladdress+term
        text = urllib.urlopen(urladdress).read()
        data = re.compile(r'.*?<BODY>(.*?)<HR>', re.DOTALL).match(text).group(1)
        numbers = re.compile(r'(\d+)',re.DOTALL).findall(data)
        ctf,df = float(numbers[0]), float(numbers[1]) #take the ctf and df and convert to float
        inverted_list = map(lambda i: (int(numbers[2 + 3*i]),float(numbers[3 + 3*i]),
                                       float(numbers[4 + 3*i])),range(0, int(round((len(numbers) - 2)/3))))

        avgdoclength=288
        noofuniqueterms=166054
        for (docid,doclen,tf) in inverted_list:
            doc_len_dict[docid]=doclen;
            OKTF=float(tf/(tf + 0.5 + 1.5*doclen/avgdoclength))
            OKTF=float(OKTF*wt)
            OKTFwithIDF=OKTF*math.log10(noofdocuments/(df+1))
            
            maxquerylikelihood=math.log( (1+tf)/ (float (doclen + noofuniqueterms)))
          #  print maxquerylikelihood
            if docid not in documenttermcollection.keys():
                documenttermcollection[docid]=[]
            documenttermcollection[docid].append(term)
                
            if(docid  in doc_collection.keys()):
                doc_collection[docid]=doc_collection[docid]+OKTF
                doc_collection_idf[docid]=doc_collection_idf[docid] + OKTFwithIDF
          
                doc_max_likelihood[docid] = doc_max_likelihood[docid]+maxquerylikelihood   
   #doc_max_likelihood[docid],docid)
            else:
                doc_collection[docid]=OKTF
                doc_collection_idf[docid]=OKTFwithIDF
                doc_max_likelihood[docid]=maxquerylikelihood
    rel=0
    c=0
    #===========================================================================
    # for doc in sorted(doc_collection, key=doc_collection.get, reverse=True):
    #     c=c+1
    #     rel=doc_collection[doc]
    #     outputfile.write("%d\tQ0\t%s\t%d\t%f\tExp\n" %(qid,docmappingdict[str(doc)],c,rel))
    #     if(c==1000):
    #         break
    # print "-----------------with idf-----------"
    # c=0
    # for doc in sorted(doc_collection_idf, key=doc_collection_idf.get, reverse=True):
    #     c=c+1
    #     rel=doc_collection_idf[doc]
    #     outputfileidf.write("%d\tQ0\t%s\t%d\t%f\tExp\n" %(qid,docmappingdict[str(doc)],c,rel))
    #     if(c==1000):
    #         break
    #===========================================================================
    
    c=0
    
    
    for doc in documenttermcollection:
        for aTerm in querytermcollection[qid]:
            if aTerm not in documenttermcollection[doc]:
                doc_max_likelihood[doc] = doc_max_likelihood[doc] + math.log( 1/float(doc_len_dict[doc] + noofuniqueterms))
    #print sorted(doc_max_likelihood, key=doc_max_likelihood.get, reverse=True)
    #for doc in sorted(doc_max_likelihood, key=doc_max_likelihood.get, reverse=True):
#         c=c+1
#         print querytermcollection[qid]
#         print documenttermcollection[doc]
#         if(len(list_difference(querytermcollection[qid],documenttermcollection[doc]))>0):
#             doc_max_likelihood[doc] = doc_max_likelihood[doc] + math.log(len(list_difference(querytermcollection[qid],documenttermcollection[doc]))*(1/(float(doc_len_dict[doc]+noofuniqueterms))))  
# 
#         print doc_max_likelihood[doc]
      
    c=0
    for doc in sorted(doc_max_likelihood, key=doc_max_likelihood.get, reverse=True):
        c=c+1
        rel=doc_max_likelihood[doc]
        outputfilemaxlike.write("%d\tQ0\t%s\t%d\t%f\tExp\n" %(qid,docmappingdict[str(doc)],c,rel))
        if(c==1000):
            break
        
    
print "Completed Successfully.."

