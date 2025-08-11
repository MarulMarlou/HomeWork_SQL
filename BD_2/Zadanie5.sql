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
LowAvgCarsCount AS (
    SELECT 
        class,
        COUNT(*) AS low_count
    FROM CarStats
    WHERE avg_position > 3.0
    GROUP BY class
),
MaxLowCount AS (
    SELECT MAX(low_count) AS max_low_count FROM LowAvgCarsCount
),
SelectedClasses AS (
    SELECT l.class, l.low_count
    FROM LowAvgCarsCount l
    JOIN MaxLowCount m ON l.low_count = m.max_low_count
),
ClassRaceCount AS (
    SELECT 
        c.class,
        COUNT(DISTINCT r.race) AS total_class_races
    FROM Cars c
    JOIN Results r ON c.name = r.car
    GROUP BY c.class
)
SELECT 
    cs.car_name,
    cs.class,
    cs.avg_position,
    cs.race_count,
    cs.country,
    crc.total_class_races,
    sc.low_count
FROM CarStats cs
JOIN SelectedClasses sc ON cs.class = sc.class
JOIN ClassRaceCount crc ON cs.class = crc.class
ORDER BY sc.low_count DESC, cs.class ASC, cs.avg_position ASC;
