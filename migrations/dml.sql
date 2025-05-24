COPY mock_data FROM '/data/MOCK_DATA.csv' CSV HEADER; 
COPY mock_data FROM '/data/MOCK_DATA (1).csv' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (2).csv' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (3).csv' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (4).csv' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (5).csv' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (6).csv' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (7).csv' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (8).csv' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (9).csv' CSV HEADER;

INSERT INTO colors (color_name)
SELECT DISTINCT product_color
FROM mock_data
WHERE product_color IS NOT NULL;

INSERT INTO sizes (size_name)
SELECT DISTINCT product_size
FROM mock_data
WHERE product_size IS NOT NULL;

INSERT INTO brands (brand_name)
SELECT DISTINCT product_brand
FROM mock_data
WHERE product_brand IS NOT NULL;

INSERT INTO materials (material_name)
SELECT DISTINCT product_material
FROM mock_data
WHERE product_material IS NOT NULL;

INSERT INTO product_categories (product_category_name)
SELECT DISTINCT product_category
FROM mock_data
WHERE product_category IS NOT NULL;

INSERT INTO pet_types (type_name)
SELECT DISTINCT customer_pet_type
FROM mock_data
WHERE customer_pet_type IS NOT NULL;

INSERT INTO pet_breeds (breed_name)
SELECT DISTINCT customer_pet_breed
FROM mock_data
WHERE customer_pet_breed IS NOT NULL;

INSERT INTO pet_categories (category_name)
SELECT DISTINCT pet_category
FROM mock_data
WHERE pet_category IS NOT NULL;

INSERT INTO postal_codes (postal_code)
SELECT DISTINCT postal_code FROM (
    SELECT customer_postal_code AS postal_code FROM mock_data WHERE customer_postal_code IS NOT NULL
    UNION
    SELECT seller_postal_code AS postal_code FROM mock_data WHERE seller_postal_code IS NOT NULL
) AS postal_codes;

INSERT INTO countries (country_name)
SELECT DISTINCT country_name 
FROM (
    SELECT customer_country AS country_name FROM mock_data WHERE customer_country IS NOT NULL
    UNION
    SELECT seller_country AS country_name FROM mock_data WHERE seller_country IS NOT NULL
    UNION
    SELECT store_country AS country_name FROM mock_data WHERE store_country IS NOT NULL
    UNION
    SELECT supplier_country AS country_name FROM mock_data WHERE supplier_country IS NOT NULL
) AS countries;

INSERT INTO cities (city_name)
SELECT DISTINCT city_name
FROM (
    SELECT store_city AS city_name FROM mock_data WHERE store_city IS NOT NULL
    UNION
    SELECT supplier_city AS city_name FROM mock_data WHERE supplier_city IS NOT NULL
) AS cities;

INSERT INTO states (state_name)
SELECT DISTINCT store_state
FROM mock_data
WHERE store_state IS NOT NULL;

INSERT INTO pets(pet_name, pet_type_id, pet_breed_id, pet_category_id)
SELECT DISTINCT
    mock_data.customer_pet_name,
    pet_types.pet_type_id,
    pet_breeds.pet_breed_id,
    pet_categories.pet_category_id
FROM mock_data
LEFT JOIN pet_types ON mock_data.customer_pet_type = pet_types.type_name
LEFT JOIN pet_breeds ON mock_data.customer_pet_breed = pet_breeds.breed_name
LEFT JOIN pet_categories ON mock_data.pet_category = pet_categories.category_name;

INSERT INTO customers (first_name, last_name, email, age, postal_code_id, country_id)
SELECT DISTINCT
    mock_data.customer_first_name,
    mock_data.customer_last_name,
    mock_data.customer_email,
    mock_data.customer_age,
    postal_codes.postal_code_id,
    countries.country_id
FROM mock_data
LEFT JOIN postal_codes ON mock_data.customer_postal_code = postal_codes.postal_code
LEFT JOIN countries ON mock_data.customer_country = countries.country_name;

INSERT INTO sellers(first_name, last_name, email, postal_code_id, country_id)
SELECT DISTINCT
    mock_data.seller_first_name,
    mock_data.seller_last_name,
    mock_data.seller_email,
    postal_codes.postal_code_id,
    countries.country_id
