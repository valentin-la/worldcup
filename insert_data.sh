#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_G OPPONENT_G
do

  TEAMS=$($PSQL "SELECT name FROM teams WHERE name ='$WINNER'")
  if [[ $WINNER != "winner" ]]
  then
    if [[ -z $TEAMS ]]
    then
    INSERT_TEAM=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
    fi
  fi

  TEAMS2=$($PSQL "SELECT name FROM teams WHERE name ='$OPPONENT'")
  if [[ $OPPONENT != "opponent" ]]
  then
    if [[ -z $TEAMS2 ]]
    then
    INSERT_TEAM2=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
    fi
  fi

  TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")
  TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")

  if [[ -n $TEAM_ID_W || -n $TEAM_ID_O ]]
  then
    if [[ $YEAR != "year" ]]
    then
      INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_W, $TEAM_ID_O, $WINNER_G, $OPPONENT_G)")
    fi
  fi




done