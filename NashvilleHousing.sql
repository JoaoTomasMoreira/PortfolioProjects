/* 

CLEANING DATA PROJECT

*/

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- STANDARDIZE DATE FORMAT



SELECT SaleDate, CONVERT(DATE, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate);



--------------------------------------------------------------------------------------------------------------------------
-- POPULATE PROPERTY ADDRESS DATA

/* 
Each unique PropertyAddress is associated with a corresponding ParcelID. In cases where a ParcelID appears multiple times, with PropertyAddress values
present in some rows and Null in others, we can utilize the available PropertyAddress as a reference to fill in those Null values with the exact same address.
*/



SELECT  TOP 100 *
FROM dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.UniqueID, a.ParcelID, a.PropertyAddress, b.UniqueID, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL



--------------------------------------------------------------------------------------------------------------------------

--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (Address, City, State)
--PROPERTY ADDRESS

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
FROM dbo.NashvilleHousing


ALTER TABLE dbo.NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255)

UPDATE dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE dbo.NashvilleHousing
ADD PropertySplitCity NVARCHAR(255)

UPDATE dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


--OWNER ADDRESS


SELECT OwnerAddress 
FROM dbo.NashvilleHousing
WHERE OwnerAddress IS NOT NULL

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
FROM dbo.NashvilleHousing


ALTER TABLE dbo.NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255),
	OwnerSplitCity NVARCHAR(255),
	OwnerSplitState NVARCHAR(255);

UPDATE dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
	OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
	OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1);

SELECT *
FROM dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM dbo.NashvilleHousing
GROUP BY SoldAsVacant


UPDATE dbo.NashvilleHousing
SET SoldAsVacant = 'Yes'
WHERE SoldAsVacant = 'Y'

UPDATE dbo.NashvilleHousing
SET SoldAsVacant = 'No'
WHERE SoldAsVacant = 'N'


--------------------------------------------------------------------------------------------------------------------------

--REMOVE DUPLICATES


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
					ORDER BY UniqueID) as Row_num
FROM dbo.NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE Row_num > 1
--ORDER BY PropertyAddress








--------------------------------------------------------------------------------------------------------------------------

--DELETE UNUSED COLUMNS

SELECT *
FROM dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress
