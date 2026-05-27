-- =========================
-- TASK 1
-- =========================

SELECT
    s.id AS session_id,
    s.start_ts,
    h.name AS hall_name,
    m.title AS movie_title,
    m.genre,
    s.base_price
FROM sessions s
JOIN halls h ON s.hall_id = h.id
JOIN movies m ON s.movie_id = m.id;


-- =========================
-- TASK 2
-- =========================

SELECT
    m.id AS movie_id,
    m.title,
    COUNT(s.id) AS sessions_count
FROM movies m
LEFT JOIN sessions s ON m.id = s.movie_id
GROUP BY m.id, m.title;


-- =========================
-- TASK 3
-- =========================

SELECT
    h.id AS hall_id,
    h.name AS hall_name,
    COUNT(s.id) AS sessions_count
FROM halls h
LEFT JOIN sessions s ON h.id = s.hall_id
GROUP BY h.id, h.name;


-- =========================
-- TASK 4
-- =========================

SELECT
    v.id AS viewer_id,
    v.full_name,
    COUNT(CASE WHEN t.status = 'paid' THEN 1 END) AS paid_tickets_count
FROM viewers v
LEFT JOIN tickets t ON v.id = t.viewer_id
GROUP BY v.id, v.full_name;


-- =========================
-- TASK 5
-- =========================

SELECT
    s.id AS session_id,
    COUNT(CASE WHEN t.status = 'paid' THEN 1 END) AS paid_count,
    COUNT(CASE WHEN t.status = 'reserved' THEN 1 END) AS reserved_count,
    COUNT(CASE WHEN t.status = 'refunded' THEN 1 END) AS refunded_count
FROM sessions s
LEFT JOIN tickets t ON s.id = t.session_id
GROUP BY s.id;


-- =========================
-- TASK 6
-- =========================

SELECT
    s.id AS session_id,
    s.start_ts,
    m.title AS movie_title
FROM sessions s
JOIN movies m ON s.movie_id = m.id
LEFT JOIN tickets t
    ON s.id = t.session_id
    AND t.status = 'paid'
GROUP BY s.id, s.start_ts, m.title
HAVING COUNT(t.id) = 0;


-- =========================
-- TASK 7
-- =========================

SELECT
    s.id AS session_id,
    s.start_ts,
    SUM(t.price_paid) AS revenue
FROM sessions s
JOIN tickets t ON s.id = t.session_id
WHERE t.status = 'paid'
GROUP BY s.id, s.start_ts;


-- =========================
-- TASK 8
-- =========================

SELECT
    'ticket_without_session' AS kind,
    t.id AS id,
    CONCAT('ticket session_id=', t.session_id) AS info
FROM tickets t
FULL OUTER JOIN sessions s ON t.session_id = s.id
WHERE s.id IS NULL

UNION

SELECT
    'session_without_tickets' AS kind,
    s.id AS id,
    CONCAT('session ', s.start_ts) AS info
FROM sessions s
FULL OUTER JOIN tickets t ON s.id = t.session_id
WHERE t.id IS NULL;


-- =========================
-- TASK 9
-- =========================

SELECT
    m.id AS movie_id,
    m.title,
    ROUND(AVG(r.rating), 2) AS avg_rating
FROM movies m
LEFT JOIN reviews r ON m.id = r.movie_id
GROUP BY m.id, m.title;


-- =========================
-- TASK 10
-- =========================

SELECT
    v.id AS viewer_id,
    v.full_name,
    MAX(t.purchased_at) AS last_purchase_at,
    MAX(t.session_id) AS last_session_id
FROM viewers v
LEFT JOIN tickets t
    ON v.id = t.viewer_id
    AND t.status = 'paid'
WHERE v.city = 'Almaty'
GROUP BY v.id, v.full_name;


-- =========================
-- TASK 11
-- =========================

SELECT
    m.title,
    SUM(t.price_paid) AS revenue
FROM movies m
JOIN sessions s ON m.id = s.movie_id
JOIN tickets t ON s.id = t.session_id
WHERE t.status = 'paid'
GROUP BY m.title
ORDER BY revenue DESC
LIMIT 3;


-- =========================
-- TASK 12
-- =========================

SELECT
    m.title,
    COUNT(t.id) AS paid_count
FROM movies m
JOIN sessions s ON m.id = s.movie_id
JOIN tickets t ON s.id = t.session_id
WHERE t.status = 'paid'
GROUP BY m.title
ORDER BY paid_count DESC
LIMIT 3;


