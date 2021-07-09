/* Creates a user_secret row for any user_name row which is not yet represented in user_secret
   password_random() is limited to 30 character, so concating 2 password_random() calls
 */
INSERT INTO user_secret
    select user_name, password_random(25) + password_random(25) from user_name where user_name not in (select user_name from user_secret)
go

