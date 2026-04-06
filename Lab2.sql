--- Câu 1: Liệt kê last_name và salary của nhân viên có salary > 12.000$
SELECT last_name, salary
FROM employees
WHERE salary > 12000;

--- Câu 2: Nhân viên có salary < 5.000$ HOẶC > 12.000$
--Cách 1 - Dùng OR:
SELECT last_name, salary
FROM employees
WHERE salary < 5000 OR salary > 12000;
--Cách 2 - Dùng NOT BETWEEN (tương đương):
SELECT last_name, salary
FROM employees
WHERE salary NOT BETWEEN 5000 AND 12000;

---Câu 3: last_name, job_id, hire_date từ 20/02/1998 đến 01/05/1998, sắp tăng dần theo ngày
SELECT last_name, job_id, hire_date
FROM employees
WHERE hire_date BETWEEN TO_DATE('20/02/1998', 'DD/MM/YYYY') 
                  AND TO_DATE('01/05/1998', 'DD/MM/YYYY')
ORDER BY hire_date ASC;


---Câu 4: Nhân viên phòng 20 và 50: last_name, department_id, sắp xếp theo tên
SELECT last_name, department_id
FROM employees
WHERE department_id IN (20, 50)
ORDER BY last_name ASC;

---Câu 5: Nhân viên được tuyển trong năm 1994
--Cách 1: TO_CHAR (khuyên dùng):
SELECT last_name, hire_date
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY') = '1994';
--Cách 2: Dùng BETWEEN
SELECT last_name, hire_date
FROM employees
WHERE hire_date BETWEEN TO_DATE('01/01/1994', 'DD/MM/YYYY')
                  AND TO_DATE('31/12/1994', 'DD/MM/YYYY');
                  
--- Câu 6: Nhân viên không có người quản lý (manager_id là NULL)
SELECT last_name, job_id
FROM employees
WHERE manager_id IS NULL;
 
 
--- Câu 7: Nhân viên được hưởng hoa hồng (commission_pct), sắp xếp giảm dần theo lương và hoa hồng
SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC, commission_pct DESC;

---Câu 8: Nhân viên có ký tự thứ 3 trong last_name là 'a'
SELECT last_name
FROM employees
WHERE last_name LIKE 'a&'

---Câu 9: Nhân viên mà last_name chứa cả chữ 'a' và chữ 'e'
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%'
AND last_name LIKE '%e%';


---Câu 10: Nhân viên là 'Sales Representative' HOẶC 'Stock Clerk' và lương khác 2.500$, 3.500$, 7.000$
SELECT last_name, job_id, salary
FROM employees
WHERE job_id IN ('SA_REP', 'ST_CLERK')
  AND salary NOT IN (2500, 3500, 7000);
  
---Câu 11: Tăng lương 15% (làm tròn hàng đơn vị), đặt alias 'New Salary'
SELECT employee_id, last_name, 
       ROUND(salary * 1.15, 0) AS "New Salary"
FROM employees;

---Câu 12: Tên (viết hoa chữ đầu), chiều dài tên, lọc tên bắt đầu bằng J, A, L, M
SELECT INITCAP(last_name) AS "Ten Nhan Vien", 
       LENGTH(last_name) AS "Chieu Dai"
FROM employees
WHERE SUBSTR(UPPER(last_name), 1, 1) IN ('J','A','L','M')
ORDER BY last_name ASC;

--- Câu 13: Thời gian làm việc tính theo tháng (làm tròn xuống)
SELECT last_name, 
       TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)) AS "So Thang Lam Viec"
FROM employees
ORDER BY "So Thang Lam Viec" ASC;

--- Câu 14: Nối chuỗi định dạng lương
SELECT last_name || ' earns ' 
       || TO_CHAR(salary, '$99,999') || ' monthly but wants ' 
       || TO_CHAR(salary * 3, '$99,999') AS "Dream Salaries"
FROM employees;

---Câu 15: Hiển thị mức hoa hồng, nếu NULL thì hiện 'No commission'
--Cách 1: Dùng CASE (an toàn nhất):
SELECT last_name,
    CASE WHEN commission_pct IS NULL THEN  'No commission';
        ELSE TO_CHAR(commission_pct)
    END AS "Commission";
FROM employees;
--Cách 2: Dùng NVL kết hợp TO_CHAR:
SELECT last_name, 
       NVL(TO_CHAR(commission_pct), 'No commission') AS "Commission"
FROM employees;;

