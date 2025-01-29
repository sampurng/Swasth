SET SERVEROUTPUT ON
/
CREATE OR REPLACE PROCEDURE INSERT_USER(
    P_email             USER_DETAILS.email%TYPE,
    P_first_name        USER_DETAILS.FIRST_NAME%TYPE,
    P_last_name         USER_DETAILS.LAST_NAME%TYPE,
    P_street_address    USER_DETAILS.STREET_ADDRESS%TYPE,
    P_city              USER_DETAILS.CITY%TYPE,
    P_country           USER_DETAILS.COUNTRY%TYPE,
    P_states            USER_DETAILS.STATES%TYPE,
    P_zipcode           USER_DETAILS.ZIPCODE%TYPE, 
    P_age               USER_DETAILS.AGE%TYPE, 
    P_sex               USER_DETAILS.SEX%TYPE
)
AS
     V_SEX              USER_DETAILS.SEX%TYPE;
     V_USER_ID          USER_DETAILS.USER_ID%TYPE;
BEGIN 
    V_SEX := P_SEX;
    V_USER_ID := SEQ_USER_ID.NEXTVAL;
    DBMS_OUTPUT.PUT_LINE(P_FIRST_NAME);
    INSERT INTO USER_DETAILS (user_id, first_name, last_name, email, street_address, city, country, states, zipcode, age, sex)
    VALUES(
        V_USER_ID,
        TRIM(P_first_name),
        TRIM(P_last_name),
        TRIM(UPPER(P_email)),
        TRIM(P_street_address),
        TRIM(P_city),
        TRIM(P_country),
        TRIM(P_states),
        P_zipcode,
        P_age,
        TRIM(UPPER(P_SEX))
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/


EXECUTE INSERT_USER('john.doe3@example.com    ', 'ASDASD', 'Doe', '123 Main St', 'BOSTON', 'UNITED STATES', 'MASSECHUSETS', 12345, 30, 'M')
    
