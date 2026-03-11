DROP DATABASE IF EXISTS coffee_shop;
CREATE DATABASE coffee_shop;

\c coffee_shop;

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

CREATE TABLE IF NOT EXISTS role_view (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id UUID REFERENCES role(id) ON DELETE CASCADE,
    view_id UUID REFERENCES "view"(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(role_id, view_id)
);

-- MODULE 2: PARAMETERS

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

CREATE TABLE IF NOT EXISTS "file" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID REFERENCES "user"(id) ON DELETE SET NULL,
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
    user_id UUID REFERENCES "user"(id) ON DELETE SET NULL,
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
    created_at TIMESTAMPTZ DEFAULT now(),
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS method_payment (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS "order" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    customer_id UUID REFERENCES customer(id) ON DELETE SET NULL,
    method_payment_id UUID REFERENCES method_payment(id) ON DELETE SET NULL,
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

-- MODULE 6: BILLING

CREATE TABLE IF NOT EXISTS invoice (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_number TEXT NOT NULL UNIQUE,
    order_id UUID REFERENCES "order"(id) ON DELETE SET NULL,
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


/* Inserts */
-- Inserts in type of document

INSERT INTO type_document (code, name) VALUES
('CC',  'Cedula de Ciudadania'),
('CE',  'Cedula de Extranjeria'),
('PA',  'Pasaporte'),
('RC',  'Registro Civil'),
('NIT', 'NIT'),
('PEP', 'Permiso Especial de Permanencia'),
('DNI', 'Documento Nacional de Identidad'),
('LIC', 'Licencia de Conduccion'),
('PAS', 'Pasaporte Diplomatico'),
('OTR', 'Otro');

-- Inserts in roles

INSERT INTO role (name, description) VALUES
('MANAGER',    'Gerente general'),
('SELLER',     'Vendedor en tienda'),
('CASHIER',    'Cajero'),
('WAREHOUSE',  'Encargado de bodega'),
('ACCOUNTANT', 'Contador'),
('SUPPORT',    'Soporte tecnico'),
('HR',         'Recursos Humanos'),
('BARISTA',    'Barista especializado'),
('CLIENT',     'Cliente registrado'),
('GUEST',      'Invitado sin cuenta');

-- Inserts in modules

INSERT INTO module (code, name, description) VALUES
('SEC', 'Security', 'Seguridad y accesos'),
('PAR', 'Parameters', 'Parametros del sistema'),
('INV', 'Inventory', 'Inventario de productos'),
('SAL', 'Sales', 'Ventas y ordenes'),
('PAY', 'Payments', 'Metodos y pagos'),
('BIL', 'Billing', 'Facturacion'),
('REP', 'Reports', 'Reportes y estadisticas'),
('USR', 'Users', 'Gestion de usuarios'),
('PRO', 'Products', 'Catalogo de productos'),
('ORD', 'Orders', 'Gestion de ordenes');

-- Inserts in views — una por módulo

INSERT INTO "view" (module_id,code,name) SELECT id, 'USR_LIST', 'Lista de usuarios' FROM module WHERE code = 'USR';
INSERT INTO "view" (module_id,code,name) SELECT id, 'ROL_LIST', 'Lista de roles' FROM module WHERE code = 'SEC';
INSERT INTO "view" (module_id,code,name) SELECT id, 'DOC_TYPES', 'Tipos de documento' FROM module WHERE code = 'PAR';
INSERT INTO "view" (module_id,code,name) SELECT id, 'PERSONS', 'Personas' FROM module WHERE code = 'PAR';
INSERT INTO "view" (module_id,code,name) SELECT id, 'CATEGORIES', 'Categorias' FROM module WHERE code = 'INV';
INSERT INTO "view" (module_id,code,name) SELECT id, 'SUPPLIERS', 'Proveedores' FROM module WHERE code = 'INV';
INSERT INTO "view" (module_id,code,name) SELECT id, 'PRODUCTS', 'Productos' FROM module WHERE code = 'PRO';
INSERT INTO "view" (module_id,code,name) SELECT id, 'CUSTOMERS', 'Clientes' FROM module WHERE code = 'SAL';
INSERT INTO "view" (module_id,code,name) SELECT id, 'ORDERS', 'Ordenes' FROM module WHERE code = 'ORD';
INSERT INTO "view" (module_id,code,name) SELECT id, 'PAYMENTS', 'Pagos' FROM module WHERE code = 'PAY';

-- Inserts in users

INSERT INTO "user" (code, username, email, password_hash, full_name) VALUES
('USR001', 'jperez',    'jperez@coffee.com',    crypt('Pass1234!', gen_salt('bf')), 'Juan Perez'),
('USR002', 'mgomez',    'mgomez@coffee.com',    crypt('Pass1234!', gen_salt('bf')), 'Maria Gomez'),
('USR003', 'cropez',    'clopez@coffee.com',    crypt('Pass1234!', gen_salt('bf')), 'Carlos Lopez'),
('USR004', 'atorres',   'atorres@coffee.com',   crypt('Pass1234!', gen_salt('bf')), 'Ana Torres'),
('USR005', 'lmartinez', 'lmartinez@coffee.com', crypt('Pass1234!', gen_salt('bf')), 'Luis Martinez'),
('USR006', 'sruiz',     'sruiz@coffee.com',     crypt('Pass1234!', gen_salt('bf')), 'Sofia Ruiz'),
('USR007', 'dcastro',   'dcastro@coffee.com',   crypt('Pass1234!', gen_salt('bf')), 'David Castro'),
('USR008', 'ldiaz',     'ldiaz@coffee.com',     crypt('Pass1234!', gen_salt('bf')), 'Laura Diaz'),
('USR009', 'avargas',   'avargas@coffee.com',   crypt('Pass1234!', gen_salt('bf')), 'Andres Vargas'),
('USR010', 'cmora',     'cmora@coffee.com',     crypt('Pass1234!', gen_salt('bf')), 'Camila Mora');

-- Inserts in user_role — asignando roles a usuarios

INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM "user" u JOIN role r ON r.name = 'MANAGER'    WHERE u.code = 'USR001';
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM "user" u JOIN role r ON r.name = 'CASHIER'    WHERE u.code = 'USR002';
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM "user" u JOIN role r ON r.name = 'SELLER'     WHERE u.code = 'USR003';
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM "user" u JOIN role r ON r.name = 'WAREHOUSE'  WHERE u.code = 'USR004';
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM "user" u JOIN role r ON r.name = 'ACCOUNTANT' WHERE u.code = 'USR005';
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM "user" u JOIN role r ON r.name = 'SUPPORT'    WHERE u.code = 'USR006';
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM "user" u JOIN role r ON r.name = 'HR'         WHERE u.code = 'USR007';
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM "user" u JOIN role r ON r.name = 'BARISTA'    WHERE u.code = 'USR008';
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM "user" u JOIN role r ON r.name = 'SELLER'     WHERE u.code = 'USR009';
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM "user" u JOIN role r ON r.name = 'CASHIER'    WHERE u.code = 'USR010';

-- Inserts in role_view — asignando vistas a roles

INSERT INTO role_view (role_id, view_id)
SELECT r.id, v.id FROM role r JOIN "view" v ON v.code = 'USR_LIST'   WHERE r.name = 'MANAGER';
INSERT INTO role_view (role_id, view_id)
SELECT r.id, v.id FROM role r JOIN "view" v ON v.code = 'ROL_LIST'   WHERE r.name = 'MANAGER';
INSERT INTO role_view (role_id, view_id)
SELECT r.id, v.id FROM role r JOIN "view" v ON v.code = 'PRODUCTS'   WHERE r.name = 'SELLER';
INSERT INTO role_view (role_id, view_id)
SELECT r.id, v.id FROM role r JOIN "view" v ON v.code = 'ORDERS'     WHERE r.name = 'SELLER';
INSERT INTO role_view (role_id, view_id)
SELECT r.id, v.id FROM role r JOIN "view" v ON v.code = 'PAYMENTS'   WHERE r.name = 'CASHIER';
INSERT INTO role_view (role_id, view_id)
SELECT r.id, v.id FROM role r JOIN "view" v ON v.code = 'ORDERS'     WHERE r.name = 'CASHIER';
INSERT INTO role_view (role_id, view_id)
SELECT r.id, v.id FROM role r JOIN "view" v ON v.code = 'CATEGORIES' WHERE r.name = 'WAREHOUSE';
INSERT INTO role_view (role_id, view_id)
SELECT r.id, v.id FROM role r JOIN "view" v ON v.code = 'SUPPLIERS'  WHERE r.name = 'WAREHOUSE';
INSERT INTO role_view (role_id, view_id)
SELECT r.id, v.id FROM role r JOIN "view" v ON v.code = 'CUSTOMERS'  WHERE r.name = 'ACCOUNTANT';
INSERT INTO role_view (role_id, view_id)
SELECT r.id, v.id FROM role r JOIN "view" v ON v.code = 'PERSONS'    WHERE r.name = 'HR';

-- Inserts in person — personas asociadas a clientes

INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id, '100000001', 'Maria',   'Gomez',     'maria@email.com',   '3001000001', 'Calle 1 # 10-20'   FROM type_document WHERE code = 'CC';
INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id, '100000002', 'Pedro',   'Lopez',     'pedro@email.com',   '3001000002', 'Carrera 5 # 20-30' FROM type_document WHERE code = 'CC';
INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id, '100000003', 'Ana',     'Rodriguez', 'ana@email.com',     '3001000003', 'Avenida 3 # 1-10'  FROM type_document WHERE code = 'CC';
INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id, '100000004', 'Luis',    'Martinez',  'luis@email.com',    '3001000004', 'Calle 8 # 4-15'    FROM type_document WHERE code = 'CC';
INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id, '100000005', 'Sofia',   'Torres',    'sofia@email.com',   '3001000005', 'Diagonal 9 # 5-50' FROM type_document WHERE code = 'CC';
INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id, '100000006', 'Carlos',  'Ramirez',   'carlos@email.com',  '3001000006', 'Calle 12 # 6-60'   FROM type_document WHERE code = 'CC';
INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id, '100000007', 'Laura',   'Diaz',      'laura@email.com',   '3001000007', 'Transversal 7 # 7' FROM type_document WHERE code = 'CC';
INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id, '100000008', 'Andres',  'Castro',    'andres@email.com',  '3001000008', 'Calle 15 # 8-80'   FROM type_document WHERE code = 'CC';
INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id, '100000009', 'Camila',  'Vargas',    'camila@email.com',  '3001000009', 'Carrera 9 # 9-90'  FROM type_document WHERE code = 'CC';
INSERT INTO person (type_document_id, document_number, first_name, last_name, email, phone, address)
SELECT id, '100000010', 'Ricardo', 'Mora',      'ricardo@email.com', '3001000010', 'Calle 20 # 10-100' FROM type_document WHERE code = 'CC';

-- Inserts in file — archivos asociados a usuarios, productos, contratos, etc.

INSERT INTO file (owner_id, bucket, name, path, size, mime, url)
SELECT id, 'avatars', 'avatar_usr001.png', '/avatars/usr001.png', 204800,  'image/png',  'https://cdn.coffee.com/avatars/usr001.png' FROM "user" WHERE code = 'USR001';
INSERT INTO file (owner_id, bucket, name, path, size, mime, url)
SELECT id, 'avatars', 'avatar_usr002.png', '/avatars/usr002.png', 153600,  'image/png',  'https://cdn.coffee.com/avatars/usr002.png' FROM "user" WHERE code = 'USR002';
INSERT INTO file (owner_id, bucket, name, path, size, mime, url)
SELECT id, 'docs',    'contrato_001.pdf',  '/docs/contrato1.pdf', 512000,  'application/pdf', 'https://cdn.coffee.com/docs/contrato1.pdf' FROM "user" WHERE code = 'USR003';
INSERT INTO file (owner_id, bucket, name, path, size, mime, url)
SELECT id, 'docs',    'contrato_002.pdf',  '/docs/contrato2.pdf', 480000,  'application/pdf', 'https://cdn.coffee.com/docs/contrato2.pdf' FROM "user" WHERE code = 'USR004';
INSERT INTO file (owner_id, bucket, name, path, size, mime, url)
SELECT id, 'products','prod_espresso.jpg', '/products/001.jpg',   102400,  'image/jpeg', 'https://cdn.coffee.com/products/001.jpg'   FROM "user" WHERE code = 'USR001';
INSERT INTO file (owner_id, bucket, name, path, size, mime, url)
SELECT id, 'products','prod_latte.jpg',    '/products/002.jpg',   98304,   'image/jpeg', 'https://cdn.coffee.com/products/002.jpg'   FROM "user" WHERE code = 'USR001';
INSERT INTO file (owner_id, bucket, name, path, size, mime, url)
SELECT id, 'reports', 'reporte_ventas.xlsx','/reports/ventas.xlsx',307200, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'https://cdn.coffee.com/reports/ventas.xlsx' FROM "user" WHERE code = 'USR005';
INSERT INTO file (owner_id, bucket, name, path, size, mime, url)
SELECT id, 'avatars', 'avatar_usr008.png', '/avatars/usr008.png', 175000,  'image/png',  'https://cdn.coffee.com/avatars/usr008.png' FROM "user" WHERE code = 'USR008';
INSERT INTO file (owner_id, bucket, name, path, size, mime, url)
SELECT id, 'docs',    'menu_digital.pdf',  '/docs/menu.pdf',      620000,  'application/pdf', 'https://cdn.coffee.com/docs/menu.pdf'      FROM "user" WHERE code = 'USR001';
INSERT INTO file (owner_id, bucket, name, path, size, mime, url)
SELECT id, 'products','prod_brownie.jpg',  '/products/005.jpg',   88000,   'image/jpeg', 'https://cdn.coffee.com/products/005.jpg'   FROM "user" WHERE code = 'USR001';

-- DATA: CATEGORY (10)

INSERT INTO category (code, name, description) VALUES
('COF', 'Cafe',      'Bebidas a base de cafe'),
('TE',  'Te',        'Infusiones y tes'),
('DES', 'Postres',   'Postres y dulces'),
('SAN', 'Sandwich',  'Sandwiches y wraps'),
('HEL', 'Helados',   'Helados y sorbetes'),
('JUG', 'Jugos',     'Jugos naturales y smoothies'),
('PAN', 'Panaderia', 'Pan artesanal y croissants'),
('BEB', 'Bebidas',   'Bebidas frias sin cafe'),
('ESP', 'Especiales','Bebidas de temporada'),
('OTR', 'Otros',     'Otros productos');

-- DATA: SUPPLIER (10)

INSERT INTO supplier (name, contact_name, email, phone, address) VALUES
('Proveedor Cafe',    'Juan Perez',   'prove_cafe@email.com',    '3100000100', 'Zona Cafetera, Eje Cafetero'),
('Proveedor Dulces',  'Maria Ruiz',   'prove_dulces@email.com',  '3100000101', 'Calle Dulce 10, Bogota'),
('Proveedor Pan',     'Luis Castro',  'prove_pan@email.com',     '3100000102', 'Carrera 5 # 20, Medellin'),
('Proveedor Helados', 'Laura Diaz',   'prove_helados@email.com', '3100000103', 'Avenida 68, Bogota'),
('Proveedor Jugos',   'Ana Torres',   'prove_jugos@email.com',   '3100000104', 'Zona Fruticola, Valle'),
('Proveedor Snacks',  'Pedro Lopez',  'prove_snacks@email.com',  '3100000105', 'Parque Industrial, Cali'),
('Proveedor Norte',   'Luis Ruiz',    'prove_norte@email.com',   '3100000106', 'Zona Norte, Barranquilla'),
('Proveedor Sur',     'Ana Gomez',    'prove_sur@email.com',     '3100000107', 'Zona Sur, Pasto'),
('Proveedor Este',    'Carlos Diaz',  'prove_este@email.com',    '3100000108', 'Zona Este, Villavicencio'),
('Proveedor Organico','Sofia Mora',   'prove_org@email.com',     '3100000109', 'Finca Organica, Huila');

-- DATA: PRODUCT (10)

INSERT INTO product (sku, name, description, category_id, supplier_id, price, cost, stock)
SELECT 'PROD001','Cafe Espresso',    'Cafe puro concentrado',      c.id, s.id, 5000, 2500, 100
FROM category c JOIN supplier s ON s.name = 'Proveedor Cafe'    WHERE c.code = 'COF';

INSERT INTO product (sku, name, description, category_id, supplier_id, price, cost, stock)
SELECT 'PROD002','Cafe Latte',       'Cafe con leche vaporizada',  c.id, s.id, 6000, 3000,  80
FROM category c JOIN supplier s ON s.name = 'Proveedor Cafe'    WHERE c.code = 'COF';

INSERT INTO product (sku, name, description, category_id, supplier_id, price, cost, stock)
SELECT 'PROD003','Capuccino',        'Cafe con espuma de leche',   c.id, s.id, 6500, 3200,  70
FROM category c JOIN supplier s ON s.name = 'Proveedor Cafe'    WHERE c.code = 'COF';

INSERT INTO product (sku, name, description, category_id, supplier_id, price, cost, stock)
SELECT 'PROD004','Te Verde',         'Infusion de te verde',       c.id, s.id, 4000, 2000,  60
FROM category c JOIN supplier s ON s.name = 'Proveedor Norte'   WHERE c.code = 'TE';

INSERT INTO product (sku, name, description, category_id, supplier_id, price, cost, stock)
SELECT 'PROD005','Brownie',          'Brownie de chocolate',       c.id, s.id, 4500, 2200,  50
FROM category c JOIN supplier s ON s.name = 'Proveedor Dulces'  WHERE c.code = 'DES';

INSERT INTO product (sku, name, description, category_id, supplier_id, price, cost, stock)
SELECT 'PROD006','Cheesecake',       'Tarta de queso cremosa',     c.id, s.id, 7000, 3500,  40
FROM category c JOIN supplier s ON s.name = 'Proveedor Dulces'  WHERE c.code = 'DES';

INSERT INTO product (sku, name, description, category_id, supplier_id, price, cost, stock)
SELECT 'PROD007','Sandwich Jamon',   'Sandwich de jamon y queso',  c.id, s.id, 8000, 4000,  30
FROM category c JOIN supplier s ON s.name = 'Proveedor Snacks'  WHERE c.code = 'SAN';

INSERT INTO product (sku, name, description, category_id, supplier_id, price, cost, stock)
SELECT 'PROD008','Helado Vainilla',  'Helado artesanal vainilla',  c.id, s.id, 5000, 2500,  25
FROM category c JOIN supplier s ON s.name = 'Proveedor Helados' WHERE c.code = 'HEL';

INSERT INTO product (sku, name, description, category_id, supplier_id, price, cost, stock)
SELECT 'PROD009','Chocolate Caliente','Chocolate cremoso caliente',c.id, s.id, 5500, 2700,  40
FROM category c JOIN supplier s ON s.name = 'Proveedor Norte'   WHERE c.code = 'BEB';

INSERT INTO product (sku, name, description, category_id, supplier_id, price, cost, stock)
SELECT 'PROD010','Mocha',            'Cafe con chocolate',         c.id, s.id, 7000, 3500,  30
FROM category c JOIN supplier s ON s.name = 'Proveedor Cafe'    WHERE c.code = 'COF';

-- DATA: INVENTORY (10) — movimientos de stock

INSERT INTO inventory (product_id, user_id, change, notes)
SELECT p.id, u.id,  100, 'Carga inicial de inventario'   FROM product p JOIN "user" u ON u.code = 'USR004' WHERE p.sku = 'PROD001';
INSERT INTO inventory (product_id, user_id, change, notes)
SELECT p.id, u.id,   80, 'Carga inicial de inventario'   FROM product p JOIN "user" u ON u.code = 'USR004' WHERE p.sku = 'PROD002';
INSERT INTO inventory (product_id, user_id, change, notes)
SELECT p.id, u.id,   70, 'Carga inicial de inventario'   FROM product p JOIN "user" u ON u.code = 'USR004' WHERE p.sku = 'PROD003';
INSERT INTO inventory (product_id, user_id, change, notes)
SELECT p.id, u.id,   60, 'Carga inicial de inventario'   FROM product p JOIN "user" u ON u.code = 'USR004' WHERE p.sku = 'PROD004';
INSERT INTO inventory (product_id, user_id, change, notes)
SELECT p.id, u.id,   50, 'Carga inicial de inventario'   FROM product p JOIN "user" u ON u.code = 'USR004' WHERE p.sku = 'PROD005';
INSERT INTO inventory (product_id, user_id, change, notes)
SELECT p.id, u.id,  -10, 'Ajuste por merma'              FROM product p JOIN "user" u ON u.code = 'USR001' WHERE p.sku = 'PROD005';
INSERT INTO inventory (product_id, user_id, change, notes)
SELECT p.id, u.id,   30, 'Reposicion de stock'           FROM product p JOIN "user" u ON u.code = 'USR004' WHERE p.sku = 'PROD007';
INSERT INTO inventory (product_id, user_id, change, notes)
SELECT p.id, u.id,  -5,  'Devolucion a proveedor'        FROM product p JOIN "user" u ON u.code = 'USR001' WHERE p.sku = 'PROD008';
INSERT INTO inventory (product_id, user_id, change, notes)
SELECT p.id, u.id,   40, 'Compra de emergencia'          FROM product p JOIN "user" u ON u.code = 'USR004' WHERE p.sku = 'PROD009';
INSERT INTO inventory (product_id, user_id, change, notes)
SELECT p.id, u.id,   25, 'Reposicion mensual'            FROM product p JOIN "user" u ON u.code = 'USR004' WHERE p.sku = 'PROD010';

-- DATA: METHOD PAYMENT (10)

INSERT INTO method_payment (code, name, description) VALUES
('CASH',       'Efectivo',       'Pago en efectivo'),
('DEBIT',      'Tarjeta Debito', 'Tarjeta debito'),
('CREDIT',     'Tarjeta Credito','Tarjeta credito'),
('TRANSFER',   'Transferencia',  'Transferencia bancaria'),
('NEQUI',      'Nequi',          'Pago por Nequi'),
('DAVIPLATA',  'Daviplata',      'Pago por Daviplata'),
('PSE',        'PSE',            'Pago por PSE'),
('BOLD',       'Bold',           'Datafono Bold'),
('WOMPI',      'Wompi',          'Pasarela Wompi'),
('GIFT_CARD',  'Gift Card',      'Tarjeta de regalo');

-- DATA: CUSTOMER (10)

INSERT INTO customer (person_id, code)
SELECT id, 'CLI001' FROM person WHERE document_number = '100000001';
INSERT INTO customer (person_id, code)
SELECT id, 'CLI002' FROM person WHERE document_number = '100000002';
INSERT INTO customer (person_id, code)
SELECT id, 'CLI003' FROM person WHERE document_number = '100000003';
INSERT INTO customer (person_id, code)
SELECT id, 'CLI004' FROM person WHERE document_number = '100000004';
INSERT INTO customer (person_id, code)
SELECT id, 'CLI005' FROM person WHERE document_number = '100000005';
INSERT INTO customer (person_id, code)
SELECT id, 'CLI006' FROM person WHERE document_number = '100000006';
INSERT INTO customer (person_id, code)
SELECT id, 'CLI007' FROM person WHERE document_number = '100000007';
INSERT INTO customer (person_id, code)
SELECT id, 'CLI008' FROM person WHERE document_number = '100000008';
INSERT INTO customer (person_id, code)
SELECT id, 'CLI009' FROM person WHERE document_number = '100000009';
INSERT INTO customer (person_id, code)
SELECT id, 'CLI010' FROM person WHERE document_number = '100000010';

-- DATA: ORDER (10)

INSERT INTO "order" (code, customer_id, method_payment_id, sub_total, tax, total, status)
SELECT 'ORD-001', c.id, mp.id, 11000.00, 2090.00, 13090.00, 'DELIVERED'
FROM customer c JOIN method_payment mp ON mp.code = 'CASH'      WHERE c.code = 'CLI001';
INSERT INTO "order" (code, customer_id, method_payment_id, sub_total, tax, total, status)
SELECT 'ORD-002', c.id, mp.id, 13500.00, 2565.00, 16065.00, 'DELIVERED'
FROM customer c JOIN method_payment mp ON mp.code = 'NEQUI'     WHERE c.code = 'CLI002';
INSERT INTO "order" (code, customer_id, method_payment_id, sub_total, tax, total, status)
SELECT 'ORD-003', c.id, mp.id,  7000.00, 1330.00,  8330.00, 'DELIVERED'
FROM customer c JOIN method_payment mp ON mp.code = 'DEBIT'     WHERE c.code = 'CLI003';
INSERT INTO "order" (code, customer_id, method_payment_id, sub_total, tax, total, status)
SELECT 'ORD-004', c.id, mp.id, 15000.00, 2850.00, 17850.00, 'DELIVERED'
FROM customer c JOIN method_payment mp ON mp.code = 'CREDIT'    WHERE c.code = 'CLI004';
INSERT INTO "order" (code, customer_id, method_payment_id, sub_total, tax, total, status)
SELECT 'ORD-005', c.id, mp.id,  9500.00, 1805.00, 11305.00, 'DELIVERED'
FROM customer c JOIN method_payment mp ON mp.code = 'DAVIPLATA' WHERE c.code = 'CLI005';
INSERT INTO "order" (code, customer_id, method_payment_id, sub_total, tax, total, status)
SELECT 'ORD-006', c.id, mp.id, 12000.00, 2280.00, 14280.00, 'PREPARING'
FROM customer c JOIN method_payment mp ON mp.code = 'CASH'      WHERE c.code = 'CLI006';
INSERT INTO "order" (code, customer_id, method_payment_id, sub_total, tax, total, status)
SELECT 'ORD-007', c.id, mp.id,  6500.00, 1235.00,  7735.00, 'CONFIRMED'
FROM customer c JOIN method_payment mp ON mp.code = 'NEQUI'     WHERE c.code = 'CLI007';
INSERT INTO "order" (code, customer_id, method_payment_id, sub_total, tax, total, status)
SELECT 'ORD-008', c.id, mp.id, 21000.00, 3990.00, 24990.00, 'PENDING'
FROM customer c JOIN method_payment mp ON mp.code = 'PSE'       WHERE c.code = 'CLI008';
INSERT INTO "order" (code, customer_id, method_payment_id, sub_total, tax, total, status)
SELECT 'ORD-009', c.id, mp.id,  5000.00,  950.00,  5950.00, 'CANCELLED'
FROM customer c JOIN method_payment mp ON mp.code = 'CASH'      WHERE c.code = 'CLI009';
INSERT INTO "order" (code, customer_id, method_payment_id, sub_total, tax, total, status)
SELECT 'ORD-010', c.id, mp.id, 18500.00, 3515.00, 22015.00, 'DELIVERED'
FROM customer c JOIN method_payment mp ON mp.code = 'WOMPI'     WHERE c.code = 'CLI010';

-- DATA: ORDER_ITEM (10)

INSERT INTO order_item (order_id, product_id, quantity, unit_price, total)
SELECT o.id, p.id, 2, 5000.00, 10000.00 FROM "order" o JOIN product p ON p.sku = 'PROD001' WHERE o.code = 'ORD-001';
INSERT INTO order_item (order_id, product_id, quantity, unit_price, total)
SELECT o.id, p.id, 1, 4500.00,  4500.00 FROM "order" o JOIN product p ON p.sku = 'PROD005' WHERE o.code = 'ORD-001';
INSERT INTO order_item (order_id, product_id, quantity, unit_price, total)
SELECT o.id, p.id, 1, 6500.00,  6500.00 FROM "order" o JOIN product p ON p.sku = 'PROD003' WHERE o.code = 'ORD-002';
INSERT INTO order_item (order_id, product_id, quantity, unit_price, total)
SELECT o.id, p.id, 1, 7000.00,  7000.00 FROM "order" o JOIN product p ON p.sku = 'PROD006' WHERE o.code = 'ORD-002';
INSERT INTO order_item (order_id, product_id, quantity, unit_price, total)
SELECT o.id, p.id, 1, 7000.00,  7000.00 FROM "order" o JOIN product p ON p.sku = 'PROD010' WHERE o.code = 'ORD-003';
INSERT INTO order_item (order_id, product_id, quantity, unit_price, total)
SELECT o.id, p.id, 2, 6000.00, 12000.00 FROM "order" o JOIN product p ON p.sku = 'PROD002' WHERE o.code = 'ORD-004';
INSERT INTO order_item (order_id, product_id, quantity, unit_price, total)
SELECT o.id, p.id, 1, 8000.00,  8000.00 FROM "order" o JOIN product p ON p.sku = 'PROD007' WHERE o.code = 'ORD-005';
INSERT INTO order_item (order_id, product_id, quantity, unit_price, total)
SELECT o.id, p.id, 2, 6000.00, 12000.00 FROM "order" o JOIN product p ON p.sku = 'PROD002' WHERE o.code = 'ORD-006';
INSERT INTO order_item (order_id, product_id, quantity, unit_price, total)
SELECT o.id, p.id, 1, 6500.00,  6500.00 FROM "order" o JOIN product p ON p.sku = 'PROD003' WHERE o.code = 'ORD-007';
INSERT INTO order_item (order_id, product_id, quantity, unit_price, total)
SELECT o.id, p.id, 3, 7000.00, 21000.00 FROM "order" o JOIN product p ON p.sku = 'PROD010' WHERE o.code = 'ORD-008';

-- DATA: INVOICE (10)

INSERT INTO invoice (invoice_number, order_id, customer_id, sub_total, tax, total, status)
SELECT 'INV-2024-001', o.id, o.customer_id, 11000.00, 2090.00, 13090.00, 'PAID'
FROM "order" o WHERE o.code = 'ORD-001';
INSERT INTO invoice (invoice_number, order_id, customer_id, sub_total, tax, total, status)
SELECT 'INV-2024-002', o.id, o.customer_id, 13500.00, 2565.00, 16065.00, 'PAID'
FROM "order" o WHERE o.code = 'ORD-002';
INSERT INTO invoice (invoice_number, order_id, customer_id, sub_total, tax, total, status)
SELECT 'INV-2024-003', o.id, o.customer_id,  7000.00, 1330.00,  8330.00, 'PAID'
FROM "order" o WHERE o.code = 'ORD-003';
INSERT INTO invoice (invoice_number, order_id, customer_id, sub_total, tax, total, status)
SELECT 'INV-2024-004', o.id, o.customer_id, 15000.00, 2850.00, 17850.00, 'PAID'
FROM "order" o WHERE o.code = 'ORD-004';
INSERT INTO invoice (invoice_number, order_id, customer_id, sub_total, tax, total, status)
SELECT 'INV-2024-005', o.id, o.customer_id,  9500.00, 1805.00, 11305.00, 'PAID'
FROM "order" o WHERE o.code = 'ORD-005';
INSERT INTO invoice (invoice_number, order_id, customer_id, sub_total, tax, total, status)
SELECT 'INV-2024-006', o.id, o.customer_id, 12000.00, 2280.00, 14280.00, 'ISSUED'
FROM "order" o WHERE o.code = 'ORD-006';
INSERT INTO invoice (invoice_number, order_id, customer_id, sub_total, tax, total, status)
SELECT 'INV-2024-007', o.id, o.customer_id,  6500.00, 1235.00,  7735.00, 'ISSUED'
FROM "order" o WHERE o.code = 'ORD-007';
INSERT INTO invoice (invoice_number, order_id, customer_id, sub_total, tax, total, status)
SELECT 'INV-2024-008', o.id, o.customer_id, 21000.00, 3990.00, 24990.00, 'DRAFT'
FROM "order" o WHERE o.code = 'ORD-008';
INSERT INTO invoice (invoice_number, order_id, customer_id, sub_total, tax, total, status)
SELECT 'INV-2024-009', o.id, o.customer_id,  5000.00,  950.00,  5950.00, 'CANCELLED'
FROM "order" o WHERE o.code = 'ORD-009';
INSERT INTO invoice (invoice_number, order_id, customer_id, sub_total, tax, total, status)
SELECT 'INV-2024-010', o.id, o.customer_id, 18500.00, 3515.00, 22015.00, 'PAID'
FROM "order" o WHERE o.code = 'ORD-010';

-- DATA: INVOICE_ITEM (10)

INSERT INTO invoice_item (invoice_id, product_id, description, quantity, unit_price, total)
SELECT i.id, p.id, 'Cafe Espresso x2',    2, 5000.00, 10000.00 FROM invoice i JOIN product p ON p.sku = 'PROD001' WHERE i.invoice_number = 'INV-2024-001';
INSERT INTO invoice_item (invoice_id, product_id, description, quantity, unit_price, total)
SELECT i.id, p.id, 'Brownie x1',          1, 4500.00,  4500.00 FROM invoice i JOIN product p ON p.sku = 'PROD005' WHERE i.invoice_number = 'INV-2024-001';
INSERT INTO invoice_item (invoice_id, product_id, description, quantity, unit_price, total)
SELECT i.id, p.id, 'Capuccino x1',        1, 6500.00,  6500.00 FROM invoice i JOIN product p ON p.sku = 'PROD003' WHERE i.invoice_number = 'INV-2024-002';
INSERT INTO invoice_item (invoice_id, product_id, description, quantity, unit_price, total)
SELECT i.id, p.id, 'Cheesecake x1',       1, 7000.00,  7000.00 FROM invoice i JOIN product p ON p.sku = 'PROD006' WHERE i.invoice_number = 'INV-2024-002';
INSERT INTO invoice_item (invoice_id, product_id, description, quantity, unit_price, total)
SELECT i.id, p.id, 'Mocha x1',            1, 7000.00,  7000.00 FROM invoice i JOIN product p ON p.sku = 'PROD010' WHERE i.invoice_number = 'INV-2024-003';
INSERT INTO invoice_item (invoice_id, product_id, description, quantity, unit_price, total)
SELECT i.id, p.id, 'Cafe Latte x2',       2, 6000.00, 12000.00 FROM invoice i JOIN product p ON p.sku = 'PROD002' WHERE i.invoice_number = 'INV-2024-004';
INSERT INTO invoice_item (invoice_id, product_id, description, quantity, unit_price, total)
SELECT i.id, p.id, 'Sandwich Jamon x1',   1, 8000.00,  8000.00 FROM invoice i JOIN product p ON p.sku = 'PROD007' WHERE i.invoice_number = 'INV-2024-005';
INSERT INTO invoice_item (invoice_id, product_id, description, quantity, unit_price, total)
SELECT i.id, p.id, 'Cafe Latte x2',       2, 6000.00, 12000.00 FROM invoice i JOIN product p ON p.sku = 'PROD002' WHERE i.invoice_number = 'INV-2024-006';
INSERT INTO invoice_item (invoice_id, product_id, description, quantity, unit_price, total)
SELECT i.id, p.id, 'Capuccino x1',        1, 6500.00,  6500.00 FROM invoice i JOIN product p ON p.sku = 'PROD003' WHERE i.invoice_number = 'INV-2024-007';
INSERT INTO invoice_item (invoice_id, product_id, description, quantity, unit_price, total)
SELECT i.id, p.id, 'Mocha x3',            3, 7000.00, 21000.00 FROM invoice i JOIN product p ON p.sku = 'PROD010' WHERE i.invoice_number = 'INV-2024-008';

-- DATA: PAYMENT (10)

INSERT INTO payment (invoice_id, method_payment_id, amount, reference)
SELECT i.id, mp.id, 13090.00, 'REF-CASH-001'  FROM invoice i JOIN method_payment mp ON mp.code = 'CASH'      WHERE i.invoice_number = 'INV-2024-001';
INSERT INTO payment (invoice_id, method_payment_id, amount, reference)
SELECT i.id, mp.id, 16065.00, 'REF-NEQ-002'   FROM invoice i JOIN method_payment mp ON mp.code = 'NEQUI'     WHERE i.invoice_number = 'INV-2024-002';
INSERT INTO payment (invoice_id, method_payment_id, amount, reference)
SELECT i.id, mp.id,  8330.00, 'REF-DEB-003'   FROM invoice i JOIN method_payment mp ON mp.code = 'DEBIT'     WHERE i.invoice_number = 'INV-2024-003';
INSERT INTO payment (invoice_id, method_payment_id, amount, reference)
SELECT i.id, mp.id, 17850.00, 'REF-CRE-004'   FROM invoice i JOIN method_payment mp ON mp.code = 'CREDIT'    WHERE i.invoice_number = 'INV-2024-004';
INSERT INTO payment (invoice_id, method_payment_id, amount, reference)
SELECT i.id, mp.id, 11305.00, 'REF-DAV-005'   FROM invoice i JOIN method_payment mp ON mp.code = 'DAVIPLATA' WHERE i.invoice_number = 'INV-2024-005';
INSERT INTO payment (invoice_id, method_payment_id, amount, reference)
SELECT i.id, mp.id, 14280.00, 'REF-CASH-006'  FROM invoice i JOIN method_payment mp ON mp.code = 'CASH'      WHERE i.invoice_number = 'INV-2024-006';
INSERT INTO payment (invoice_id, method_payment_id, amount, reference)
SELECT i.id, mp.id,  7735.00, 'REF-NEQ-007'   FROM invoice i JOIN method_payment mp ON mp.code = 'NEQUI'     WHERE i.invoice_number = 'INV-2024-007';
INSERT INTO payment (invoice_id, method_payment_id, amount, reference)
SELECT i.id, mp.id, 10000.00, 'REF-PSE-008-PARCIAL' FROM invoice i JOIN method_payment mp ON mp.code = 'PSE' WHERE i.invoice_number = 'INV-2024-008';
INSERT INTO payment (invoice_id, method_payment_id, amount, reference)
SELECT i.id, mp.id,  5950.00, 'REF-CASH-009'  FROM invoice i JOIN method_payment mp ON mp.code = 'CASH'      WHERE i.invoice_number = 'INV-2024-009';
INSERT INTO payment (invoice_id, method_payment_id, amount, reference)
SELECT i.id, mp.id, 22015.00, 'REF-WOM-010'   FROM invoice i JOIN method_payment mp ON mp.code = 'WOMPI'     WHERE i.invoice_number = 'INV-2024-010';