WITH RECURSIVE AllSubs AS (
    SELECT 
        e.EmployeeID AS manager_id,
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID,
        sub.EmployeeID AS subordinate_id
    FROM Employees e
    JOIN Employees sub ON sub.ManagerID = e.EmployeeID
    WHERE e.RoleID = 1 

    UNION ALL

    SELECT 
        a.manager_id,
        a.EmployeeID,
        a.Name,
        a.ManagerID,
        a.DepartmentID,
        a.RoleID,
        sub.EmployeeID AS subordinate_id
    FROM AllSubs a
    JOIN Employees sub ON sub.ManagerID = a.subordinate_id
)
, ManagerStats AS (
    SELECT 
        manager_id,
        COUNT(DISTINCT subordinate_id) AS total_subordinates
    FROM AllSubs
    GROUP BY manager_id
)
SELECT
    m.EmployeeID,
    m.Name AS employee_name,
    m.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (
        SELECT GROUP_CONCAT(p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ')
        FROM Projects p
        WHERE p.DepartmentID = m.DepartmentID
    ) AS projects,
    (
        SELECT GROUP_CONCAT(t.TaskName ORDER BY t.TaskName SEPARATOR ', ')
        FROM Tasks t
        WHERE t.AssignedTo = m.EmployeeID
    ) AS tasks,
    ms.total_subordinates
FROM Employees m
JOIN Roles r ON m.RoleID = r.RoleID
JOIN Departments d ON m.DepartmentID = d.DepartmentID
JOIN ManagerStats ms ON m.EmployeeID = ms.manager_id
ORDER BY m.Name;
