DROP DATABASE IF EXISTS italian_workflow;

CREATE DATABASE italian_workflow;

USE italian_workflow;

CREATE TABLE Users (
    user_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    username VARCHAR(40) NOT NULL,
    password CHAR(60) NOT NULL,
    PRIMARY KEY (user_id),
    UNIQUE (username)
);

CREATE TABLE GiftCertificates (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    amount DECIMAL(10, 2) NOT NULL,
    sold_date DATE NOT NULL,
    seller_id INT UNSIGNED NOT NULL,
    redeemed_date DATE,
    PRIMARY KEY (id),
    FOREIGN KEY (seller_id) REFERENCES Users (user_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);