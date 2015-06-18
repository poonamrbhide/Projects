-- Query 1 
--Show all publications under topic Computer Science
-- If a researcher wants to view publications related to a particular btopic like in this case Computer Science
-- he can view those  

select pub.title,
pub.abstract,
pub.publicationviews,
s.name,
t.name from 
publications pub join subtopics s on pub.subtopicid=s.subtopicid 
join topics t on  s.topics_topicid=t.topicid
where t.name ilike 'Computer Science'

----3194 rows


------------------------------------------------------------------------------------------------------

-- Query 2
-- Researchers with their total number of publications
-- These details are usually shown in a researcher's profile page.


with all_first_authors as
(select  u.firstname ||' ' || u.lastname as researchername ,
pub.title from researcher r 
join researcher_has_publications rpub on rpub.researcher_researcherid=r.researcherid
join publications pub on pub.publicationid=rpub.publications_publicationid
join users u on u.userid=r.researcherid
order by researchername)

select count(researchername) as cnt,researchername from all_first_authors
group by researchername

--- 192141 Rows


------------------------------------------------------------------------------------------------------

-- Query 3
 -- Find number of citations of publications by author with id =---.
 -- There are many applications where one needs to show the citations for the publications by a researcher
 
 
 with all_publications_by_author as
(select pub.publicationid from researcher r 
join researcher_has_publications rpub on rpub.researcher_researcherid=r.researcherid
join publications pub on pub.publicationid=rpub.publications_publicationid
join users u on u.userid=r.researcherid
where u.userid=98142 ),

cited as
(select publications_publicationid as pubids from publications_has_reference_to_publications
where publications_referencepublicationid in (select * from all_publications_by_author))
 
select distinct count(*) from 
publications pub join 
cited refpub on pub.publicationid=refpub.pubids

-- 2 rows 

------------------------------------------------------------------------------------------------------

-- Query 4
--- Find number of citations for a given researchers.

 with all_publications_by_author as

(select rpub.publications_publicationid as publicationid,
        r.researcherid as researcher_id 
        from researcher r 
        join researcher_has_publications rpub on rpub.researcher_researcherid=r.researcherid
       
),
cited_by as
(select pp.publications_publicationid as pubids,allp.researcher_id  from publications_has_reference_to_publications pp
 join all_publications_by_author allp on pp.publications_referencepublicationid=allp.publicationid),

total_citations_by_researcher as
(select  count(*) as count_max,researcher_id from 
publications pub join 
cited_by refpub on pub.publicationid=refpub.pubids
group by researcher_id order by  count(*) desc) 

select (u.firstname ||' ' || u.lastname) as name,tot.count_max,tot.researcher_id
from users u join total_citations_by_researcher tot 
on u.userid=tot.researcher_id 
order by tot.count_max desc

-- 193766 Rows
------------------------------------------------------------------------------------------------------

-- Query 5
--- Researcher score for a given  researcher.

-- Score can be calculated by following parameters
-- Each parameter has some weight-age
   --- 1. Whose publication has maximum citations : 0.4
   ----2. Number of followers	: 0.1		
   ----3. Contribution to answers and questions : 0.2
   ----4. Number of papers/publications 0.3
-- Score is determined by calculating the sum based upon these parameters.
   

 with all_publications_by_author as

(select rpub.publications_publicationid as publicationid,
        r.researcherid as researcher_id 
        from researcher r 
        join researcher_has_publications rpub on rpub.researcher_researcherid=r.researcherid
        where r.researcherid = 921
),
cited_by as
(select pp.publications_publicationid as pubids,allp.researcher_id  from publications_has_reference_to_publications pp
 join all_publications_by_author allp on pp.publications_referencepublicationid=allp.publicationid),
-- Citations
total_citations_by_researcher as
(select  count(*) as no_of_citation,researcher_id from 
publications pub join 
cited_by refpub on pub.publicationid=refpub.pubids
group by researcher_id order by  count(*) desc),
-- Publications 
total_publications_by_researcher as
(select count(*) as no_of_publication,researcher_id from all_publications_by_author
group by researcher_id),
-- Answers answered
total_answers_answered as 
(select sum(numberofupvotes)/1000 as no_of_ans,replierid from answerthread ans join all_publications_by_author ap on ans.replierid=ap.researcher_id
group by replierid
),

total_followers as 
(select count(*) as no_of_followers,rf.researcherid  from researcher_has_followers rf join all_publications_by_author ap 
on rf.researcherid=ap.researcher_id
group by researcherid)

