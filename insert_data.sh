#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#https://stackoverflow.com/questions/13989243/sequence-does-not-reset-after-truncating-the-table
#what is the point of the echo???
echo $($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY")

#https://tldp.org/LDP/abs/html/special-chars.html
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  #echo $WINNER " vs. " $OPPONENT
  #Checking for winner & opponent duplicates in our database
  if [[ $WINNER != "winner" ]]
  then
    W_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #O_TEAM_ID=$($PSQL :

    if [[ -z $W_TEAM_ID ]]
    then
      INSERT_WINNER_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      if [[ $INSERT_WINNER_TEAM == "INSERT 0 1" ]]
      then
        echo Winning team $WINNER is now it the teams table
      fi
    fi

    #if [[ $OPPONENT != 'opponent' ]]
    #then
      #I think you need both rows here because $OPPONENT is used to find the correct row, IF present, and returns either
      #the founds' team_id or 0 if not found!!!! If 0 then add it!
      O_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

      if [[ -z $O_TEAM_ID ]]
      then
        INSERT_OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

        if [[ $INSERT_OPPONENT_TEAM == "INSERT 0 1" ]]
        then
          echo Opponent team $OPPONENT is now in the teams table
        fi
      fi
    #fi
  fi  
done

#Did this because when I added it above it added 1 team at a time and this!!!
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS 
do
  if [[ $YEAR != "year" ]]
  then
    #You want to check if both teams are present TO GET THE GAME_ID
    #GAME_ID is an important variable that we added in order to check opponent/winner teams and add them to games!!!!
    #GAME_ID=$($PSQL "SELECT name FROM teams WHERE name='$WINNER' AND name='$OPPONENT'")
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #echo -e "In $YEAR during the $ROUND round:\n  $WINNER_ID scored $WGOALS goals\n  $OPPONENT_ID scored $OGOALS goals"

    #if [[ -z $GAME_ID ]]
    #then
      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', $WINNER_ID, $OPPONENT_ID, '$WGOALS', '$OGOALS')")
    #fi
  fi
done
