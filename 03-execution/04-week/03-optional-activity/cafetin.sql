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

INSERT INTO type_document (code, name) VALUES
('PA','Pasaporte'),
('RC','Registro Civil'),
('NIT','NIT'),
('PEP','Permiso Especial Permanencia'),
('DNI','Documento Nacional'),
('LIC','Licencia'),
('OTR','Otro'),
('PAS','Pasaporte Diplomatico');

INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id,'100000001','Maria','Gomez','maria@email.com','300000001','Calle 1'
FROM type_document WHERE code='CC';

INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id,'100000002','Pedro','Lopez','pedro@email.com','300000002','Calle 2'
FROM type_document WHERE code='CC';

INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id,'100000003','Ana','Rodriguez','ana@email.com','300000003','Calle 3'
FROM type_document WHERE code='CC';

INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id,'100000004','Luis','Martinez','luis@email.com','300000004','Calle 4'
FROM type_document WHERE code='CC';

INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id,'100000005','Sofia','Torres','sofia@email.com','300000005','Calle 5'
FROM type_document WHERE code='CC';

INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id,'100000006','Carlos','Ramirez','carlos@email.com','300000006','Calle 6'
FROM type_document WHERE code='CC';

INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id,'100000007','Laura','Diaz','laura@email.com','300000007','Calle 7'
FROM type_document WHERE code='CC';

INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id,'100000008','Andres','Castro','andres@email.com','300000008','Calle 8'
FROM type_document WHERE code='CC';

INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id,'100000009','Camila','Vargas','camila@email.com','300000009','Calle 9'
FROM type_document WHERE code='CC';

-- ROLE

INSERT INTO role (name, description) VALUES
('MANAGER','Gerente'),
('SELLER','Vendedor'),
('CASHIER','Cajero'),
('WAREHOUSE','Bodega'),
('ACCOUNTANT','Contador'),
('SUPPORT','Soporte'),
('HR','Recursos Humanos'),
('CLIENT','Cliente'),
('GUEST','Invitado');

-- MODULE

INSERT INTO module (code,name,description) VALUES
('SEC','Security','Seguridad'),
('PAR','Parameters','Parametros'),
('INV','Inventory','Inventario'),
('SAL','Sales','Ventas'),
('PAY','Payments','Pagos'),
('BIL','Billing','Facturacion'),
('REP','Reports','Reportes'),
('USR','Users','Usuarios'),
('PRO','Products','Productos'),
('ORD','Orders','Ordenes');

-- VIEW

INSERT INTO "view"(module_id,code,name)
SELECT id,'USR_LIST','Lista usuarios' FROM module WHERE code='USR';

INSERT INTO "view"(module_id,code,name)
SELECT id,'ROL_LIST','Lista roles' FROM module WHERE code='SEC';

INSERT INTO "view"(module_id,code,name)
SELECT id,'DOC_TYPES','Tipos documento' FROM module WHERE code='PAR';

INSERT INTO "view"(module_id,code,name)
SELECT id,'PERSONS','Personas' FROM module WHERE code='PAR';

INSERT INTO "view"(module_id,code,name)
SELECT id,'CATEGORIES','Categorias' FROM module WHERE code='INV';

INSERT INTO "view"(module_id,code,name)
SELECT id,'SUPPLIERS','Proveedores' FROM module WHERE code='INV';

INSERT INTO "view"(module_id,code,name)
SELECT id,'PRODUCTS','Productos' FROM module WHERE code='INV';

INSERT INTO "view"(module_id,code,name)
SELECT id,'CUSTOMERS','Clientes' FROM module WHERE code='SAL';

INSERT INTO "view"(module_id,code,name)
SELECT id,'ORDERS','Ordenes' FROM module WHERE code='SAL';

INSERT INTO "view"(module_id,code,name)
SELECT id,'PAYMENTS','Pagos' FROM module WHERE code='PAY';

-- CATEGORY

