{% macro clean_customer_id(column_name) %}

    TRIM(
        INITCAP(
            CAST({{ column_name }} AS STRING)
        )
    )

{% endmacro %}