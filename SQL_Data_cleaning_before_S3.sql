CREATE DATABASE bank_data_anaylsis_project;

USE bank_data_anaylsis_project;

# First we work on account table

SELECT * FROM account ORDER BY date DESC;
SELECT COUNT(*) FROM account;

# Updating the dataype of date column from datetime to date.
ALTER TABLE account
MODIFY COLUMN date DATE;

SELECT date, DATE_ADD(date, INTERVAL 24 YEAR) FROM account ORDER BY date;

# Adding 23 Years to date column so that the data will be more recent.alter
UPDATE account
SET date = DATE_ADD(date, INTERVAL 24 YEAR);

/* Updating frequency column to replace values as shown below
POPLATEK MESICNE -> Monthly issuance
POPLATEK TYDNE -> Weekly issuance
POPLATEK PO OBRATU -> Issuance after a transaction
*/

UPDATE account
	SET frequency = 
	CASE 
		WHEN frequency = 'POPLATEK MESICNE' THEN 'Monthly issuance'
		WHEN frequency = 'POPLATEK TYDNE' THEN 'Weekly issuance'
		WHEN frequency = 'POPLATEK PO OBRATU' THEN 'Issuance after a transaction'
	END;
    
/* Creating a custom column with 'Card_assigned' with below requirments
Silver -> Monthly issuance
Diamond -> Weekly issuance
Gold -> Issuance after a transaction
*/

ALTER TABLE account
ADD COLUMN card_assigned TEXT;

UPDATE account
SET card_assigned = 'Silver'
WHERE frequency = 'Monthly issuance';

UPDATE account
SET card_assigned = 'Diamond'
WHERE frequency = 'Weekly issuance';

UPDATE account
SET card_assigned = 'Gold'
WHERE frequency = 'Issuance after a transaction';

# Adding foreign key

ALTER TABLE account
ADD CONSTRAINT forkey FOREIGN KEY (district_id) REFERENCES district (District_code);

DESC account;
----------------------------------------------------------------------

# Card table
SELECT * FROM card;

# Creating a new column issued_date and putting dates from issued column adding 24 years
ALTER TABLE card
ADD COLUMN issued_date DATE;

UPDATE card
SET issued_date = CONVERT(LEFT(issued,6), DATE);

UPDATE card
SET issued_date = DATE_ADD(issued_date, INTERVAL 24 YEAR);

ALTER TABLE card
DROP COLUMN issued;

/* Replacing values in type column as mentioned below -
“junior” as Silver, “Classic” as Gold, And “Gold” as Diamond */

UPDATE card
SET type = 
	CASE
		WHEN type = 'junior' THEN 'Silver'
		WHEN type = 'gold' THEN 'Diamond' 
	END;

UPDATE card
SET type = 'Gold'
WHERE type IS NULL;

# Adding foreign key

ALTER TABLE card
ADD CONSTRAINT forkey7 FOREIGN KEY (disp_id) REFERENCES disposition (disp_id);

DESC card;

----------------------------------------------------------------

# Client table

SELECT * FROM client;

ALTER TABLE client
MODIFY COLUMN dob DATE;

/* Creating a new column with below condition
If birth_number is even = Female Else Male
*/

ALTER TABLE client
ADD COLUMN gender Text;

UPDATE client
SET gender = 
	CASE
		WHEN birth_number%2 = 0 THEN 'Female'
		ELSE 'Male'
	END;

ALTER TABLE client
DROP COLUMN birth_number;

# Creating a new column age

ALTER TABLE client
ADD COLUMN age INT;

UPDATE client
SET age = TIMESTAMPDIFF(YEAR, dob, CURDATE());

# Adding foreign key

ALTER TABLE client
ADD CONSTRAINT forkey4 FOREIGN KEY (district_id) REFERENCES district (District_code);

DESC client;

-------------------------------------------------------------------------
# disposition table 

SELECT * FROM disposition;

# Adding foreign key

ALTER TABLE disposition
ADD CONSTRAINT forkey5 FOREIGN KEY (account_id) REFERENCES account (account_id);

ALTER TABLE disposition
ADD CONSTRAINT forkey6 FOREIGN KEY (client_id) REFERENCES client (client_id);

DESC disposition;

------------------------------------------------------------------------
# district table 

SELECT * FROM district;

-------------------------------------------------------------------------
# Now, we do some cleaning & transformation in loan table

SELECT * FROM loan ORDER BY date DESC;

SELECT CONVERT(date, DATE) FROM loan;

UPDATE loan
SET date = CONVERT(date, DATE);

ALTER TABLE loan
MODIFY date DATE;

UPDATE loan
SET date = DATE_ADD(date, INTERVAL 24 YEAR);

UPDATE loan
SET status = CASE
				WHEN status = 'A' THEN 'Contract finished'
				WHEN status = 'B' THEN 'Loan not paid'
				WHEN status = 'C' THEN 'Running contract'
				WHEN status = 'D' THEN 'Client in debt'
			END;

# Adding foreign key

ALTER TABLE loan
ADD CONSTRAINT forkey2 FOREIGN KEY (account_id) REFERENCES account (account_id);

DESC loan;
----------------------------------------------------------------------
# Orders table

SELECT * FROM orders;

ALTER TABLE orders
RENAME COLUMN Bank_to TO bank_to;

# Adding foreign key

ALTER TABLE orders
ADD CONSTRAINT forkey2 FOREIGN KEY (account_id) REFERENCES account (account_id);

DESC orders;
----------------------------------------------------------------------
# Transation table

ALTER TABLE transaction_2016
RENAME TO transactions;

ALTER TABLE transactions
RENAME COLUMN Purpose TO purpose;

ALTER TABLE transactions
MODIFY COLUMN date DATE;

SELECT * FROM transactions;

UPDATE transactions
SET date = DATE_ADD(date, INTERVAL 6 YEAR);

UPDATE transactions
SET bank = "Sky Bank"
WHERE bank = "";

SELECT * FROM transactions
WHERE bank = "";

# Adding foreign key

ALTER TABLE transactions
ADD CONSTRAINT forkey3 FOREIGN KEY (account_id) REFERENCES account (account_id);

DESC transactions;
------------------------------------------

ALTER TABLE trnx_17
RENAME TO transactions_2021;

ALTER TABLE transactions_2021
RENAME COLUMN Type TO type;

ALTER TABLE transactions_2021
MODIFY COLUMN date DATE;

SELECT * FROM transactions_2021 ORDER BY date;

UPDATE transactions_2021
SET date = DATE_ADD(date, INTERVAL -1 YEAR);

UPDATE transactions_2021
SET bank = "DBS Bank"
WHERE bank = "DBS BanK";

------------------------------------------------------------







