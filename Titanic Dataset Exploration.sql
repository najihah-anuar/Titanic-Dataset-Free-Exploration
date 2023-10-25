/*
Titanic Dataset Free Exploration
Indentify factors that contribute to the survivability of the passengers.
*/



--Show percentage of missing data in every column.

SELECT
	100 * SUM(CASE WHEN PassengerId IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS id_missing,
	100 * SUM(CASE WHEN Survived IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS survived_missing,
	100 * SUM(CASE WHEN Pclass IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS pclass_missing,
	100 * SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS name_missing,
	100 * SUM(CASE WHEN Sex IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS sex_missing,
	100 * SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS age_missing,
	100 * SUM(CASE WHEN SibSp IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS sibsp_missing,
	100 * SUM(CASE WHEN Parch IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS parch_missing,
	100 * SUM(CASE WHEN Ticket IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS ticket_missing,
	100 * SUM(CASE WHEN Fare IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS fare_missing,
	100 * SUM(CASE WHEN Cabin IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS cabin_missing,
	100 * SUM(CASE WHEN Embarked IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS embarked_missing
FROM passengers



--Total Survive vs Total Death
--Show the number of passenger survive vs number of passenger dead.

SELECT Survived AS "Survival Status", count(Survived) AS "Number of Pasenggers"
FROM passengers
WHERE Survived = 1
GROUP BY Survived
UNION
SELECT Survived AS "Survival Status", count(Survived) AS "Number of Pasenggers"
FROM passengers
WHERE Survived = 0
GROUP BY Survived 



--Class (Socio-economic) vs Survival Rate
-- Show total number of survivors, deaths, and survival rate percentage for every class of passenger.

SELECT s.Pclass AS Class , Survivors, Casualities, round(CAST(Survivors AS FLOAT) / (Survivors + Casualities) * 100,2) AS "Survival Rate"
FROM (
	SELECT Pclass, count(Pclass) AS Survivors
	FROM passengers
	WHERE Survived = 1
	GROUP BY Pclass
)s
JOIN(
	SELECT Pclass, count(Pclass) AS Casualities
	FROM passengers
	WHERE Survived = 0
	GROUP BY Pclass
)c
ON s.Pclass = c.Pclass



--Sex (Gender) vs Survival Rate
-- Show total number of survivors, deaths, and survival rate percentage for male and female.

SELECT s.Sex AS Gender , Survivors, Casualities, round(CAST(Survivors AS FLOAT) / (Survivors + Casualities) * 100,2) AS "Survival Rate"
FROM (
	SELECT Sex, count(Sex) AS Survivors
	FROM passengers
	WHERE Survived = 1
	GROUP BY Sex
)s
JOIN(
	SELECT Sex, count(Sex) AS Casualities
	FROM passengers
	WHERE Survived = 0
	GROUP BY Sex
)c
ON s.Sex = c.Sex



--Age Group vs Survival Rate
-- Show total number of survivors, deaths, and survival rate percentage for every age group of passenger.

SELECT s.age_range AS "Passenger Age Range", Survivors, ifnull(Dead,0) AS Deceased, round(CAST(Survivors AS FLOAT) / (Survivors + ifnull(Dead,0)) * 100,2) AS "Survival Rate"
FROM (
	SELECT CASE WHEN CAST(Age AS FLOAT) < 1 THEN 'Infant'
				WHEN CAST(Age AS FLOAT) BETWEEN 1 AND 12 THEN 'Children'
				WHEN CAST(Age AS FLOAT) BETWEEN 13 AND 17 THEN 'Teenager'
				WHEN CAST(Age AS FLOAT) BETWEEN 18 AND 64 THEN 'Adult'
				WHEN CAST(Age AS FLOAT) > 64 THEN 'Elderly'
			END AS age_range,
			count(*) AS Survivors
	FROM passengers
	WHERE Survived = 1 AND Age IS NOT NULL
	GROUP BY age_range
	ORDER BY CASE WHEN age_range = "Infant" THEN 1
				  WHEN age_range = "Children" THEN 2
				  WHEN age_range = "Teenager" THEN 3
				  WHEN age_range = "Adult" THEN 4
				  WHEN age_range = "Elderly" THEN 5
			END
)s
LEFT OUTER JOIN(
	SELECT CASE WHEN CAST(Age AS FLOAT) < 1 THEN 'Infant'
				WHEN CAST(Age AS FLOAT) BETWEEN 1 AND 12 THEN 'Children'
				WHEN CAST(Age AS FLOAT) BETWEEN 13 AND 17 THEN 'Teenager'
				WHEN CAST(Age AS FLOAT) BETWEEN 18 AND 64 THEN 'Adult'
				WHEN CAST(Age AS FLOAT) > 64 THEN 'Elderly'
			END AS age_range,
			count(*) AS Dead
	FROM passengers
	WHERE Survived = 0 AND Age IS NOT NULL
	GROUP BY age_range
)c
ON s.age_range = c.age_range

