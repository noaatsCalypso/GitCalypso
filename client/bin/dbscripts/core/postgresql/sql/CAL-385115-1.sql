/* A function generating random alphanumeric strings */
CREATE OR REPLACE FUNCTION RANDOM_ALNUM(
        IN string_length INTEGER,
        IN possible_chars TEXT DEFAULT '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
    )
RETURNS text LANGUAGE plpgsql
AS $BODY$
DECLARE
    output TEXT = '';
    i INT4;
    pos INT4;
BEGIN
    FOR i IN 1..string_length LOOP
        pos := 1 + CAST( random() * ( LENGTH(possible_chars) - 1) AS INT4 );
        output := output || substr(possible_chars, pos, 1);
    END LOOP;
    RETURN output;
END;
$BODY$
;

/* Creates a user_secret row for any user_name row which is not yet represented in user_secret */
INSERT INTO user_secret
    select user_name, RANDOM_ALNUM(50) from user_name where user_name not in (select user_name from user_secret)
;

DROP FUNCTION RANDOM_ALNUM
;