--Câu 16: Phân loại GRADE dựa trên job_id
SELECT job_id, 
       CASE job_id
            WHEN 'AD_PRES'  THEN 'A'
            WHEN 'ST_MAN'   THEN 'B'
            WHEN 'IT_PROG'  THEN 'C'
            WHEN 'SA_REP'   THEN 'D'
            WHEN 'ST_CLERK' THEN 'E'
            ELSE '0' 
       END AS "GRADE"
FROM employees;

---Câu 17: Nhân viên làm việc tại thành phố Toronto
SELECT e.last_name, e.department_id, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l   ON d.location_id = l.location_id
WHERE UPPER(l.city) = 'TORONTO';

---Câu 18: Tên nhân viên và tên quản lý (Self Join)
SELECT 
    e.employee_id AS "Ma NV",
    e.last_name AS "Ten NV",
    m.employee_id AS "Ma Quan Ly",
    m.last_name AS "Ten Quan Ly"
FROM employees e, employees m
WHERE e.manager_id = m.employee_id;

---Câu 19: Danh sách nhân viên làm việc cùng phòng ban
SELECT e1.last_name AS "NV 1", 
       e2.last_name AS "NV 2", 
       e1.department_id
FROM employees e1
JOIN employees e2 ON e1.department_id = e2.department_id
WHERE e1.employee_id < e2.employee_id
ORDER BY e1.department_id;


---Câu 20: Nhân viên vào làm sau 'Davies'
SELECT last_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date 
                   FROM employees 
                   WHERE last_name = 'Davies');
                   
---Câu 21: Nhân viên được tuyển TRƯỚC người quản lý của họ
SELECT 
    e.last_name AS "Nhan Vien",
    e.hire_date AS "Ngay Vao",
    m.last_name AS "Quan Ly",
    m.hire_date AS "Quan Ly Vao"
FROM employees e
INNER JOIN employees m ON e.manager_id = m.employee_id
WHERE e.hire_date < m.hire_date;

--Câu 22: Lương thấp nhất, cao nhất, trung bình, tổng lương của từng loại công việc
SELECT 
    job_id,
    MIN(salary) AS "Luong Thap Nhat",
    MAX(salary) AS "Luong Cao Nhat",
    ROUND(AVG(salary), 2) AS "Luong Trung Binh",
    SUM(salary) AS "Tong Luong"
FROM employees
GROUP BY job_id
ORDER BY job_id;

---Câu 23: Mã phòng, tên phòng, số lượng nhân viên từng phòng + thống kê tuyển dụng theo năm 1995–1998
-- Phần A: Số lượng nhân viên từng phòng
SELECT 
    d.department_id,
    d.department_name,
    COUNT(e.employee_id) AS "So Nhan Vien"
FROM departments d 
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_id;
--Phần B: Thống kê tuyển dụng theo từng năm
SELECT 
    COUNT(*) AS "Tong NV",
    SUM(CASE WHEN TO_CHAR(hire_date, 'YYYY') = '1995' THEN 1 ELSE 0 END) AS "Nam 1995",
    SUM(CASE WHEN TO_CHAR(hire_date, 'YYYY') = '1996' THEN 1 ELSE 0 END) AS "Nam 1996",
    SUM(CASE WHEN TO_CHAR(hire_date, 'YYYY') = '1997' THEN 1 ELSE 0 END) AS "Nam 1997",
    SUM(CASE WHEN TO_CHAR(hire_date, 'YYYY') = '1998' THEN 1 ELSE 0 END) AS "Nam 1998"
FROM employees;

---Câu 25: Tên và hire_date của nhân viên làm việc cùng phòng với
SELECT last_name, hire_date
FROM employees
WHERE department_id = (SELECT department_id 
                        FROM employees 
                        WHERE last_name = 'Zlotkey')
  AND last_name <> 'Zlotkey';
  
---Câu 26: Tên, mã phòng, mã công việc của nhân viên thuộc phòng ở location_id = 1700
SELECT last_name, department_id, job_id
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM departments
                        WHERE location_id = 1700);
---Câu 27: Danh sách nhân viên có người quản lý tên 'King'
SELECT last_name, manager_id
FROM employees
WHERE manager_id IN (SELECT employee_id
                     FROM employees
                     WHERE last_name ='King');
---Câu 28: Nhân viên có lương > trung bình VÀ cùng phòng với nhân viên có tên kết thúc bằng 'n'
SELECT last_name, salary, department_id
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
AND department_id IN (SELECT department_id 
                        FROM employees 
                        WHERE last_name LIKE '%n');
