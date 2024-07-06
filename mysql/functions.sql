delimiter $$
CREATE FUNCTION price_calculate(price DECIMAL(6, 2), profit DECIMAL(5, 2))
    RETURNS DECIMAL(6, 2) DETERMINISTIC
    BEGIN
        IF (profit > 1)
            THEN
            set profit = profit / 100;
        END IF;
        set price = price + (price * profit);
        RETURN ROUND(price, 2);
    END
$$ delimiter ;

DROP FUNCTION IF EXISTS price_calculate;

SELECT price_calculate(100, 0.1);
