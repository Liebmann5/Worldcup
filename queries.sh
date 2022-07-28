#SELECT acts as a return "AND" a search command!!!!

#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

#https://stackoverflow.com/questions/15719557/how-to-compute-the-sum-of-multiple-columns-in-postgresql
echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

#I think since the winning team will always have the most goals all they're expecting us to check is winner_goals
echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

#https://dba.stackexchange.com/questions/212624/select-all-rows-where-a-column-value-occurs-more-than-once
#https://stackoverflow.com/questions/9736944/see-whether-an-item-appears-more-than-once-in-a-database-column
echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM games FULL JOIN teams ON games.winner_id = teams.team_id WHERE round='Final' AND year=2018")"

#https://forum.freecodecamp.org/t/worldcup-queries/507435
#!!!Without DISTINCT() the result of name only prints the "organized order" of teams by winner_id 
echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT DISTINCT(name) FROM games FULL JOIN teams ON games.winner_id = teams.team_id OR games.opponent_id = teams.team_id WHERE round='Eighth-Final' AND year=2014")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT(name) FROM games AS g INNER JOIN teams AS t ON g.winner_id = t.team_id ORDER BY name ASC")"

#Remember that ASC is unnecessary
echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT year, name FROM games INNER JOIN teams ON games.winner_id = teams.team_id WHERE round='Final' ORDER BY year ASC")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT DISTINCT(name) FROM games FULL JOIN teams ON games.winner_id = teams.team_id OR games.opponent_id = teams.team_id WHERE name LIKE 'Co%' ORDER BY name")"
