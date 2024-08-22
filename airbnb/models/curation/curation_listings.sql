WITH listings_raw AS
	(SELECT
		id AS listing_id,
		listing_url,
		name,
		description,
		description IS NOT NULL has_description,
		neighbourhood_overview,
		neighbourhood_overview IS NOT NULL AS has_neighrbourhood_description,
		host_id,
		latitude,
		longitude,
		property_type,
		room_type,
		accommodates,
		bathrooms,
		bedrooms,
		beds,
		amenities,
        {{ extraire_prix_a_partir_dun_caractere('price','$') }} as price,
		minimum_nights,
		maximum_nights
	FROM {{ ref("listings_snapshot") }}
    WHERE DBT_VALID_TO is null)
SELECT *
FROM listings_raw
WHERE
    price is not null
    AND price > 0