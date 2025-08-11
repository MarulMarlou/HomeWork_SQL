WITH ClassAvgPosition AS (
    SELECT 
        c.class,
        cl.country,
        AVG(r.position) AS class_avg_position
    FROM Cars c
    JOIN Results r ON c.name = r.car
    JOIN Classes cl ON c.class = cl.class
    GROUP BY c.class, cl.country
),

MinClassAvg AS (
    SELECT MIN(class_avg_position) AS min_avg_position
    FROM ClassAvgPosition
),

ClassesWithMinAvg AS (
    SELECT class, country, class_avg_position
    FROM ClassAvgPosition
    WHERE class_avg_position = (SELECT min_avg_position FROM MinClassAvg)
),

CarStats AS (
    SELECT 
        c.name AS car_name,
        c.class,
        cl.country,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count
    FROM Cars c
    JOIN Results r ON c.name = r.car
    JOIN Classes cl ON c.class = cl.class
    WHERE c.class IN (SELECT class FROM ClassesWithMinAvg)
    GROUP BY c.name, c.class, cl.country
),

ClassRaceCount AS (
    SELECT 
        c.class,
        COUNT(DISTINCT r.race) AS total_class_races
    FROM Cars c
    JOIN Results r ON c.name = r.car
    WHERE c.class IN (SELECT class FROM ClassesWithMinAvg)
    GROUP BY c.class
)

SELECT 
    cs.car_name,
    cs.avg_position,
    cs.race_count,
    cs.class,
    cs.country,
    crc.total_class_races
FROM CarStats cs
JOIN ClassRaceCount crc ON cs.class = crc.class
ORDER BY cs.avg_position ASC, cs.car_name ASC;
