/*
Enter your query here.
Please append a semicolon ";" at the end of the query and enter your query in a single line to avoid error.



Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. The output column headers should be Doctor, Professor, Singer, and Actor, respectively.

Note: Print NULL when there are no more names corresponding to an occupation.

Input Format

The OCCUPATIONS table is described as follows:



Occupation will only contain one of the following values: Doctor, Professor, Singer or Actor.

Sample Input



Sample Output

Jenny    Ashley     Meera  Jane
Samantha Christeen  Priya  Julia
NULL     Ketty      NULL   Maria
Explanation

The first column is an alphabetically ordered list of Doctor names.
The second column is an alphabetically ordered list of Professor names.
The third column is an alphabetically ordered list of Singer names.
The fourth column is an alphabetically ordered list of Actor names.
The empty cell data for columns with less than the maximum number of names per occupation (in this case, the Professor and Actor columns) are filled with NULL values.

*/


/*
select
    Doctor,
    Professor,
    Singer,
    Actor
from (
    select
        NameOrder,
        max(case Occupation when 'Doctor' then Name end) as Doctor,
        max(case Occupation when 'Professor' then Name end) as Professor,
        max(case Occupation when 'Singer' then Name end) as Singer,
        max(case Occupation when 'Actor' then Name end) as Actor
    from (
            select
                Occupation,
                Name,
                row_number() over(partition by Occupation order by Name ASC) as NameOrder
            from Occupations
         ) as NameLists
    group by NameOrder
    ) as Names

*/
/*
select
        NameOrder,
        max(case Occupation when 'Doctor' then Name end) as Doctor,
        max(case Occupation when 'Professor' then Name end) as Professor,
        max(case Occupation when 'Singer' then Name end) as Singer,
        max(case Occupation when 'Actor' then Name end) as Actor
        from(
select
                Occupation,
                Name,
                row_number() over(partition by Occupation order by Name ASC) as NameOrder
            from Occupations) as NameList
            group by NameOrder
            
*/
SELECT 
    Doctor,
    Professor,
    Singer,
    Actor
FROM(
    SELECT
        NameOrder,
        MAX(CASE occupation WHEN 'Doctor' THEN name END) as Doctor,
        MAX(CASE occupation WHEN 'Professor' THEN name END) as Professor,
        MAX(CASE occupation WHEN 'Singer' THEN name END) as Singer,
        MAX(CASE occupation WHEN 'Actor' THEN name END) as Actor
    FROM(
        SELECT
            occupation,
            name,
            ROW_NUMBER() OVER(PARTITION BY occupation ORDER BY name ASC) as NameOrder
        FROM occupations
    ) as NameList
    GROUP BY NameOrder
) as Names


/*
You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.
Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:

Root: If node is root node.
Leaf: If node is leaf node.
Inner: If node is neither root nor leaf node.
Sample Input
*/

-- first Solution
select n,case when n = (select n 
                        from bst
                        where p is null) then 'Root'
         when n in (select n from bst where p in (
                        select n 
                        from bst
                        where p is null)) then 'Inner'
        when n in (select n from bst where p in (select n from bst where p=(
                        select n 
                        from bst
                        where p is null))) then 'Inner'
        else 'Leaf' end as NodeType
from bst
order by n;

-- Second Solution
select n,case when n = (select n 
                        from bst
                        where p is null) then 'Root'
         when n in (select n 
                    from bst where n in (select p 
                                        from bst 
                                        group by p 
                                        having p is not null)) 
                                        then 'Inner'
        
        else 'Leaf' end as NodeType
from bst
order by n;