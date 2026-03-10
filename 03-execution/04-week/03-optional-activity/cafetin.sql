DROP DATABASE IF EXISTS coffee_shop;
CREATE DATABASE coffee_shop;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- MODULE 1: SECURITY

CREATE TABLE IF NOT EXISTS "user" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    username TEXT NOT NULL UNIQUE,
    email TEXT UNIQUE,
    password_hash TEXT,
    full_name TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS role (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS module (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS "view" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id UUID REFERENCES module(id) ON DELETE CASCADE,
    code TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    UNIQUE(module_id, code)
);

CREATE TABLE IF NOT EXISTS user_role (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES "user"(id) ON DELETE CASCADE,
    role_id UUID REFERENCES role(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS role_module (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id UUID REFERENCES role(id) ON DELETE CASCADE,
    module_id UUID REFERENCES module(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS module_view (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id UUID REFERENCES module(id) ON DELETE CASCADE,
    view_id UUID REFERENCES "view"(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- MODULE 2: PARAMETER
CREATE TABLE IF NOT EXISTS type_document (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS person (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type_document_id UUID REFERENCES type_document(id) ON DELETE SET NULL,
    document_number TEXT,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    phone TEXT,
    address TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS file (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID,
    bucket TEXT,
    name TEXT,
    path TEXT,
    size BIGINT,
    mime TEXT,
    url TEXT,
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);


-- MODULE 3: INVENTORY

CREATE TABLE IF NOT EXISTS category (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    description TEXT,
    parent_id UUID REFERENCES category(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS supplier (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    contact_name TEXT,
    email TEXT,
    phone TEXT,
    address TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS product (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sku TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    description TEXT,
    category_id UUID REFERENCES category(id) ON DELETE SET NULL,
    supplier_id UUID REFERENCES supplier(id) ON DELETE SET NULL,
    price NUMERIC(12,2) DEFAULT 0,
    cost NUMERIC(12,2) DEFAULT 0,
    stock INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now(),
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS inventory (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES product(id) ON DELETE CASCADE,
    change INTEGER NOT NULL,
    notes TEXT,
    occurred_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- MODULE 4: SALES

CREATE TABLE IF NOT EXISTS customer (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id UUID REFERENCES person(id) ON DELETE SET NULL,
    code TEXT UNIQUE,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    phone TEXT,
    address TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS "order" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    customer_id UUID REFERENCES customer(id) ON DELETE SET NULL,
    order_date TIMESTAMPTZ DEFAULT now(),
    sub_total NUMERIC(12,2) DEFAULT 0,
    tax NUMERIC(12,2) DEFAULT 0,
    total NUMERIC(12,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'PENDING',
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS order_item (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES "order"(id) ON DELETE CASCADE,
    product_id UUID REFERENCES product(id) ON DELETE SET NULL,
    quantity INTEGER DEFAULT 1,
    unit_price NUMERIC(12,2) DEFAULT 0,
    total NUMERIC(12,2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- MODULE 5: METHOD PAYMENT

CREATE TABLE IF NOT EXISTS method_payment (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

-- MODULE 6: BILLING

CREATE TABLE IF NOT EXISTS invoice (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_number TEXT NOT NULL UNIQUE,
    customer_id UUID REFERENCES customer(id) ON DELETE SET NULL,
    invoice_date TIMESTAMPTZ DEFAULT now(),
    sub_total NUMERIC(12,2) DEFAULT 0,
    tax NUMERIC(12,2) DEFAULT 0,
    total NUMERIC(12,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'DRAFT',
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS invoice_item (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id UUID REFERENCES invoice(id) ON DELETE CASCADE,
    product_id UUID REFERENCES product(id) ON DELETE SET NULL,
    description TEXT,
    quantity INTEGER DEFAULT 1,
    unit_price NUMERIC(12,2) DEFAULT 0,
    total NUMERIC(12,2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS payment (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id UUID REFERENCES invoice(id) ON DELETE SET NULL,
    method_payment_id UUID REFERENCES method_payment(id) ON DELETE SET NULL,
    amount NUMERIC(12,2) NOT NULL,
    paid_at TIMESTAMPTZ DEFAULT now(),
    reference TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- INSERTS

INSERT INTO type_document (code, name)
VALUES 
('CC', 'Cédula de Ciudadanía'),
('TI', 'Tarjeta de Identidad'),
('CE', 'Cédula de Extranjería');

INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id, '123456789', 'Juan', 'Pérez', 'juan@email.com', '3001234567', 'Calle 123'
FROM type_document WHERE code = 'CC';

INSERT INTO "user" (code, username, email, password_hash, full_name)
VALUES ('USR001', 'admin', 'admin@coffee.com', 'hash123', 'Administrador');

INSERT INTO role (name, description)
VALUES ('ADMIN', 'Administrador del sistema');

INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id
FROM "user" u, role r
WHERE u.username = 'admin' AND r.name = 'ADMIN';

INSERT INTO category (code, name, description)
VALUES ('COF', 'Café', 'Bebidas calientes');

INSERT INTO supplier (name, contact_name, email, phone, address)
VALUES ('Proveedor Central', 'Carlos Ruiz', 'proveedor@email.com', '3011111111', 'Zona Industrial');

INSERT INTO product (sku, name, description, category_id, supplier_id, price, cost, stock)
SELECT 'PROD001','Café Americano','Café negro',c.id,s.id,5000,2500,100
FROM category c, supplier s
WHERE c.code='COF'
LIMIT 1;

INSERT INTO customer (person_id, code, first_name, last_name, email, phone, address)
SELECT p.id,'CLI001',p.first_name,p.last_name,p.email,p.phone,p.address
FROM person p
WHERE p.document_number='123456789';

INSERT INTO "order" (code, customer_id, sub_total, tax, total)
SELECT 'ORD001',c.id,5000,950,5950
FROM customer c
WHERE c.code='CLI001';