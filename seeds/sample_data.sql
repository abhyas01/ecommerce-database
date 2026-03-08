INSERT INTO products (name, price, description) VALUES
    ('Laptop',      999.99, 'High-performance laptop'),
    ('Mouse',        29.99, 'Wireless mouse'),
    ('Keyboard',     79.99, 'Mechanical keyboard'),
    ('Monitor',     299.99, '27-inch LED monitor'),
    ('Headphones',  149.99, 'Noise-cancelling headphones')
ON CONFLICT DO NOTHING;