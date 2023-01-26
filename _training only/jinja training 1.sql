--returns (0,...,9)
{% for i in range(10) %}

    select {{ i }} as number {% if not loop.last %} union all {% endif %}

{% endfor %};

------------------------------------------------------------
--returns (1,...,10)
{% for i in range(10) %}

    select {{ i }}+1 as number {% if not loop.last %} union all {% endif %}   

{% endfor %};

------------------------------------------------------------
--set variables
    --(types: simple variables [], lists [index], dictionaries [keys])
{% set my_cool_string = 'wow! cool!' %}

{{ my_cool_string }}

------------------------------------------------------------
{# comment here

{% set my_cool_string = 'wow! cool!' %}
{% set my_second_cool_string = 'this is Jinja!' %}
{% set my_cool_number = 100 %}

{{ my_cool_string }} {{ my_second_cool_string }} I want to write Jinja for {{ my_cool_number }} years!

#}

------------------------------------------------------------
{% set my_animals = ['lemur', 'wolf', 'panther', 'tardigrade'] %}

{{ my_animals[0] }}
{{ my_animals[1] }}
{{ my_animals[2] }}
{{ my_animals[3] }}

------------------------------------------------------------
{% set my_animals = ['lemur', 'wolf', 'panther', 'tardigrade'] %}

{{ my_animals[0] }}

{% for animal in my_animals %}

  My favorite animal is the {{ animal }}

{% endfor %}

------------------------------------------------------------
{% set temperature = 75 %}

{% if temperature < 65 %}
  Time for a cappuccino (because it is {{ temperature}} degrees)!
{% else %}
  Time for a cold brew (because it is {{ temperature}} degrees)!
{% endif %}

------------------------------------------------------------
  -- no whitespace management
{% set foods = ['carrot', 'hotdog', 'cucumber', 'bell pepper'] %}

{% for food in foods %}
    {% if food == 'hotdog' %}
        {% set food_type = 'snack' %}
    {% else %}
        {%- set food_type = 'vegetable' %}
    {% endif %}

The {{ food }} is my favorite {{ food_type }}

{% endfor %}

------------------------------------------------------------
  -- whitespace management
{%- set foods = ['carrot', 'hotdog', 'cucumber', 'bell pepper'] -%}

{%- for food in foods -%}
    {%- if food == 'hotdog' -%}
        {%- set food_type = 'snack' -%}
    {%- else -%}
        {%- set food_type = 'vegetable' -%}
    {%- endif -%}

The {{ food }} is my favorite {{ food_type }}

{% endfor %}

------------------------------------------------------------
  -- dictionary simple return
  {% set websters_dict = {
    'word' : 'data',
    'speech_part' : 'noun',
    'definition' : 'if you know you know'
} %}

{{ websters_dict['word'] }}

------------------------------------------------------------
  -- dictionary string return
  {% set websters_dict = {
    'word' : 'data',
    'speech_part' : 'noun',
    'definition' : 'if you know you know'
} %}

{{ websters_dict['word'] }} ({{ websters_dict['speech_part'] }}): defined as "{{ websters_dict['definition'] }}"

------------------------------------------------------------



------------------------------------------------------------



------------------------------------------------------------



------------------------------------------------------------



------------------------------------------------------------