DROP DATABASE IF EXISTS italian_workflow;

CREATE DATABASE italian_workflow;

USE italian_workflow;

CREATE TABLE Users (
    user_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    username VARCHAR(40) NOT NULL,
    password CHAR(60) NOT NULL,
    last_name VARCHAR(20),
    first_name VARCHAR(20),
    PRIMARY KEY (user_id),
    UNIQUE (username)
);

CREATE TABLE GiftCertificates (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    amount DECIMAL(10, 2) NOT NULL,
    sale_price,
    date_sold DATE NOT NULL,
    redeemed_date DATE,
    issuer_id INT UNSIGNED NOT NULL,
    memo VARCHAR(140),
    PRIMARY KEY (id),
    FOREIGN KEY (issuer_id) REFERENCES Users (user_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);