select (u.firstname ||' ' || u.lastname) as name,
tot.no_of_citation,u.userid,tpub.no_of_publication,tans.no_of_ans as answers_quality,tfs.no_of_followers,(0.4*tot.no_of_citation)+(0.3*tpub.no_of_publication)+(0.2*tans.no_of_ans)+(0.1*tfs.no_of_followers)  as Researcher_score
from users u 
join total_citations_by_researcher tot 
on u.userid=tot.researcher_id 
left outer join  total_publications_by_researcher tpub on u.userid=tot.researcher_id 
left outer join total_answers_answered tans on tans.replierid=u.userid
left outer join total_followers tfs on tfs.researcherid=u.userid
order by (0.4*tot.no_of_citation)+(0.3*tpub.no_of_publication)+(0.2*tans.no_of_ans)+(0.1*tfs.no_of_followers) desc

-- 1 row 
-- Researcher Score =2.1 for the researcher with Id 921

------------------------------------------------------------------------------------------------------
-- Query 6

---Find publications under "Physics" and display the result university wise. 

with publications_under_topic as
(
select 
    pub.publicationid,
    pub.title,
    pub.subtopicid,
    sub.name as subtopic_name,
    t.topicid,
    t.name as topic_name
from publications pub 
join subtopics sub on sub.subtopicid = pub.subtopicid
join topics t on t.topicid = sub.topics_topicid
where t.name ilike 'Physics'
),
publication_authors as
(
select 
    pt.publicationid, 
    rhp.researcher_researcherid as primary_author_id,
    rhp.publication_rank,
    pt.title, 
    pt.subtopicid, 
    pt.subtopic_name,
    pt.topicid, 
    pt.topic_name
from publications_under_topic pt
join researcher_has_publications rhp on rhp.publications_publicationid = pt.publicationid
where rhp.publication_rank = 1
)
select 
    pa.publicationid, 
    pa.title, 
    pa.primary_author_id,
    us.firstname || ' ' || us.lastname as primary_author_name,
    pa.subtopic_name,
    pa.topic_name,
    r.universityid,
    u.name as university_name
from publication_authors pa
join researcher r on r.researcherid = pa.primary_author_id
join university u on r.universityid = u.universityid
join users us on us.userid = pa.primary_author_id
order by universityid

-- 2256 Rows

------------------------------------------------------------------------------------------------------
-- Query 7
-- Find the followers of authors whose publication has maximum citations for a subtopic "Systems"

-- 7. A] Followers of Author with maximum citations for a subtopic
with subtopic_publications as
(
select 
    pub.publicationid,
    pub.title,
    pub.subtopicid,
    sub.name
from publications pub
join subtopics sub on pub.subtopicid = sub.subtopicid
and sub.name ilike 'Systems'
)
,
reference_publications as
(
select 
    sp.publicationid,
    sp.title,
    sp.subtopicid,
    sp.name,
    pref.publications_referencepublicationid as reference_pubplication_id
from subtopic_publications sp
join publications_has_reference_to_publications pref on 
    pref.publications_publicationid = sp.publicationid
),
citations as
(
select
    rp.publicationid,
    rp.title,
    rp.subtopicid,
    rp.name,
    rp.reference_pubplication_id,
    rpub.researcher_researcherid as researcher
        from reference_publications rp
    join researcher_has_publications rpub on 
    rp.reference_pubplication_id = rpub.publications_publicationid
),
count_researcher as
(
select  count(*) as count_max,
    researcher 
from citations
group by researcher),
max_researcher as
(
select researcher 
from count_researcher 
where count_max = (select max(count_max) from count_researcher) 
group by researcher
)
select
    mr.researcher as researcher_id,
    u.firstname || ' ' || u.lastname as researcher_name,
    rf.followerid,
    u1.firstname || ' ' || u1.lastname as follower_name
from max_researcher mr
join researcher_has_followers rf on rf.researcherid =  mr.researcher
join users u on u.userid = mr.researcher
join users u1 on u1.userid = rf.followerid

-- 1437 Rows

------------------------------------------------------------------------------------------------------
-- Query 7 B. Followers for authors of maximum cited publications for a subtopic
with subtopic_publications as
(
select 
    pub.publicationid,
    pub.title,
    pub.subtopicid,
    sub.name
from publications pub
join subtopics sub on pub.subtopicid = sub.subtopicid
and sub.name ilike 'Systems'
)
,reference_publications as
(
select 
    sp.publicationid,
    sp.title,
    sp.subtopicid,
    sp.name,
    pref.publications_referencepublicationid as reference_pubplication_id
    from subtopic_publications sp
    join publications_has_reference_to_publications pref on 
    pref.publications_publicationid = sp.publicationid
)
,count_publications as
(
select  count(*) as count_max,
    reference_pubplication_id
from reference_publications
group by reference_pubplication_id
)
,max_publication as
(
select reference_pubplication_id
from count_publications 
where count_max = (select max(count_max) from count_publications) 
group by reference_pubplication_id
)
,max_author as
(
select 
    mp.reference_pubplication_id,
    rpub.researcher_researcherid as researcher
from max_publication mp
join researcher_has_publications rpub on 
    mp.reference_pubplication_id = rpub.publications_publicationid
)
select
    ma.researcher as researcher_id,
    u.firstname || ' ' || u.lastname as researcher_name,
    rf.followerid,
    u1.firstname || ' ' || u1.lastname as follower_name
