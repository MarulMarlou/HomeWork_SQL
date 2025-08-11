SELECT 
    c.class,
    r.car AS car_name,
    r.avg_position,
    r.race_count
FROM 
    Classes c
JOIN 
    Cars ca ON ca.class = c.class
JOIN 
    (
        SELECT 
            car,
            AVG(position) AS avg_position,
            COUNT(*) AS race_count
        FROM Results
        GROUP BY car
    ) r ON r.car = ca.name
WHERE 
    r.avg_position = (
        SELECT 
            MIN(sub.avg_position)
        FROM 
            Cars sub_ca
        JOIN 
            (
                SELECT 
                    car,
                    AVG(position) AS avg_position
                FROM Results
                GROUP BY car
            ) sub ON sub.car = sub_ca.name
        WHERE 
            sub_ca.class = c.class
    )
ORDER BY 
    r.avg_position ASC;