-- =========================
-- TASK 13
-- =========================

SELECT
    m.title,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(r.id) AS reviews_count
FROM movies m
JOIN reviews r ON m.id = r.movie_id
GROUP BY m.title
HAVING AVG(r.rating) >= 8
   AND COUNT(r.id) >= 2;


-- =========================
-- TASK 14
-- =========================

SELECT
    h.name AS hall_name,
    COUNT(t.id) AS paid_count
FROM halls h
JOIN sessions s ON h.id = s.hall_id
JOIN tickets t ON s.id = t.session_id
WHERE t.status = 'paid'
GROUP BY h.name
HAVING COUNT(t.id) >= 4;


-- =========================
-- TASK 15
-- =========================

SELECT
    v.city,
    COUNT(t.id) AS paid_tickets_count,
    SUM(t.price_paid) AS revenue
FROM viewers v
JOIN tickets t ON v.id = t.viewer_id
WHERE t.status = 'paid'
GROUP BY v.city;


-- =========================
-- TASK 16
-- =========================

SELECT
    s.id AS session_id,
    SUM(t.price_paid) AS revenue,
    (
        SELECT AVG(session_revenue)
        FROM (
            SELECT SUM(t2.price_paid) AS session_revenue
            FROM tickets t2
            WHERE t2.status = 'paid'
            GROUP BY t2.session_id
        ) q
    ) AS avg_revenue_all_sessions
FROM sessions s
JOIN tickets t ON s.id = t.session_id
WHERE t.status = 'paid'
GROUP BY s.id
HAVING SUM(t.price_paid) >
(
    SELECT AVG(session_revenue)
    FROM (
        SELECT SUM(t2.price_paid) AS session_revenue
        FROM tickets t2
        WHERE t2.status = 'paid'
        GROUP BY t2.session_id
    ) q
);


-- =========================
-- TASK 17
-- =========================

SELECT
    genre,
    COUNT(*) AS movies_count,
    ROUND(AVG(duration_min), 2) AS avg_duration,
    MAX(age_rating) AS max_age_rating
FROM movies
GROUP BY genre;


-- =========================
-- TASK 18
-- =========================

SELECT
    title,
    duration_min,
    (SELECT AVG(duration_min) FROM movies) AS avg_duration_all
FROM movies
WHERE duration_min >
(
    SELECT AVG(duration_min)
    FROM movies
);


-- =========================
-- TASK 19
-- =========================

SELECT
    id AS ticket_id,
    price_paid,
    CASE
        WHEN price_paid < 1800 THEN 'cheap'
        WHEN price_paid BETWEEN 1800 AND 2499 THEN 'standard'
        ELSE 'premium'
    END AS price_bucket
FROM tickets;


-- =========================
-- TASK 20
-- =========================

SELECT
    s.id AS session_id,
    h.capacity AS hall_capacity,
    COUNT(CASE WHEN t.status = 'paid' THEN 1 END) AS paid_count,
    CASE
        WHEN COUNT(CASE WHEN t.status = 'paid' THEN 1 END) = 0 THEN 'empty'
        WHEN COUNT(CASE WHEN t.status = 'paid' THEN 1 END) <= h.capacity * 0.5 THEN 'low'
        WHEN COUNT(CASE WHEN t.status = 'paid' THEN 1 END) <= h.capacity * 0.8 THEN 'mid'
        ELSE 'high'
    END AS fill_status
FROM sessions s
JOIN halls h ON s.hall_id = h.id
LEFT JOIN tickets t ON s.id = t.session_id
GROUP BY s.id, h.capacity;


-- =========================
-- TASK 21
-- =========================

SELECT
    v.id AS viewer_id,
    v.full_name,
    COUNT(CASE WHEN t.status = 'paid' THEN 1 END) AS paid_count,
    CASE
        WHEN COUNT(CASE WHEN t.status = 'paid' THEN 1 END) = 0 THEN 'new'
        WHEN COUNT(CASE WHEN t.status = 'paid' THEN 1 END) BETWEEN 1 AND 2 THEN 'regular'
        WHEN COUNT(CASE WHEN t.status = 'paid' THEN 1 END) BETWEEN 3 AND 5 THEN 'loyal'
        ELSE 'vip'
    END AS level
FROM viewers v
LEFT JOIN tickets t ON v.id = t.viewer_id
GROUP BY v.id, v.full_name;


