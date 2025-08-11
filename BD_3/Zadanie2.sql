WITH BookingStats AS (
    SELECT
        c.ID_customer,
        c.name,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT r.ID_hotel) AS unique_hotels,
        SUM(r.price) AS total_spent
    FROM
        Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    GROUP BY
        c.ID_customer, c.name
),
Condition1 AS (
    SELECT
        ID_customer,
        name,
        total_bookings,
        total_spent,
        unique_hotels
    FROM BookingStats
    WHERE total_bookings > 2
      AND unique_hotels > 1
),
Condition2 AS (
    SELECT
        ID_customer,
        name,
        total_spent,
        total_bookings
    FROM BookingStats
    WHERE total_spent > 500
)
SELECT
    bs.ID_customer,
    bs.name,
    bs.total_bookings,
    bs.total_spent,
    bs.unique_hotels
FROM BookingStats bs
JOIN Condition1 c1 ON bs.ID_customer = c1.ID_customer
JOIN Condition2 c2 ON bs.ID_customer = c2.ID_customer
ORDER BY
    bs.total_spent ASC;
