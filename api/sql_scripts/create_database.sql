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
    gift_certificate_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    amount DECIMAL(10, 2) NOT NULL,
    sale_price DECIMAL(10, 2) NOT NULL,
    date_sold DATE NOT NULL,
    date_redeemed DATE,
    issuer_id INT UNSIGNED NOT NULL,
    memo VARCHAR(140),
    PRIMARY KEY (gift_certificate_id),
    FOREIGN KEY (issuer_id) REFERENCES Users (user_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE OverShorts (
    over_short_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    amount DECIMAL(10, 2) NOT NULL,
    billable BOOLEAN NOT NULL,
    amountPaid DECIMAL(10, 2),
    date_recorded DATE NOT NULL,
    last_contacted DATE,
    issuer_id INT UNSIGNED NOT NULL,
    memo VARCHAR(512) NOT NULL,
    PRIMARY KEY(over_short_id),
    FOREIGN KEY (issuer_id) REFERENCES Users (user_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);