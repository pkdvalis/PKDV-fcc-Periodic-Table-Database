PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

INFO() {
  WEIGHT=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC;")
  MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC;")
  BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC;")
  echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a nonmetal, with a mass of $WEIGHT amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
}


if [[ ! $1 ]]
then
  echo -e "Please provide an element as an argument."
elif [[ $1 =~ ^[0-9]+$ ]]
then
  ATOMIC=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1;")
  if [[ $ATOMIC ]]
  then
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $1;")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1;")
    INFO $ATOMIC $SYMBOL $NAME
  else
    echo "I could not find that element in the database."
  fi
elif [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
then 
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1';")
  if [[ $SYMBOL ]]
  then
    ATOMIC=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1';")
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$1';")
    INFO $ATOMIC $SYMBOL $NAME
  else
    echo "I could not find that element in the database."
  fi
elif [[ $1 =~ ^[a-zA-Z]{3,}$ ]]
then 
  NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1';")
  if [[ $NAME ]]
  then
    ATOMIC=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1';")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$1';")
    INFO $ATOMIC $SYMBOL $NAME
  else
    echo "I could not find that element in the database."
  fi

else
  echo "I could not find that element in the database."
fi

