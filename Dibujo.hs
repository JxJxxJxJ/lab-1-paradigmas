module Dibujo where

-- Definir el lenguaje via constructores de tipo
data Dibujo a 
    = Basica a 
    | Rotar Dibujo a
    | Rotar45 Dibujo a
    | Espejar Dibujo a
    | Apilar Float Float Dibujo a Dibujo a  
    | Juntar Float Float Dibujo a Dibujo a 
    | Encimar Dibujo a 


-- Composición n-veces de una función con sí misma.
comp :: (a -> a) -> Int -> a -> a


-- Rotaciones de múltiplos de 90.
r180 :: Dibujo a -> Dibujo a

r270 :: Dibujo a -> Dibujo a



-- Pone una figura sobre la otra, ambas ocupan el mismo espacio.
(.-.) :: Dibujo a -> Dibujo a -> Dibujo a


-- Pone una figura al lado de la otra, ambas ocupan el mismo espacio.
(///) :: Dibujo a -> Dibujo a -> Dibujo a


-- Superpone una figura con otra.
(^^^) :: Dibujo a -> Dibujo a -> Dibujo a


-- Dadas cuatro dibujos las ubica en los cuatro cuadrantes.
cuarteto :: Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a

-- Una dibujo repetido con las cuatro rotaciones, superpuestas.
encimar4 :: Dibujo a -> Dibujo a


-- Cuadrado con la misma figura rotada i * 90, para i ∈ {0, ..., 3}.
-- No confundir con encimar4!
ciclar :: Dibujo a -> Dibujo a


-- Transfomar un valor de tipo a como una Basica.
pureDib :: a -> Dibujo a

-- map para nuestro lenguaje.
mapDib :: (a -> b) -> Dibujo a -> Dibujo b


-- Funcion de fold para Dibujos a
foldDib :: (a -> b) -> (b -> b) -> (b -> b) -> (b -> b) ->
       (Float -> Float -> b -> b -> b) -> 
       (Float -> Float -> b -> b -> b) -> 
       (b -> b -> b) ->
       Dibujo a -> b





