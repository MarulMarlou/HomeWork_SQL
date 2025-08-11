WITH HotelCategories AS (
    SELECT 
        h.ID_hotel,
        h.name AS hotel_name,
        CASE
            WHEN AVG(r.price) < 175 THEN 'дешевый'
            WHEN AVG(r.price) <= 300 THEN 'средний'
            ELSE 'дорогой'
        END AS category
    FROM Hotel h
    JOIN Room r ON h.ID_hotel = r.ID_hotel
    GROUP BY h.ID_hotel, h.name
),
CustomerHotelCategories AS (
    SELECT 
        c.ID_customer,
        c.name AS customer_name,
        hc.category,
        hc.hotel_name
    FROM Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN HotelCategories hc ON hc.ID_hotel = r.ID_hotel
)
SELECT
    chc.ID_customer,
    chc.customer_name AS name,
    CASE 
        WHEN SUM(CASE WHEN chc.category = 'дорогой' THEN 1 ELSE 0 END) > 0 THEN 'дорогой'
        WHEN SUM(CASE WHEN chc.category = 'средний' THEN 1 ELSE 0 END) > 0 THEN 'средний'
        ELSE 'дешевый'
    END AS preferred_hotel_type,
    GROUP_CONCAT(DISTINCT chc.hotel_name ORDER BY chc.hotel_name SEPARATOR ', ') AS visited_hotels
FROM CustomerHotelCategories chc
GROUP BY chc.ID_customer, chc.customer_name
ORDER BY FIELD(
    CASE 
        WHEN SUM(CASE WHEN chc.category = 'дорогой' THEN 1 ELSE 0 END) > 0 THEN 'дорогой'
        WHEN SUM(CASE WHEN chc.category = 'средний' THEN 1 ELSE 0 END) > 0 THEN 'средний'
        ELSE 'дешевый'
    END,
    'дешевый', 'средний', 'дорогой'
);