-- =========================
-- TASK 22
-- =========================

SELECT
    m.title,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    CASE
        WHEN AVG(r.rating) IS NULL THEN 'no_data'
        WHEN AVG(r.rating) < 7 THEN 'risk'
        WHEN AVG(r.rating) BETWEEN 7 AND 8.4 THEN 'ok'
        ELSE 'hit'
    END AS label
FROM movies m
LEFT JOIN reviews r ON m.id = r.movie_id
GROUP BY m.title;


-- =========================
-- TASK 23
-- =========================

SELECT
    t.id AS ticket_id,
    v.full_name,
    m.title AS movie_title,
    2026 - v.birth_year AS viewer_age,
    m.age_rating,
    CASE
        WHEN (2026 - v.birth_year) < m.age_rating THEN 'underage'
        ELSE 'ok'
    END AS check_result
FROM tickets t
JOIN viewers v ON t.viewer_id = v.id
JOIN sessions s ON t.session_id = s.id
JOIN movies m ON s.movie_id = m.id;


-- =========================
-- TASK 24
-- =========================

SELECT
    m.title,
    ROUND(AVG(t.price_paid), 2) AS avg_paid_price,
    CASE
        WHEN AVG(t.price_paid) < 2000 THEN 'budget'
        WHEN AVG(t.price_paid) BETWEEN 2000 AND 2999 THEN 'middle'
        ELSE 'expensive'
    END AS class
FROM movies m
JOIN sessions s ON m.id = s.movie_id
JOIN tickets t ON s.id = t.session_id
WHERE t.status = 'paid'
GROUP BY m.title;


-- =========================
-- TASK 25
-- =========================

SELECT
    v.id AS viewer_id,
    v.full_name
FROM viewers v
WHERE EXISTS (
    SELECT 1
    FROM tickets t
    JOIN sessions s ON t.session_id = s.id
    JOIN movies m ON s.movie_id = m.id
    WHERE t.viewer_id = v.id
      AND t.status = 'paid'
      AND m.genre = 'Sci-Fi'
);


-- =========================
-- TASK 26
-- =========================

SELECT
    m.id AS movie_id,
    m.title
FROM movies m
WHERE NOT EXISTS (
    SELECT 1
    FROM reviews r
    WHERE r.movie_id = m.id
);


-- =========================
-- TASK 27
-- =========================

SELECT
    m.title
FROM movies m
JOIN sessions s ON m.id = s.movie_id
JOIN tickets t ON s.id = t.session_id
GROUP BY m.title
HAVING COUNT(CASE WHEN t.status = 'paid' THEN 1 END) = 0
   AND COUNT(t.id) > 0;


-- =========================
-- TASK 28
-- =========================

SELECT
    v.id AS viewer_id,
    v.full_name,
    ROUND(AVG(r.rating), 2) AS viewer_avg_rating,
    (SELECT ROUND(AVG(rating), 2) FROM reviews) AS global_avg_rating,
    ROUND(
        AVG(r.rating) - (SELECT AVG(rating) FROM reviews),
        2
    ) AS diff
FROM viewers v
LEFT JOIN reviews r ON v.id = r.viewer_id
GROUP BY v.id, v.full_name;


-- =========================
-- TASK 29
-- =========================

SELECT
    v.id AS viewer_id,
    v.full_name,
    COUNT(DISTINCT m.genre) AS genres_count
FROM viewers v
JOIN tickets t ON v.id = t.viewer_id
JOIN sessions s ON t.session_id = s.id
JOIN movies m ON s.movie_id = m.id
WHERE t.status = 'paid'
GROUP BY v.id, v.full_name
HAVING COUNT(DISTINCT m.genre) >= 2;


-- =========================
-- TASK 30
-- =========================

WITH city_movie AS (
    SELECT
        v.city,
        m.title,
        COUNT(t.id) AS paid_count
    FROM viewers v
    JOIN tickets t ON v.id = t.viewer_id
    JOIN sessions s ON t.session_id = s.id
    JOIN movies m ON s.movie_id = m.id
    WHERE t.status = 'paid'
    GROUP BY v.city, m.title
)

SELECT
    cm.city,
    cm.title,
    cm.paid_count
FROM city_movie cm
WHERE cm.paid_count = (
    SELECT MAX(cm2.paid_count)
    FROM city_movie cm2
    WHERE cm2.city = cm.city
);