FROM mock_data
LEFT JOIN postal_codes ON mock_data.seller_postal_code = postal_codes.postal_code
LEFT JOIN countries ON mock_data.seller_country = countries.country_name;

INSERT INTO products(product_name, category_id, brand_id, material_id, color_id, size_id, weight, description, rating, reviews, release_date, expiry_date)
SELECT DISTINCT
    mock_data.product_name,
    product_categories.category_id,
    brands.brand_id,
    materials.material_id,
    colors.color_id,
    sizes.size_id,
    mock_data.product_weight,
    mock_data.product_description,
    mock_data.product_rating,
    mock_data.product_reviews,
    mock_data.product_release_date,
    mock_data.product_expiry_date
FROM mock_data
LEFT JOIN product_categories ON mock_data.product_category = product_categories.product_category_name
LEFT JOIN brands ON mock_data.product_brand = brands.brand_name
LEFT JOIN materials ON mock_data.product_material = materials.material_name
LEFT JOIN colors ON mock_data.product_color = colors.color_name
LEFT JOIN sizes ON mock_data.product_size = sizes.size_name;

INSERT INTO suppliers(supplier_name, contact_name, email, supplier_phone, address, city_id, country_id)
SELECT DISTINCT
    mock_data.supplier_name,
    mock_data.supplier_contact,
    mock_data.supplier_email,
    mock_data.supplier_phone,
    mock_data.supplier_address,
    cities.city_id,
    countries.country_id
FROM mock_data
LEFT JOIN cities ON mock_data.supplier_city = cities.city_name
LEFT JOIN countries ON mock_data.supplier_country = countries.country_name;

INSERT INTO stores(store_name, location, city_id, state_id, country_id, store_phone, email)
SELECT DISTINCT
    mock_data.store_name,
    mock_data.store_location,
    cities.city_id,
    states.state_id,
    countries.country_id,
    mock_data.store_phone,
    mock_data.store_email
FROM mock_data
LEFT JOIN cities ON mock_data.store_city = cities.city_name
LEFT JOIN states ON mock_data.store_state = states.state_name
LEFT JOIN countries ON mock_data.store_country = countries.country_name;

INSERT INTO sales(customer_id, customer_pet_id, seller_id, product_id, store_id, supplier_id, sale_date, quantity, total_price)
SELECT
    customers.customer_id,
    pets.pet_id,
    sellers.seller_id,
    products.product_id,
    stores.store_id,
    suppliers.supplier_id,
    mock_data.sale_date,
    mock_data.sale_quantity,
    mock_data.sale_total_price
FROM mock_data
LEFT JOIN customers ON mock_data.customer_email = customers.email
LEFT JOIN pets ON pets.pet_name = mock_data.customer_pet_name
    AND mock_data.customer_pet_type = (SELECT type_name FROM pet_types WHERE pets.pet_type_id = pet_types.pet_type_id)
    AND mock_data.customer_pet_breed = (SELECT breed_name FROM pet_breeds WHERE pets.pet_breed_id = pet_breeds.pet_breed_id)
    AND mock_data.pet_category = (SELECT category_name FROM pet_categories WHERE pet_categories.pet_category_id = pets.pet_category_id)
LEFT JOIN sellers ON mock_data.seller_email = sellers.email
LEFT JOIN product_categories ON mock_data.product_category = product_categories.product_category_name
LEFT JOIN brands ON mock_data.product_brand = brands.brand_name
LEFT JOIN materials ON mock_data.product_material = materials.material_name
LEFT JOIN colors ON mock_data.product_color = colors.color_name
LEFT JOIN sizes ON mock_data.product_size = sizes.size_name
LEFT JOIN products ON mock_data.product_name = products.product_name
    AND products.category_id = product_categories.category_id
    AND products.brand_id = brands.brand_id
    AND products.material_id = materials.material_id
    AND products.color_id = colors.color_id
    AND products.size_id = sizes.size_id
LEFT JOIN stores ON mock_data.store_email = stores.email
LEFT JOIN suppliers ON mock_data.supplier_email = suppliers.email;