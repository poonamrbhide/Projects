'''
Created on Sep 18, 2013

@author: poonambhide
'''
import re
import urllib2
from bs4 import BeautifulSoup
import reppy
import time
from reppy.cache import RobotsCache
from urlparse import urljoin

# regex to check http links
regex = re.compile(
         r'^(?:http|ftp)s?://' # http:// or https://
         r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|' #domain...
         r'localhost|' #localhost...
         r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' # ...or ip
         r'(?::\d+)?' # optional port
         r'(?:/?|[/?]\S+)$', re.IGNORECASE)

# function to check for valid URL
def isurlvalid(url):
    if regex.match(url) is not None:
        return True;
    return False

# function to check the HTML content
def ishtmlcontent(pagecontent):
    t=pagecontent.info().getheader('Content-Type')
    if('text/html' in t):
        return True;
    return False
# function to remove duplicates from the list
def remove_duplicates(l):
    return list(set(l))

# function to find difference in 2 lists

def list_difference(l1,l2):
    return list(set(l1) - set(l2))

#function to crawl web pages
def crawl_Pages(Seed):
    r = RobotsCache()
    robots_url=urljoin(Seed,'/robots.txt')  
    x = r.fetch(robots_url)
    unvisited=[Seed]
    visited=[]
    cnt=0
    delay=5
    while unvisited:
        page=unvisited.pop(0)
        
        hdr={'User-Agent':'*'}
        try:
            req = urllib2.Request(page, headers=hdr)         
            pagecontent=urllib2.urlopen(req)            
            if page not in visited:
                time.sleep(delay)
                s=pagecontent.read()  
                if (ishtmlcontent(pagecontent)):          
                    soup=BeautifulSoup(s)
                    links=soup.findAll('a',href=True)     
                    for l in links:
                        if (isurlvalid(l['href'])):
                            u1=urljoin(page,l['href'])
                            unvisited.append(u1)
                    if x.allowed(page,'*'):
                        visited.append(page)
                        cnt=cnt+1
                        print cnt
                        print 'Crawled:'+page
                        visited=remove_duplicates(visited)
                else:
                    if(page.endswith(".pdf")):
                        visited.append(page)
                        cnt=cnt+1
                        print 'Crawled:'+page
                        visited=remove_duplicates(visited)
            if(len(visited)==100):
                    unvisited=[]
        except Exception, err:
            print Exception, err
            continue
    return visited

visitedurls=crawl_Pages('http://www.ccs.neu.edu')
