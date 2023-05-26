#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

echo -e "\n~~Periodic Table of Elements~~\n"

# Check if there is an argument
if [[ -n $1 ]] 
then
  # if there is an argument, check if it's a number or not using regex pattern operator "=~"
  if [[ "$1" =~ ^[0-9]+$ ]]
  # if it is a number
  then
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM types FULL JOIN properties USING(type_id) FULL JOIN elements USING(atomic_number) WHERE atomic_number = $1");
  
  # if it is a string
  else
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM types FULL JOIN properties USING(type_id) FULL JOIN elements USING(atomic_number) WHERE symbol = '$1' or name = '$1' ");
  fi

    # check if the ELEMENT variable's values exists
    if [[ -n "$ELEMENT" ]] 
    # if the ELEMENT values exist, extract the values from the ELEMENTS variable and assign them to new variables
    then
      echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
      do
        # after extracting the values, use the assigned variables for the echo statement
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
      
    else
      # if the ELEMENT values doesn't exist, output this message
      echo "I could not find that element in the database."
      exit
    fi

else
  # if there is no argument provided, output this message
  echo "Please provide an element as an argument."
fi
