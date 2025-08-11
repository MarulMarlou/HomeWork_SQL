SELECT
    c.class,
    r.car,
    r.avg_position,
    r.race_count,
    cl.country
FROM
    (
        SELECT
            car,
            AVG(position) AS avg_position,
            COUNT(*) AS race_count
        FROM Results
        GROUP BY car
    ) r
JOIN Cars c ON r.car = c.name
JOIN Classes cl ON c.class = cl.class
WHERE
    r.avg_position = (
        SELECT MIN(avg_position)
        FROM (
            SELECT AVG(position) AS avg_position
            FROM Results
            GROUP BY car
        ) sub
    )
ORDER BY r.car
LIMIT 1;
