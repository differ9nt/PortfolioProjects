/* 

Cleaning Data in SQL Queries

*/

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
----------------------------------------------------------------------------------------------------------------------------


--Standardize Date Format

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)
----------------------------------------------------------------------------------------------------------------------------


--Breaking out Address into Individual Columns (Address, City, State) -- PropertyAddress

SELECT
PARSENAME(REPLACE(PropertyAddress,',','.'), 2),
PARSENAME(REPLACE(PropertyAddress,',','.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE  NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = PARSENAME(REPLACE(PropertyAddress,',','.'), 2)

Update NashvilleHousing
SET PropertySplitCity = PARSENAME(REPLACE(PropertyAddress,',','.'), 1)
----------------------------------------------------------------------------------------------------------------------------


--Breaking out Address into Individual Columns (Address, City, State) -- OwnerAddress

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
----------------------------------------------------------------------------------------------------------------------------


--Change Y and N to Yes or No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) as count_sold_as_vacant
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
----------------------------------------------------------------------------------------------------------------------------


--Remove Dublicates

WITH RowNumCTE as (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num
FROM PortfolioProject.dbo.NashvilleHousing
)

DELETE
FROM RowNumCTE
WHERE row_num > 1
----------------------------------------------------------------------------------------------------------------------------

--Delete Created Columns 
ALTER TABLE PortfolioProject.dbo.NashvilleHousing 
DROP COLUMN  OwnerSplitAddress, OwnerSplitCity, OwnerSplitState;
GO

----------------------------------------------------------------------------------------------------------------------------


