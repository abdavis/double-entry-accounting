CREATE TYPE account_type AS ENUM ('asset', 'liability', 'equity', 'revenue', 'expense');
CREATE TYPE summation_frequency AS ENUM('weekly', 'monthly', 'quarterly', 'yearly');

CREATE TABLE account_node(
    id INTEGER PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    description VARCHAR(500),
    parent INTEGER REFERENCES account_node(id),
    kind ACCOUNT_TYPE,
    frequency summation_frequency,
    CHECK (
        (parent IS NULL AND kind IS NOT NULL AND frequency IS NOT NULL) 
        OR (parent IS NOT NULL AND kind IS NULL AND frequency IS NULL)
        )
);

CREATE TABLE account(
    id INTEGER PRIMARY KEY,
    parent INTEGER REFERENCES account_node(id) NOT NULL,
    name VARCHAR(20),
    description VARCHAR(500)
);

CREATE TABLE balance(
    id INTEGER REFERENCES account(id),
    date TIMESTAMPTZ,
    amount MONEY,
    PRIMARY KEY(id, date)
);

CREATE TABLE transaction_type(
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(29) NOT NULL,
    description VARCHAR(500)
);

CREATE TABLE transaction(
    id INTEGER PRIMARY KEY,
    date TIMESTAMPTZ NOT NULL,
    type_code VARCHAR(10) REFERENCES transaction_type(code) NOT NULL,
    description VARCHAR(500)
);
CREATE INDEX transaction_date ON transaction(date);

CREATE TABLE transaction_detail(
    transaction_id INTEGER REFERENCES transaction(id) NOT NULL,
    dr INTEGER REFERENCES account(id) NOT NULL,
    cr INTEGER REFERENCES account(id) NOT NULL,
    amount MONEY NOT NULL,
    PRIMARY KEY(transaction_id, dr, cr)
);
CREATE INDEX detail_dr ON transaction_detail(dr);
CREATE INDEX detail_cr ON transaction_detail(dr);