from max_author ma
join researcher_has_followers rf on rf.researcherid =  ma.researcher
join users u on u.userid = ma.researcher
join users u1 on u1.userid = rf.followerid

-- 1437 Rows
------------------------------------------------------------------------------------------------------
--Query 8 

-- Profile views daily/weekly/monthly for a particular researcher with name xxx

--Query 8 A.
-- Between two dates
select 
    r.researcherid,
    u.firstname || ' ' || u.lastname as researcher_name,
    ps.visitorid,
    u1.firstname || ' ' || u1.lastname as visitor_name,
    ps.visitingdate
from researcher r
join researcher_has_publications rhp on r.researcherid = rhp.researcher_researcherid
join users u on u.userid = r.researcherid
join profilestats ps on ps.researcherid = r.researcherid
join users u1 on u1.userid = ps.visitorid
where (u.firstname ilike 'ATKINSON') and (u.lastname ilike 'WILDER')
       and (ps.visitingdate >= ('2012-08-07')::date) and (ps.visitingdate < ('2013-01-10')::date)
-- 2 Rows

--Query 8 B.
-- Weekly View
create function weekly_stats (text,text,text) 
    returns setof record as $$
select 
    r.researcherid,
    u.firstname || ' ' || u.lastname as researcher_name,
    ps.visitorid,
    u1.firstname || ' ' || u1.lastname as visitor_name,
    ps.visitingdate
from researcher r
join researcher_has_publications rhp on r.researcherid = rhp.researcher_researcherid
join users u on u.userid = r.researcherid
join profilestats ps on ps.researcherid = r.researcherid
join users u1 on u1.userid = ps.visitorid
where (u.firstname ilike $1) and (u.lastname ilike $2)
       and (ps.visitingdate >= ($3)::date) and (ps.visitingdate < (($3)::date + 7))
$$ language SQL

select * from weekly_stats ('ATKINSON', 'WILDER', '2012-10-07')
    as
    (researcherid integer,
     researcher_name varchar,
     visitorid integer,
     visitor_name varchar,
     visitingdate date
     )
-- 1 row


--Query 8 C.
--- Stored procedure monthly view

create function monthly_stats (text,text,text,text) 
    returns setof record as $$
select 
    r.researcherid,
    u.firstname || ' ' || u.lastname as researcher_name,
    ps.visitorid,
    u1.firstname || ' ' || u1.lastname as visitor_name,
    ps.visitingdate
from researcher r
join researcher_has_publications rhp on r.researcherid = rhp.researcher_researcherid
join users u on u.userid = r.researcherid
join profilestats ps on ps.researcherid = r.researcherid
join users u1 on u1.userid = ps.visitorid
where (u.firstname ilike $1) and (u.lastname ilike $2)
       and (date_part('Month',ps.visitingdate)::text = $3) and (date_part('Year',ps.visitingdate)::text = $4)
$$ language SQL

select * from monthly_stats ('ATKINSON', 'WILDER', '10','2012')
    as
    (researcherid integer,
     researcher_name varchar,
     visitorid integer,
     visitor_name varchar,
     visitingdate date
     )
-- 1 row
------------------------------------------------------------------------------------------------------

--Query 9

--9.1 Find references to publications which are publications
--9.2 Find only other types of references
--9.3 Find both type of references publication + book type references

-----------------------------------------------------------------------------------------------------
-- Find all references to publications where --- is first author. 
--"PHYLLIS BERGER"


-- 9.1 Find only reference publications
with authors_publications as
(
select --*
    r.researcherid,
    u.firstname || ' ' || u.lastname as author_name,
    rhp.publications_publicationid as publication_id,
    pub.title
from researcher r
join researcher_has_publications rhp on r.researcherid = rhp.researcher_researcherid
join users u on u.userid = r.researcherid
join publications pub on pub.publicationid = rhp.publications_publicationid
where rhp.publication_rank = 1 and (u.firstname ilike 'PHYLLIS') and (u.lastname ilike 'BERGER')
)
select ap.researcherid, ap.author_name, ap.publication_id, ap.title,
       pp.publications_referencepublicationid as reference_publication_id,
       p.title as reference_title
from authors_publications ap
join publications_has_reference_to_publications pp
    on pp.publications_publicationid = ap.publication_id
