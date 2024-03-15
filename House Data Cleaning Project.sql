/*

Cleaning Data in SQL Queries

*/

select * 
from PortfolioProject001.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Change Date Format

select SaleDate, CONVERT(Date,SaleDate)
from PortfolioProject001.dbo.NashvilleHousing

ALTER TABLE PortfolioProject001.dbo.NashvilleHousing
Add Sale_Date Date

Update PortfolioProject001.dbo.NashvilleHousing
SET Sale_Date = CONVERT(Date,SaleDate)

select Sale_Date
from PortfolioProject001.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

select PropertyAddress
from PortfolioProject001.dbo.NashvilleHousing
where PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject001.dbo.NashvilleHousing a
join PortfolioProject001.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set a.PropertyAddress =ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject001.dbo.NashvilleHousing a
join PortfolioProject001.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from PortfolioProject001.dbo.NashvilleHousing

select 
substring(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1) as address
, substring(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress))as state
from PortfolioProject001.dbo.NashvilleHousing

ALTER TABLE PortfolioProject001.dbo.NashvilleHousing
Add property_address nvarchar(255)

Update PortfolioProject001.dbo.NashvilleHousing
SET property_address = substring(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE PortfolioProject001.dbo.NashvilleHousing
Add property_state nvarchar(255)

Update PortfolioProject001.dbo.NashvilleHousing
SET property_state = substring(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress))


select OwnerAddress
from PortfolioProject001.dbo.NashvilleHousing

select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from PortfolioProject001.dbo.NashvilleHousing

ALTER TABLE PortfolioProject001.dbo.NashvilleHousing
Add owner_address nvarchar(255)

Update PortfolioProject001.dbo.NashvilleHousing
SET owner_address = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE PortfolioProject001.dbo.NashvilleHousing
Add owner_city nvarchar(255)

Update PortfolioProject001.dbo.NashvilleHousing
SET owner_city = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE PortfolioProject001.dbo.NashvilleHousing
Add owner_state nvarchar(255)

Update PortfolioProject001.dbo.NashvilleHousing
SET owner_state = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject001.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

select SoldAsVacant
,case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from PortfolioProject001.dbo.NashvilleHousing

update PortfolioProject001.dbo.NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

select * 
from PortfolioProject001.dbo.NashvilleHousing

Alter Table PortfolioProject001.dbo.NashvilleHousing
Drop Column OwnerAddress,propertyAddress,SaleDate

---------------------------------------------------------------------------------------------------------
