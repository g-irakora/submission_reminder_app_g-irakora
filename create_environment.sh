#!/bin/bash

#Ask the user their Name
read -p "What's Your name? : " Names
Parentdir="submission_reminder_${Names}"

mkdir -p "$Parentdir"

mkdir -p "$Parentdir/app" "$Parentdir/modules" "$Parentdir/assets" "$Parentdir/config" 

cat << 'The_end' > "$Parentdir/config/config.env"

# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
The_end

cat << 'The_end' > "$Parentdir/app/reminder.sh"

#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file

The_end

cat << 'The_end' > "$Parentdir/modules/functions.sh"

#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}

The_end

cat << 'The_end' > "$Parentdir/assets/submissions.txt"

student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Des,Shell Navigation , submitted
Mugenga, Shell Navigation , submitted
Obed, Shell Navigation , submitted
Murekezi, Shell Navigation ,Not submitted
Karake,Shell Navigation , Not submitted
Muhire,Shell Navigation , Submitted 

The_end

cat << 'The_end' > "$Parentdir/startup.sh"
#!/bin/bash
bash app/reminder.sh

The_end
chmod +x "$Parentdir/startup.sh"
