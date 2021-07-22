SELECT *
FROM PortfolioProject..NashvilleHousing
-------------------------------------------------------------------------------------------------------
-- STANDARDIZE SALEDATE COLUMN
SELECT SaleDate
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ALTER COLUMN SaleDate Date

-------------------------------------------------------------------------------------------------------

-- POPULATE PROPERTY ADDRESS DATA
SELECT *
FROM PortfolioProject..NashvilleHousing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID

/*
So there are 35 NULL values in PropertyAddress.
But after some visual examinaton we can say that the ParcelID and PropertyAddress are related.
We need to confirm it.
*/
SELECT a.PARCELID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL
/*
From the output of the above code we can confirm that the ParcelID and PropertyAddress are related,
as for given ParcelID, b.PropertyAddress is filled and a.PropertyAddress is NULL.
Now we just need to copy b.PropertyAddress column to a.PropertyAddress.
*/
SELECT a.PARCELID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
	ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

/*
Now if we re-run the below code, we will not get any values in the column confirming that
there are no NULL values in the PropertyAddress column
*/
SELECT *
FROM PortfolioProject..NashvilleHousing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID


-------------------------------------------------------------------------------------------------------
--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS(Address, City, State)
SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing

SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM PortfolioProject..NashvilleHousing

--we need to create two columns. one for address adnd other for city

ALTER TABLE NashvilleHousing
Add PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

--let us confirm
SELECT *
FROM PortfolioProject..NashvilleHousing
-- last two columns are PropertySplitAddress, PropertySplitCity.


-------------------------------------------------------------------------------------------------------
--BREAKING OUT OWNER ADDRESS INTO INDIVIDUAL COLUMNS(Address, City, State)

SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing

SELECT
	PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
	PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
	PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

SELECT *
FROM PortfolioProject..NashvilleHousing

-------------------------------------------------------------------------------------------------------
--CHANGE Y AND N TO YES AND NO IN  'SOLD AS VACANT' FIELD

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY COUNT(SoldAsVacant)

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY COUNT(SoldAsVacant)

-------------------------------------------------------------------------------------------------------
--REMOVE DUPLICATES
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProject..NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num>1
ORDER BY PropertyAddress

--there are 104 duplicate rows. lets delete them all
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProject..NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num>1

-- let us confirm
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProject..NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num>1
ORDER BY PropertyAddress
--as we get 0 rows, we can say that all duplicate rows are deleted


-------------------------------------------------------------------------------------------------------
--DELETE UNUSED COLUMNS
SELECT *
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate