{%- macro clean_phone_number(column_name) -%}
CONCAT('+44',
    REGEXP_REPLACE(
        REGEXP_REPLACE(Phone,r'\+44\(0\)',''),
        r'[^0-9]',''
    )
    ) 

{% endmacro %}