use firstdb;
select * from firsttable;

select * from firsttable where PropertyAddress is null;


--standerize date format

alter table firsttable
add SaleDateConverted Date;

update firsttable
set SaleDateConverted = convert(date, SaleDate);

Select SaleDate,SaleDateConverted
From firsttable;





--populate propertyaddress date
select * from firsttable
--where propertyaddress is null;
order by parcelid;

select a.[UniqueID ], a.PropertyAddress, b.[UniqueID ], b.PropertyAddress 
from firsttable a inner join firsttable b 
on a.ParcelID = b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null;

update a
set a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from firsttable a
INNER JOIN firsttable b 
on a.ParcelID = b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null;

select *
from firsttable
where PropertyAddress is null;



-- Break Address into Individual Columns (Address, City, State)
select propertyaddress from firsttable;

select 

substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as address,
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) as address
from firsttable;

ALTER TABLE firsttable
Add paddress Nvarchar(255);

Update firsttable
SET paddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 );


ALTER TABLE firsttable
Add pcity Nvarchar(255);

Update firsttable
SET pcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress));







select * from firsttable;
select owneraddress from firsttable;


select 
parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from firsttable;


ALTER TABLE firsttable
Add OAddress Nvarchar(255);

Update firsttable
SET OAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE firsttable
Add OCity Nvarchar(255);

Update firsttable
SET OCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE firsttable
Add OState Nvarchar(255);

Update firsttable
SET OState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);

--Change Y and N to Yes and No in "Sold as Vacant" field

select * from firsttable
where SoldAsVacant = 'n';


select distinct(SoldAsVacant), count(soldasvacant) from firsttable
group by SoldAsVacant
order by 1;



Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From firsttable ;

update firsttable
set SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
	   ;








--remove dups



WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From firsttable
--order by ParcelID
)
select * from RowNumCTE
where row_num>1;




--delete unused column
--use alter table_name 
--drop column_name