INSERT INTO category(code,name,description) VALUES
('COF','Cafe','Bebidas cafe'),
('TE','Te','Bebidas te'),
('DES','Postres','Postres dulces'),
('SAN','Sandwich','Sandwiches'),
('HEL','Helados','Helados'),
('JUG','Jugos','Jugos naturales'),
('PAN','Panaderia','Productos pan'),
('BEB','Bebidas','Bebidas frias'),
('ESP','Especiales','Especialidades'),
('OTR','Otros','Otros productos');

-- SUPPLIER

INSERT INTO supplier(name,contact_name,email,phone,address) VALUES
('Proveedor Norte','Luis Ruiz','prove1@email.com','300000100','Zona Norte'),
('Proveedor Sur','Ana Gomez','prove2@email.com','300000101','Zona Sur'),
('Proveedor Este','Carlos Diaz','prove3@email.com','300000102','Zona Este'),
('Proveedor Oeste','Pedro Mora','prove4@email.com','300000103','Zona Oeste'),
('Proveedor Cafe','Juan Perez','prove5@email.com','300000104','Zona Cafe'),
('Proveedor Dulces','Maria Ruiz','prove6@email.com','300000105','Zona Dulces'),
('Proveedor Pan','Luis Castro','prove7@email.com','300000106','Zona Pan'),
('Proveedor Helados','Laura Diaz','prove8@email.com','300000107','Zona Helados'),
('Proveedor Jugos','Ana Torres','prove9@email.com','300000108','Zona Jugos'),
('Proveedor Snacks','Pedro Lopez','prove10@email.com','300000109','Zona Snacks');

-- PRODUCT

INSERT INTO product (sku,name,description,category_id,supplier_id,price,cost,stock)
SELECT 'PROD002','Cafe Latte','Cafe con leche',c.id,s.id,6000,3000,80
FROM category c,supplier s
WHERE c.code='COF'
LIMIT 1;

INSERT INTO product (sku,name,description,category_id,supplier_id,price,cost,stock)
SELECT 'PROD003','Capuccino','Cafe espumoso',c.id,s.id,6500,3200,70
FROM category c,supplier s
WHERE c.code='COF'
LIMIT 1;

INSERT INTO product (sku,name,description,category_id,supplier_id,price,cost,stock)
SELECT 'PROD004','Te Verde','Te caliente',c.id,s.id,4000,2000,60
FROM category c,supplier s
WHERE c.code='TE'
LIMIT 1;

INSERT INTO product (sku,name,description,category_id,supplier_id,price,cost,stock)
SELECT 'PROD005','Brownie','Postre chocolate',c.id,s.id,4500,2200,50
FROM category c,supplier s
WHERE c.code='DES'
LIMIT 1;

INSERT INTO product (sku,name,description,category_id,supplier_id,price,cost,stock)
SELECT 'PROD006','Cheesecake','Postre queso',c.id,s.id,7000,3500,40
FROM category c,supplier s
WHERE c.code='DES'
LIMIT 1;

INSERT INTO product (sku,name,description,category_id,supplier_id,price,cost,stock)
SELECT 'PROD007','Sandwich','Sandwich jamon',c.id,s.id,8000,4000,30
FROM category c,supplier s
WHERE c.code='SAN'
LIMIT 1;

INSERT INTO product (sku,name,description,category_id,supplier_id,price,cost,stock)
SELECT 'PROD008','Helado','Helado vainilla',c.id,s.id,5000,2500,25
FROM category c,supplier s
WHERE c.code='HEL'
LIMIT 1;

INSERT INTO product (sku,name,description,category_id,supplier_id,price,cost,stock)
SELECT 'PROD009','Chocolate','Chocolate caliente',c.id,s.id,5500,2700,40
FROM category c,supplier s
WHERE c.code='BEB'
LIMIT 1;

INSERT INTO product (sku,name,description,category_id,supplier_id,price,cost,stock)
SELECT 'PROD010','Mocha','Cafe mocha',c.id,s.id,7000,3500,30
FROM category c,supplier s
WHERE c.code='COF'
LIMIT 1;