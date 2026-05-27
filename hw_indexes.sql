-- Задание 1
EXPLAIN ANALYZE
SELECT *
FROM users
WHERE email = 'student5000@mail.com';

CREATE INDEX idx_users_email
ON users(email);

EXPLAIN ANALYZE
SELECT *
FROM users
WHERE email = 'student5000@mail.com';

-- Ответ:
-- До индекса: скорее всего Seq Scan.
-- После индекса: Index Scan или Bitmap Index Scan.
-- Индекс ускоряет запрос, потому что PostgreSQL не читает всю таблицу,
-- а быстро находит строку по email.


-- Задание 2
EXPLAIN ANALYZE
SELECT *
FROM attemps
WHERE user_id = 25000;

CREATE INDEX idx_attemps_user_id
ON attemps(user_id);

EXPLAIN ANALYZE
SELECT *
FROM attemps
WHERE user_id = 25000;

-- Ответ:
-- Индекс создается на user_id, потому что именно по нему идет фильтрация.
-- Без индекса PostgreSQL может проверять все строки таблицы.
-- С индексом он быстрее находит попытки конкретного пользователя.
-- Индексы часто создают на внешних ключах, потому что по ним часто делают JOIN,
-- WHERE и поиск связанных записей.


-- Задание 3
EXPLAIN ANALYZE
SELECT *
FROM attemps
WHERE user_id = 25000
ORDER BY created_at DESC;

CREATE INDEX idx_attemps_user_created_at
ON attemps(user_id, created_at DESC);

EXPLAIN ANALYZE
SELECT *
FROM attemps
WHERE user_id = 25000
ORDER BY created_at DESC;

-- Ответ:
-- Обычный индекс на user_id помогает только найти строки пользователя.
-- Но сортировку по created_at PostgreSQL может делать отдельно.
-- Составной индекс (user_id, created_at DESC) помогает и отфильтровать,
-- и сразу получить данные в нужном порядке.


-- Задание 4
EXPLAIN ANALYZE
SELECT *
FROM attemps
WHERE status = 'in_progress';

CREATE INDEX idx_attemps_in_progress
ON attemps(status)
WHERE status = 'in_progress';

EXPLAIN ANALYZE
SELECT *
FROM attemps
WHERE status = 'in_progress';

-- Ответ:
-- Обычный индекс на status может быть неэффективным,
-- если большинство строк имеют одинаковый статус finished.
-- Partial index хранит только строки status = 'in_progress',
-- поэтому он меньше и быстрее.
-- Partial index используют, когда часто ищут маленькую часть таблицы
-- по конкретному условию.


-- Задание 5
EXPLAIN ANALYZE
SELECT 
    u.full_name,
    s.title AS subject_title,
    a.score,
    a.created_at
FROM attemps a
JOIN users u ON u.id = a.user_id
JOIN tests t ON t.id = a.test_id
JOIN subjects s ON s.id = t.subject_id
WHERE s.title = 'Python'
ORDER BY a.score DESC;

CREATE INDEX idx_subjects_title
ON subjects(title);

CREATE INDEX idx_tests_subject_id
ON tests(subject_id);

CREATE INDEX idx_attemps_test_id
ON attemps(test_id);

CREATE INDEX idx_attemps_score_desc
ON attemps(score DESC);

CREATE INDEX idx_attemps_test_score
ON attemps(test_id, score DESC);

EXPLAIN ANALYZE
SELECT 
    u.full_name,
    s.title AS subject_title,
    a.score,
    a.created_at
FROM attemps a
JOIN users u ON u.id = a.user_id
JOIN tests t ON t.id = a.test_id
JOIN subjects s ON s.id = t.subject_id
WHERE s.title = 'Python'
ORDER BY a.score DESC;

-- Ответ:
-- idx_subjects_title ускоряет поиск предмета Python.
-- idx_tests_subject_id ускоряет связь tests с subjects.
-- idx_attemps_test_id ускоряет поиск попыток по test_id.
-- idx_attemps_score_desc помогает сортировке по score DESC.
-- idx_attemps_test_score помогает одновременно искать попытки по тесту
-- и сортировать их по score.
