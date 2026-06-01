-- Credit Card Fraud Detection Schema

USE master;
GO

CREATE DATABASE FraudDetectionDB;
GO

USE FraudDetectionDB;
GO

CREATE TABLE transactions (
    transaction_id  INT IDENTITY(1,1) PRIMARY KEY,
    time_seconds    FLOAT(53),
    V1  FLOAT(53), V2  FLOAT(53), V3  FLOAT(53), V4  FLOAT(53),
    V5  FLOAT(53), V6  FLOAT(53), V7  FLOAT(53), V8  FLOAT(53),
    V9  FLOAT(53), V10 FLOAT(53), V11 FLOAT(53), V12 FLOAT(53),
    V13 FLOAT(53), V14 FLOAT(53), V15 FLOAT(53), V16 FLOAT(53),
    V17 FLOAT(53), V18 FLOAT(53), V19 FLOAT(53), V20 FLOAT(53),
    V21 FLOAT(53), V22 FLOAT(53), V23 FLOAT(53), V24 FLOAT(53),
    V25 FLOAT(53), V26 FLOAT(53), V27 FLOAT(53), V28 FLOAT(53),
    amount          FLOAT(53),
    is_fraud        TINYINT
);
GO

CREATE INDEX idx_fraud  ON transactions(is_fraud);
CREATE INDEX idx_amount ON transactions(amount);
GO
