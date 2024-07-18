CREATE DATABASE salon;
\c salon
CREATE TABLE customers(customer_id SERIAL PRIMARY KEY, phone VARCHAR(20) UNIQUE, name VARCHAR(20));
CREATE TABLE services(service_id SERIAL PRIMARY KEY, name VARCHAR(20));
CREATE TABLE appointments(appointment_id SERIAL PRIMARY KEY, customer_id INT REFERENCES customers(customer_id), service_id INT REFERENCES services(service_id), time VARCHAR(20));

INSERT INTO services(name) VALUES ('haircut'), ('manicure'), ('pedicure');