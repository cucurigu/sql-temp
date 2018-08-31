-- TEST CASES (please install procedure before running the tests)
-- Below a couple of cases showing PASS/FAIL test scenario
-- I prepared two for each major type Academic, Business and Ordinary

-- Academic : Pass
EXEC dbo.createBorrower 'BR123456', 'Greg', 'Len' ,'123 Street Road', '0781 982 981', 'greg@email.com', 'Academic', '5', 'Fiction'

-- Academic : Failed
EXEC dbo.createBorrower 'BR123456', 'Greg', 'Len' ,'123 Street Road', '0781 982 981', 'greg@email.com', 'Academic', '100', 'Fiction'

-- Expected: 
-- Msg 90001, Level 16, State 1, Procedure createBorrower, Line 145
-- Invalid procedure input.


-- Ordinary : Pass

EXEC dbo.createBorrower 'BR123457', 'Greg', 'Len' ,'123 Street Road', '0781 982 981', 'greg@email.com', '', '', 'Computer Science'


-- Ordinary : Passed (Invalid Genre)
EXEC dbo.createBorrower 'BR123458', 'Greg', 'Len' ,'123 Street Road', '0781 982 981', 'greg@email.com', '', '', 'Computer Science,Poetry,'

-- Expected:
-- Following Genre(s) passed do NOT exist: , Poetry, 
-- Msg 50000, Level 1, State 1

