'''
Created on Oct 15, 2013

@author: poonambhide
'''


from __future__ import division
from collections import namedtuple
import sys
try:
    fname=sys.argv[-1]
    #fname="test.txt"
    f = open(fname,"r")
    # Data Structures 
    
    # Contains the page details which includes 
    # 1.Page/DocumentID has key 
    # 2.It's page rank  
    # 3.Incoming page array as values
    all_page_details = {}
    nt = namedtuple('Attributes',['pagerank','incominlinkarray'])
    
    # Contains the page details which includes 
    # 1.Page/DocumentID has key 
    # 2.Outlink count 
    page_outlink_details = {}
    ntout = namedtuple('Attributes',['outlinkcount'])
    
    # Contains the sink page (with outlink count=0) details which includes 
    # 1.Page/DocumentID has key 
    # 2.It's page rank  
    # 3.Incoming page array as values
    sink_page_details={}
    
    # Contains the page details which includes 
    # 1.Page/DocumentID has key 
    # 2.It's page rank  
    # 3.Incoming page array as values
    new_page_details={}
    
    # Number of pages : N
    allPages=f.readlines()
    N= len(allPages)
       
    # Required variables
    arr=[1,10,100]
    init_prob=1/N
    cnt=0
    pagnamearray=[]
    sinkpagenamearray=[]
    sinkPR=0
    d=0.85

    #Creating required data structures
    for line in allPages:
        words = line.split()
        pagename=words.pop(0)         
        all_page_details[pagename]=nt(init_prob,words)
        pagnamearray.append(pagename)
        if(pagename not in page_outlink_details):
            page_outlink_details[pagename]=ntout(0)
        for  q in all_page_details[pagename].incominlinkarray:
            if(q not in page_outlink_details):
                page_outlink_details[q]=ntout(1)
            else:
                temp= page_outlink_details[q].outlinkcount+1
                page_outlink_details[q]=ntout(temp)

    temp_page_details=dict(all_page_details)
    # Creating sink page list
    for pagename in pagnamearray:        
        if(page_outlink_details[pagename].outlinkcount==0):
            sinkpagenamearray.append(pagename)
            sink_page_details[pagename]=nt(all_page_details[pagename].pagerank,all_page_details[pagename].incominlinkarray)
    
    print "Initial Value"
    for p in pagnamearray:
        print "Page : %s PageRank: %f Incoming link Count:%d Outlink Count: %d" %(p, all_page_details[p].pagerank,len(all_page_details[p].incominlinkarray),page_outlink_details[p].outlinkcount)

    # Page rank algorithm
    for n in arr:
        cnt=0
        all_page_details=dict(temp_page_details)
        while(cnt<n):
            sinkPR=0
            for  p in sinkpagenamearray:               
                sinkPR += all_page_details[p].pagerank
            for p in pagnamearray:
                newPR=(1-d)/N
                newPR=newPR+(d*sinkPR/N)
                for  q in all_page_details[p].incominlinkarray:         
                    newPR += d*(all_page_details[q].pagerank/page_outlink_details[q].outlinkcount)
                t=nt(newPR,all_page_details[p].incominlinkarray) 
                new_page_details[p]=t
            all_page_details=dict(new_page_details)
            cnt=cnt+1      
        # Sorting the pages as per page rank and taking top 50
        print "n=%d" %n
        num=0
        for key, value in sorted(all_page_details.iteritems(), key=lambda x: x[1].pagerank,reverse=True):
            if(num<50):
                print "Page : %s PageRank: %f Incoming link Count:%d Outlink Count: %d" %(key, value.pagerank,len(value.incominlinkarray),page_outlink_details[key].outlinkcount)
                num=num+1
            else:
                break
            
except IOError as e:
    print "I/O error({0}): {1}".format(e.errno, e.strerror)
except ValueError:
    print "Could not convert data to an integer."
except:
    print "Unexpected error:", sys.exc_info()[0]
     
    
