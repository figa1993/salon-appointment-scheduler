#! /bin/bash

prompt_services(){
  echo -e "Select a service:\n"
  SERVICES=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT service_id,name FROM services")

  echo -e "$SERVICES" | while read ID UNUSED SERVICE;
  do
    echo -e "$ID) $SERVICE"
  done
}


while true;
do
  prompt_services

  read SERVICE_ID_SELECTED

  SERVICE_DATA=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT * FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  if [ -z "$SERVICE_DATA" ]; then
    echo -e "Invalid service selected. Please try again.\n"
  else 
    break
  fi
done

read SERVICE_ID UNUSED SERVICE_NAME <<< "$SERVICE_DATA"

echo -e "\n Let's get that scheduled for you. What's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_DATA=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT * FROM customers WHERE phone = '$CUSTOMER_PHONE'")

if [ -z "$CUSTOMER_DATA" ]; then
  echo -e "\nGlad to have you as a new customer. What is your name?"
  read CUSTOMER_NAME
  psql --username=freecodecamp --dbname=salon -t -c "INSERT INTO customers(name,phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE')"
fi

CUSTOMER_DATA=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT customer_id,name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

echo -e "CUSTOMER_DATA:$CUSTOMER_DATA"
read -r CUSTOMER_ID UNUSED CUSTOMER_NAME <<< "$CUSTOMER_DATA"

echo -e "\nWhat time would you like that appointment for?"
read SERVICE_TIME

psql --username=freecodecamp --dbname=salon -t -c "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')"

echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
