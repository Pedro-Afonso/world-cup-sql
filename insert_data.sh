#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams");

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    # GET WINNER AND OPPONENT ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name ILIKE '%$WINNER%'");
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name ILIKE '%$OPPONENT%'");
    # IF NOT FOUND
    if [[ -z $WINNER_ID ]]
    then
      # INSERT TEAM NAME
      echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')");
      # GET WINNER ID
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name ILIKE '%$WINNER%'");
    fi
    if [[ -z $OPPONENT_ID ]]
    then
      # INSERT TEAM NAME
      echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')");
      # GET NEW OPPONENT_ID
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name ILIKE '%$OPPONENT%'");
    fi

    # INSERT GAME
     echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)");
  fi
done

