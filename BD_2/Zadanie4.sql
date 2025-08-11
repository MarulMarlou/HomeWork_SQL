WITH CarStats AS (
    SELECT 
        c.name AS car_name,
        c.class,
        cl.country,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count
    FROM Cars c
    JOIN Results r ON c.name = r.car
    JOIN Classes cl ON c.class = cl.class
    GROUP BY c.name, c.class, cl.country
),
ClassStats AS (
    SELECT
        cs.class,
        AVG(cs.avg_position) AS class_avg_position,
        COUNT(*) AS cars_in_class
    FROM CarStats cs
    GROUP BY cs.class
)
SELECT
    cs.car_name,
    cs.class,
    cs.avg_position,
    cs.race_count,
    cs.country
FROM CarStats cs
JOIN ClassStats cls ON cs.class = cls.class
WHERE cls.cars_in_class >= 2
  AND cs.avg_position < cls.class_avg_position
ORDER BY cs.class ASC, cs.avg_position ASC;
