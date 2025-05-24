CREATE TABLE IF NOT EXISTS mock_data (
    id SERIAL PRIMARY KEY,
    customer_first_name VARCHAR(100),
    customer_last_name VARCHAR(100),
    customer_age INT,
    customer_email VARCHAR(255),
    customer_country VARCHAR(100),
    customer_postal_code VARCHAR(20),
    customer_pet_type VARCHAR(100),
    customer_pet_name VARCHAR(100),
    customer_pet_breed VARCHAR(100),
    seller_first_name VARCHAR(100),
    seller_last_name VARCHAR(100),
    seller_email VARCHAR(255),
    seller_country VARCHAR(100),
    seller_postal_code VARCHAR(20),
    product_name VARCHAR(255),
    product_category VARCHAR(100),
    product_price DECIMAL(10, 2),
    product_quantity INT,
    sale_date DATE,
    sale_customer_id INT,
    sale_seller_id INT,
    sale_product_id INT,
    sale_quantity INT,
    sale_total_price DECIMAL(10, 2),
    store_name VARCHAR(255),
    store_location VARCHAR(255),
    store_city VARCHAR(100),
    store_state VARCHAR(100),
    store_country VARCHAR(100),
    store_phone VARCHAR(50),
    store_email VARCHAR(255),
    pet_category VARCHAR(100),
    product_weight FLOAT,
    product_color VARCHAR(50),
    product_size VARCHAR(50),
    product_brand VARCHAR(100),
    product_material VARCHAR(100),
    product_description TEXT,
    product_rating FLOAT,
    product_reviews INT,
    product_release_date DATE,
    product_expiry_date DATE,
    supplier_name VARCHAR(255),
    supplier_contact VARCHAR(255),
    supplier_email VARCHAR(255),
    supplier_phone VARCHAR(50),
    supplier_address TEXT,
    supplier_city VARCHAR(100),
    supplier_country VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS countries (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS cities (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS states (
    state_id SERIAL PRIMARY KEY,
    state_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS postal_codes (
    postal_code_id SERIAL PRIMARY KEY,
    postal_code VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS pet_types (
    pet_type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS pet_breeds (
    pet_breed_id SERIAL PRIMARY KEY,
    breed_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS pet_categories (
    pet_category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS pets (
    pet_id SERIAL PRIMARY KEY,
    pet_name VARCHAR(100),
    pet_type_id INT REFERENCES pet_types(pet_type_id),
    pet_breed_id INT REFERENCES pet_breeds(pet_breed_id),
    pet_category_id INT REFERENCES pet_categories(pet_category_id)
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    age INT,
    postal_code_id INT REFERENCES postal_codes(postal_code_id),
    country_id INT REFERENCES countries(country_id)
);

CREATE TABLE IF NOT EXISTS sellers (
    seller_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    postal_code_id INT REFERENCES postal_codes(postal_code_id),
    country_id INT REFERENCES countries(country_id)
);

CREATE TABLE IF NOT EXISTS product_categories (
    category_id SERIAL PRIMARY KEY,
    product_category_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS brands (
    brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS materials (
    material_id SERIAL PRIMARY KEY,
    material_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS colors (
    color_id SERIAL PRIMARY KEY,
    color_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS sizes (
    size_id SERIAL PRIMARY KEY,
    size_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255),
    category_id INT REFERENCES product_categories(category_id),
    brand_id INT REFERENCES brands(brand_id),
    material_id INT REFERENCES materials(material_id),
    color_id INT REFERENCES colors(color_id),
    size_id INT REFERENCES sizes(size_id),
    weight FLOAT,
    description TEXT,
    rating FLOAT,
    reviews INT,
    release_date DATE,
    expiry_date DATE
);

CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(255),
    contact_name VARCHAR(255),
    email VARCHAR(255),
    supplier_phone VARCHAR(50),
    address TEXT,
    city_id INT REFERENCES cities(city_id),
    country_id INT REFERENCES countries(country_id)
);

CREATE TABLE IF NOT EXISTS stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(255),
    location VARCHAR(255),
    city_id INT REFERENCES cities(city_id),
    state_id INT REFERENCES states(state_id),
    country_id INT REFERENCES countries(country_id),
    store_phone VARCHAR(50),
    email VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    customer_pet_id INT REFERENCES pets(pet_id),
    seller_id INT REFERENCES sellers(seller_id),
    product_id INT REFERENCES products(product_id),
    store_id INT REFERENCES stores(store_id),
    supplier_id INT REFERENCES suppliers(supplier_id),
    sale_date DATE,
    quantity INT,
    total_price DECIMAL(10, 2)
);