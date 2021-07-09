/* A function generating random alphanumeric strings */
create or replace function random_alnum(v_length number) return varchar2 is
    my_str varchar2(4000);
begin
    for i in 1..v_length loop
        my_str := my_str || dbms_random.string(
            case when dbms_random.value(0, 1) < 0.42 then 'l' else 'x' end, 1);
    end loop;
    return my_str;
end;
/

/* Creates a user_secret row for any user_name row which is not yet represented in user_secret */
INSERT INTO user_secret
    select user_name, random_alnum(50) from user_name where user_name not in (select user_name from user_secret)
;

drop function random_alnum
;
