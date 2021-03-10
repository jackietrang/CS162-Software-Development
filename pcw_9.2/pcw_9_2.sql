PRAGMA automatic_index=off;
.mode column
.headers on

-- CREATE SOME TABLES
CREATE TABLE TEST1 (
    id INT,
    x INT DEFAULT(ABS(RANDOM() / 17592186044416)),
    y INT DEFAULT(ABS(RANDOM() / 17592186044416)),
    z INT DEFAULT(ABS(RANDOM() / 17592186044416))
);
CREATE TABLE TEST2 (
    id INT,
    x INT DEFAULT(ABS(RANDOM() / 17592186044416)),
    y INT DEFAULT(ABS(RANDOM() / 17592186044416)),
    z INT DEFAULT(ABS(RANDOM() / 17592186044416))
);
CREATE TABLE TEST3 (
    id INT,
    x INT DEFAULT(ABS(RANDOM() / 17592186044416)),
    y INT DEFAULT(ABS(RANDOM() / 17592186044416)),
    z INT DEFAULT(ABS(RANDOM() / 17592186044416))
);

-- PUT RANDOM DATA IN THEM
INSERT INTO TEST1 (id) WITH TempIDs(id) AS
  (VALUES(1) UNION ALL SELECT id+1 FROM TempIDs WHERE id < 10000 )
  SELECT id FROM TempIDs;

INSERT INTO TEST2 (id) WITH TempIDs(id) AS
  (VALUES(1) UNION ALL SELECT id+1 FROM TempIDs WHERE id < 10000 )
  SELECT id FROM TempIDs;

INSERT INTO TEST3 (id) WITH TempIDs(id) AS
  (VALUES(1) UNION ALL SELECT id+1 FROM TempIDs WHERE id < 10000 )
  SELECT id FROM TempIDs;


-- Now we have 3 large tables with random numbers in them
SELECT COUNT(*) AS TEST1SIZE FROM TEST1;
SELECT COUNT(*) AS TEST2SIZE FROM TEST2;
SELECT COUNT(*) AS TEST3SIZE FROM TEST3;

SELECT * FROM TEST1 LIMIT 10;

SELECT "SLOW QUERY";

EXPLAIN QUERY PLAN SELECT COUNT(*) FROM TEST1 t1
    JOIN TEST2 t2 ON (t1.x) = (t2.x)
    JOIN TEST3 t3 ON (t1.y) = (t3.y)
    WHERE t3.z > t1.z;

.timer ON
SELECT COUNT(*) FROM TEST1 t1
    JOIN TEST2 t2 ON (t1.x) = (t2.x)
    JOIN TEST3 t3 ON (t1.y) = (t3.y)
    WHERE t3.z > t1.z;
    

SELECT "FAST QUERY";

CREATE INDEX idx_t1_xyz ON TEST1(x,y,z);
CREATE INDEX idx_t2_x ON TEST2(x);
CREATE INDEX idx_t3_yz ON TEST3(y, z);
EXPLAIN QUERY PLAN SELECT COUNT(*) FROM TEST1 
    LEFT  JOIN TEST2 ON TEST1.x = TEST2.x
    LEFT JOIN TEST3 ON TEST1.y = TEST3.y
    WHERE
        TEST3.z > TEST1.z;

.timer ON
EXPLAIN QUERY PLAN SELECT COUNT(*) FROM TEST1 
    LEFT  JOIN TEST2 ON TEST1.x = TEST2.x
    LEFT JOIN TEST3 ON TEST1.y = TEST3.y
    WHERE
        TEST3.z > TEST1.z;

/*
Pseudo code

# for JOIN statements
function binary_search_join(t1, t2, col):
    sortt1, sortt2 based on col
    low_t2, high_t2 = 0, len(t2)
    for row1 in t1:
        while low_t2 <= high_t2:
            mid_t2 = low_t2 + (high_t2-low_t2)/2
            if t2[mid_t2] == row1:
                left join 
            elif t2[mid_t2] < row1:
                low_t2 = mid_t2 + 1
            else:
                high_t2 = mid_t2 - 1

# for > comparison
function binary_search_join(t1, t2, col):
    sortt1, sortt2 based on col x,y or z
    low_t2, high_t2 = 0, len(t2)
    for row1 in t1:
        while low_t2 <= high_t2:
            mid_t2 = low_t2 + (high_t2-low_t2)/2
            if t2[mid_t2] > row1:
                print(t2[mid_t2, row1) 
            else:
                low_t2 = mid_t2 + 1
            
BigO:
    # JOin statements
    - Traverse through t1: O(N)
    - Binary search on t2: O(logN)
    Total: O(NlogN)
    
    # comparison >
    - Traverse through t1: O(N)
    - Binary search on t2: O(logN)
    Total O(NlogN)
    
    Asymtotic: 2*O(NlogN) = O(NlogN)
    
    
*/

SELECT 'QUERY OPTIMIZATION AND INDICES'

/*
Some SQL commands can run much faster if the order of constraints is changed. For example, consider:

SELECT Name, Phone FROM Customer WHERE Gender = 'f' AND ZipCode = '90210';
*/
SELECT 'Give pseudo-code for the case that there are no indexes.'
/*
BigO: O(N^2)

gender_table = []
for row in Customer:
    if row['Gender'] == 'f':
        gender_table.append(row['Gender')
            for row_g gender_table:
                if row_g['ZipCode']=='90210':
                    print(row_g['Name'], row_g['Phone'])

*/

SELECT 'Pseudo code if there is an index on Gender';
/*
function gender_idx(table):
    ''' 
    sort: O(NlogN)
    binary search O(logN)
    Total O(NlogN)
    '''
    sort table based Gender idx (Female and Male group is clustered together into two chunks)
    low, high = 0, len(table)
    while low <= high:
        mid = low + (high-low)/2
        if table[mid]['Gender'] =='m' and table[mid-1]['Gender']=='f':
            first_male_idx = male 
             
        elif mid < first_male_idx:
            low = mid+1
        else:
            high = mid-1
    female_table = (table[:first_male_idx) # everything before first_male_idx is female bc sorting
    return female_table
    
female_table = gender_idx(table)
for row in female_table:
    if row['ZipCode'] == '90210':
        print(row['Name'], row['Phone'])

*/

SELECT 'Give pseudo-code for the case that there is an index on ZipCode. Assuming that there are roughly 10,000 different zip codes for your customers, how much more efficient is this than without any indices?'

/*
function bs_zipcode_idx(table, zipcode):
    sub_list = []
    zipcode = '90210'
    low, high = 0, len(table):
    while low <= high:
        mid = low + (high-low)/2
        if int(table[mid][ZipCode]) == int(zipcode):
            sub_list.append(table[mid][ZipCode])
        elif int(table[mid][ZipCode]) > int(zipcode):
            high = mid-1
        else:
            low = mid+1 
    return sub_list
# Based on this sublist, we can find female rows through basic traversal
for row in sub_list:
    if row['Gender'] =='f':
        print(row)
    
*/

SELECT 'Find out about composite indices. What would a good composite index look like in this case? Write pseudo-code for this case.''
/*
Composite index should have both gender and zipcode
*/

SELECT 'Find out what a covering index is. What would it look like in this case? Is a covering index more or less efficient than a composite index, and why?'
/*
A covering index is a non-clustered index which includes all columns referenced in the query and therefore, the optimizer does not have to perform an additional lookup to the table in order to retrieve the data requested. As the data requested is all indexed by the covering index, it is a faster operation

It looks like a composite index of all columns we have queried
https://sqlite.org/queryplanner.html
*/