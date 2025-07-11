START_DATE="2025-02-01"
DAYS=60
FILE="README.md"

# Calculate the number of days between START_DATE and today
END_DATE=$(date "+%Y-%m-%d")
DAYS_BETWEEN=$(($(date -d "$END_DATE" +%s) - $(date -d "$START_DATE" +%s)))
DAYS_BETWEEN=$((DAYS_BETWEEN / 86400 + 1)) # Convert seconds to days

# Generate an array of random day offsets
declare -a RANDOM_DAYS
for ((i=0; i<DAYS; i++)); do
  RANDOM_DAYS[$i]=$((RANDOM % DAYS_BETWEEN))
done

# Sort the random days to ensure chronological order
IFS=$'\n' RANDOM_DAYS=($(sort -n <<<"${RANDOM_DAYS[*]}"))

# Perform commits on the randomly selected days
for ((i=0; i<DAYS; i++)); do
  COMMIT_DATE=$(date -d "$START_DATE +${RANDOM_DAYS[$i]} days" "+%Y-%m-%dT12:00:00")
  COMMIT_DAY=$(date -d "$START_DATE +${RANDOM_DAYS[$i]} days" "+%Y-%m-%d")
  echo "Commit on $COMMIT_DAY" >> $FILE
  git add $FILE
  GIT_AUTHOR_DATE="$COMMIT_DATE" GIT_COMMITTER_DATE="$COMMIT_DATE" git commit -m "Auto commit on $COMMIT_DAY"
done

echo "✅ Done generating $DAYS random fake commits."