join publications p on p.publicationid = pp.publications_referencepublicationid

-- 3 rows
----------------------------------------------------------------------------------------

--9.2 Find only other references (non publication references)

with authors_publications as
(
select --*
    r.researcherid,
    u.firstname || ' ' || u.lastname as author_name,
    rhp.publications_publicationid as publication_id,
    pub.title
from researcher r
join researcher_has_publications rhp on r.researcherid = rhp.researcher_researcherid
join users u on u.userid = r.researcherid
join publications pub on pub.publicationid = rhp.publications_publicationid
where rhp.publication_rank = 1 and (u.firstname ilike 'PHYLLIS') and (u.lastname ilike 'BERGER')
)
select ap.researcherid, ap.author_name, ap.publication_id, 
       ap.title, 
       ref.referenceid,
       r.type as reference_type,
       r.text as reference_name
from authors_publications ap
left outer join publications_has_references ref on ref.publicationid = ap.publication_id
left outer join reference r on ref.referenceid = r.referenceid

-- 1 row

-------------------------------------------------------------------------------------------
-- 9.3 Find both types of references
-- References are of 2 types 1.Publication 2. Other like any book or reference to a video.
with authors_publications as
(
select --*
    r.researcherid,
    u.firstname || ' ' || u.lastname as author_name,
    rhp.publications_publicationid as publication_id,
    pub.title
from researcher r
join researcher_has_publications rhp on r.researcherid = rhp.researcher_researcherid
join users u on u.userid = r.researcherid
join publications pub on pub.publicationid = rhp.publications_publicationid
where rhp.publication_rank = 1 and (u.firstname ilike 'PHYLLIS') and (u.lastname ilike 'BERGER')
),
reference_publications as
(
select ap.researcherid, ap.author_name, ap.publication_id, ap.title,
       pp.publications_referencepublicationid as reference_publication_id,
       p.title as reference_title
from authors_publications ap
join publications_has_reference_to_publications pp
    on pp.publications_publicationid = ap.publication_id
join publications p on p.publicationid = pp.publications_referencepublicationid
)
select rp.researcherid, rp.author_name, rp.publication_id, 
       rp.title, rp.reference_publication_id,
       rp.reference_title,
       ref.referenceid,
       r.type as reference_type,
       r.text as reference_name
from reference_publications rp
left outer join publications_has_references ref on ref.publicationid = rp.publication_id
left outer join reference r on ref.referenceid = r.referenceid


-----------------------------------------------------------------------------------------------

--  Query 10
--- Find all questions and answers posted under "Database management" sub_topic
------------------------------------------------------------------------------------    
    
create function find_question_answers_subtopicwise (text) 
    returns setof record as $$
with forumdiscussion as
(
select 
  s.name as subtopic_name, 
  t.name as topic_name,
  q.discussionforumid,
  u.firstname || ' ' || u.lastname as questioner_name,
  q.question,
  q.description,
  a.answerid,
  a.answer,
  u1.firstname || ' ' || u1.lastname as replier_name,
  a.date as answer_date,
  a.numberofupvotes as NumberOfUpVotes,
  a.numberofdownvotes as NumberOfDownVotes, 
  a.immediateparentanswerid
from question q
join answerthread a on a.question_discussionforumid = q.discussionforumid
join subtopics s on q.subtopics_subtopicid = s.subtopicid
join topics t on s.topics_topicid = t.topicid
join researcher r on q.researcher_researcherid = r.researcherid
join users u on u.userid = r.researcherid
join researcher r1 on a.replierid = r1.researcherid
join users u1 on u1.userid = r1.researcherid
where s.name ilike $1
)
select
  fd.subtopic_name, 
  fd.topic_name,
  fd.discussionforumid,
  fd.questioner_name,
  fd.question,
  fd.description,
  fd.answerid,
  fd.answer,
  fd.replier_name,
  fd.answer_date,
  fd.NumberOfUpVotes,
  fd.NumberOfDownVotes, 
  fd.immediateparentanswerid,
  ans.answer
from forumdiscussion fd
left outer join answerthread ans on fd.immediateparentanswerid = ans.answerid
$$ language SQL

-------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- execute query
--Given the sub topic executes the stored procedure.
select * from find_question_answers_subtopicwise ('Database management')
    as
    (
        subtopic_name character varying(100),
        topic_name character varying(100),
        discussionforumid integer,
        questioner_name character varying(1000),
        question character varying(1000),
        description character varying(2000),        
        answerid integer,
        answer character varying(3000),    
        replier_name character varying(1000),
        answer_date date,            
        numberofupvotes integer,
        numberofdownvotes integer,
        immediateparentanswerid integer,
        replyanswer varchar
    )
-- 330 rows
-----------------------------------------------------------------------------------------------------