{% test null_test() %}
SELECT * FROM {{ ref( 'null_model') }} WHERE nothing IS NOT NULL;
{% endtest %}

 