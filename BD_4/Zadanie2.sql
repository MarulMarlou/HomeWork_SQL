WITH RECURSIVE EmployeeHierarchy AS (
    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    WHERE e.ManagerID = 1

    UNION ALL

    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh 
        ON e.ManagerID = eh.EmployeeID
)
SELECT
    eh.EmployeeID,
    eh.Name AS employee_name,
    eh.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (
        SELECT GROUP_CONCAT(p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ')
        FROM Projects p
        WHERE p.DepartmentID = eh.DepartmentID
    ) AS projects,
    (
        SELECT GROUP_CONCAT(t.TaskName ORDER BY t.TaskName SEPARATOR ', ')
        FROM Tasks t
        WHERE t.AssignedTo = eh.EmployeeID
    ) AS tasks,
    (
        SELECT COUNT(*)
        FROM Tasks t
        WHERE t.AssignedTo = eh.EmployeeID
    ) AS task_count,
    (
        SELECT COUNT(*)
        FROM Employees sub
        WHERE sub.ManagerID = eh.EmployeeID
    ) AS direct_subordinates_count
FROM EmployeeHierarchy eh
LEFT JOIN Departments d ON eh.DepartmentID = d.DepartmentID
LEFT JOIN Roles r ON eh.RoleID = r.RoleID
ORDER BY eh.Name;