---Câu 29: Mã và tên phòng ban có ít hơn 3 nhân viên
--Cách 1: Correlated Subquery 
SELECT department_id, department_name
FROM departments d
WHERE (SELECT COUNT(*) 
       FROM employees e 
       WHERE e.department_id = d.department_id) < 3
ORDER BY department_id;
--Cách 2: GROUP BY / HAVING
SELECT d.department_id, d.department_name, COUNT(e.employee_id) AS "So NV"
FROM departments d 
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(e.employee_id) < 3
ORDER BY d.department_id;

---Câu 30: Phòng ban đông nhân viên nhất và ít nhân viên nhất
SELECT department_id, COUNT(*) AS "So Nhan Vien", 'Dong nhat' AS "Loai"
FROM employees
GROUP BY department_id
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM (SELECT COUNT(*) FROM employees GROUP BY department_id))
UNION ALL
SELECT department_id, COUNT(*), 'It nhat'
FROM employees
GROUP BY department_id
HAVING COUNT(*) = (SELECT MIN(COUNT(*)) FROM (SELECT COUNT(*) FROM employees GROUP BY department_id));

---Câu 31: Nhân viên được tuyển vào thứ có số lượng tuyển dụng đông nhất
SELECT last_name, hire_date 
FROM employees 
WHERE TO_CHAR(hire_date, 'Day') = (
    SELECT TO_CHAR(hire_date, 'Day') 
    FROM employees 
    GROUP BY TO_CHAR(hire_date, 'Day') 
    ORDER BY COUNT(*) DESC 
    FETCH FIRST 1 ROWS ONLY
);
---Câu 32: Top 3 nhân viên có lương cao nhất
SELECT last_name, salary
FROM (
    SELECT last_name, salary
    FROM employees
    ORDER BY salary DESC
)
WHERE ROWNUM <= 3;

---Câu 33: Nhân viên làm việc tại tiểu bang 'California'
SELECT e.last_name, e.department_id
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
WHERE UPPER(l.state_province) = 'CALIFORNIA';

---Câu 34: Cập nhật họ của nhân viên ID = 3 thành 'Drexler'
-- Kiem tra truoc
SELECT employee_id, last_name FROM employees WHERE employee_id = 3;

-- Cap nhat
UPDATE employees
SET last_name = 'Drexler'
WHERE employee_id = 3;

COMMIT;


-- Xac nhan sau khi cap nhat
SELECT employee_id, last_name FROM employees WHERE employee_id = 3;

---Câu 35: Nhân viên có lương thấp hơn mức trung bình của phòng ban mình
SELECT e1.last_name, e1.salary, e1.department_id
FROM employees e1
WHERE e1.salary < (SELECT AVG(e2.salary)
                   FROM employees e2
                   WHERE e2.department_id = e1.department_id)
ORDER BY e1.department_id;

---Câu 36: Tăng 100$ cho nhân viên có lương < 900$
-- Kiem tra truoc: xem ai bi anh huong
SELECT employee_id, last_name, salary
FROM employees
WHERE salary < 900;

-- Tang luong
UPDATE employees
SET salary = salary + 100
WHERE salary < 900;

COMMIT;

--- Câu 37: Xóa phòng ban có ID = 500 (Xử lý ràng buộc FK)
-- Kiem tra: co nhan vien trong phong 500 khong?
SELECT COUNT(*) FROM employees WHERE department_id = 500;
-- Truong hop 1: Phong trong (khong co nhan vien)
DELETE FROM departments WHERE department_id = 500;
COMMIT;

-- Truong hop 2: Phong co nhan vien -&gt; phai xu ly truoc
UPDATE employees SET department_id = NULL WHERE department_id = 500;
DELETE FROM departments WHERE department_id = 500;
COMMIT;

--Câu 38: Xóa các phòng ban chưa có nhân viên nào
Cách 1: NOT IN (chú ý NULL):
-- Kiem tra truoc
SELECT department_id, department_name FROM departments
WHERE department_id NOT IN (
SELECT DISTINCT department_id FROM employees
WHERE department_id IS NOT NULL
);

-- Thuc hien xoa
DELETE FROM departments
WHERE department_id NOT IN (
SELECT DISTINCT department_id FROM employees
WHERE department_id IS NOT NULL
);
COMMIT;

--Cách 2: NOT EXISTS (an toàn hơn với NULL):
DELETE FROM departments d
WHERE NOT EXISTS (
SELECT 1 FROM employees e
WHERE e.department_id = d.department_id
);
COMMIT;


