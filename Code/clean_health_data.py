import pandas as pd

# 1. Load
df = pd.read_excel('Ethiopia_Health_Dataset.xlsx')

# 2. Standardize column names
df.columns = (
    df.columns
      .str.strip()
      .str.lower()
      .str.replace(' ', '_')
)

# 3. Trim & uppercase key text fields
df['facilityid']     = df['facilityid'].str.strip().str.upper()
df['region']         = df['region'].str.strip()
df['woreda']         = df['woreda'].str.strip()
df['facilitytype']   = df['facilitytype'].str.strip()

# 4. Drop exact duplicates
df = df.drop_duplicates()

# 5. Fill nulls and enforce non-negative ints
num_cols = [
    'hiv_tested','hiv_positive','art_enrollment','viral_suppression',
    'tb_screened','tb_positive','tb_ipt',
    'anc_visits','deliveries','malaria_cases','malaria_deaths',
    'fully_immunized'
]
for col in num_cols:
    df[col] = (
        pd.to_numeric(df[col], errors='coerce')
          .fillna(0)
          .astype(int)
          .clip(lower=0)
    )

# 6. Create a single reporting date
df['reporting_date'] = pd.to_datetime(
    df.assign(day=1)[['year', 'month', 'day']]
)

# 7. Filter realistic ranges
df = df[(df['year'] >= 2000) & (df['year'] <= pd.Timestamp.now().year)]
df = df[(df['month'] >= 1) & (df['month'] <= 12)]

# 8. Save cleaned file
df.to_csv('cleaned_health_data.csv', index=False)