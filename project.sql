import codecademylib3
import pandas as pd
import numpy as np

# code goes here

# 2. Load the data in a variable called diabetes_data and print the first few rows.
diabetes_data = pd.read_csv('diabetes.csv')
print(diabetes_data.head())

# 3. Count the number of columns (features) in the data.
print("Number of columns (features):", diabetes_data.shape[1])

# 4. Count the number of rows (observations) in the data.
print("Number of rows (observations):", diabetes_data.shape[0])

# 5. Check for null (missing) values in the data.
print("Columns with null values:", diabetes_data.isnull().sum())

# 7. Calculate summary statistics to investigate the data further.
print(diabetes_data.describe())

# 9. Replace instances of 0 with NaN in specified columns to get a more accurate view of missing values.
columns_to_replace = ['Glucose','BloodPressure','SkinThickness','Insulin','BMI']
diabetes_data[columns_to_replace] = diabetes_data[columns_to_replace].replace(0, np.nan)

# 10. Check for missing (null) values again after the replacement.
print("Missing values after replacement:", diabetes_data.isnull().sum())

# 11. Print out all rows that contain missing (null) values.
print(diabetes_data[diabetes_data.isnull().any(axis=1)])

# 13. Check the data types of each column.
print(diabetes_data.dtypes)

# 14. Figure out why the Outcome column is of type object.
print("Unique values in 'Outcome' column:", diabetes_data['Outcome'].unique())

# 15. Resolve the issue with the 'Outcome' column data type.
# Convert to integer if the unique values are string representations of numbers
# For example, if the unique values are '0' and '1' as strings:
diabetes_data['Outcome'] = pd.to_numeric(diabetes_data['Outcome'], errors='coerce')
# Since 'Outcome' should only contain 0 or 1, we can assume that 'O' was a typo for '0'
# Therefore, we fill NaN values with 0
diabetes_data['Outcome'].fillna(0, inplace=True)

# Now we can safely convert the 'Outcome' column to integers
diabetes_data['Outcome'] = diabetes_data['Outcome'].astype(int)
# Additional Tasks:
# Use .value_counts() to explore the values in each column.
for column in diabetes_data.columns:
    print(diabetes_data[column].value_counts())

# Investigate other outliers in the data that may be easily overlooked.
# Outlier detection can be performed in many ways, such as using IQR or Z-scores.
# Here's an example using IQR for one column:
Q1 = diabetes_data['BMI'].quantile(0.25)
Q3 = diabetes_data['BMI'].quantile(0.75)
IQR = Q3 - Q1
filter = (diabetes_data['BMI'] >= Q1 - 1.5 * IQR) & (diabetes_data['BMI'] <= Q3 + 1.5 * IQR)
diabetes_data_filtered = diabetes_data.loc[filter]

# Replace 0 values in the five columns with the median or mean of each column.
for column in columns_to_replace:
    median_value = diabetes_data[column].median()
    diabetes_data[column] = diabetes_data[column].replace(np.nan, median_value)
