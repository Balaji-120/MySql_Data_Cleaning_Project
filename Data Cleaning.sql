---------------------------------- DATA CLEANING ------------------------

use world_layoffs;
select * from layoffs;

CREATE TABLE layoffs_staging
like layoffs;

select * from layoffs_staging;

INSERT layoffs_staging
select * 
from layoffs; 

-- 1. Remove Duplicates
select * from layoffs_staging;

select *,
row_number() over(partition by company,industry,total_laid_off,'date' ) AS row_num
from layoffs_staging;

with duplicate_cte AS
(
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,
funds_raised_millions) AS row_num
from layoffs_staging
)
select *
From duplicate_cte
where row_num>1;

select *
from layoffs_staging
where company ="ola";

with duplicate_cte AS
(
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,
funds_raised_millions) AS row_num
from layoffs_staging
)
select *
From duplicate_cte
where row_num>1;

select * from layoffs_staging
where company = 'casper';

with duplicate_cte AS
(
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,
funds_raised_millions) AS row_num
from layoffs_staging
)
DELETE
From duplicate_cte
where row_num>1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_staging2;

insert into layoffs_staging2 
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,
funds_raised_millions) AS row_num
from layoffs_staging;

select * from layoffs_staging2
where row_num >1;

delete from layoffs_staging2
where row_num >1;

select * from layoffs_staging2
where row_num>1;

select * from layoffs_staging2;

---------------------------------- 2. Standardize the data -------------------------------

select company,trim(company) from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select distinct industry from layoffs_staging2
order by 1;

select * from layoffs_staging2
where industry like 'crypto%';

update layoffs_staging2
set industry='Crypto'
where  industry like 'crypto%';

select distinct country
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where country like "United States%";

select distinct country,trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country =TRIM(Trailing '.' from country)
where country  like 'United states%';

select * from layoffs_staging2;

select 	`date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = STR_TO_DATE(`date`,'%m/%d/%Y') ;

select `date` from layoffs_staging2;

alter table layoffs_staging2 
modify column `date` date;

------------- 3. Remove Null and Blank Values ---------------------
select * from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select * from layoffs_staging2
where industry is null
or industry = '';

select * from layoffs_staging2
where company ='AIrbnb';

select * from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
    AND t1.location = t2.location
where (t1.industry is null or t1.industry ='')
AND t2.industry is not null;

select t1.industry,t2.industry from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
    AND t1.location = t2.location
where (t1.industry is null or t1.industry ='')
AND t2.industry is not null;

update layoffs_staging2
set industry =null
where industry = '';


update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company =t2.company
set t1.industry =t2.industry
where (t1.industry is null )
and t2.industry is not null ;

select * from layoffs_staging2
where company like 'Bally%';

-- 4. Remove any columnns OR ROWS 

select * from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;


Delete from layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_staging2;  

ALTER TABLE layoffs_staging2
DROP COLUMN ROW_NUM;

delete from layoffs_staging2
where industry is null
and total_laid_off is null;
	
