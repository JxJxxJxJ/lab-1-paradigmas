-- Sacar del esqueleto final!
module Interp where
import Graphics.Gloss
import Graphics.Gloss.Data.Vector
import qualified Graphics.Gloss.Data.Point.Arithmetic as V

import Dibujo

-- Gloss provee el tipo Vector y Picture.
type ImagenFlotante = Vector -> Vector -> Vector -> Picture
type Interpretacion a = a -> ImagenFlotante

mitad :: Vector -> Vector
mitad = (0.5 V.*)

-- Interpretaciones de los constructores de Dibujo

--interpreta el operador de rotacion
interp_rotar :: ImagenFlotante -> ImagenFlotante

--interpreta el operador de espejar
interp_espejar :: ImagenFlotante -> ImagenFlotante

--interpreta el operador de rotacion 45
interp_rotar45 :: ImagenFlotante -> ImagenFlotante

--interpreta el operador de apilar
interp_apilar :: Int -> Int -> ImagenFlotante -> ImagenFlotante -> ImagenFlotante

--interpreta el operador de juntar
interp_juntar :: Int -> Int -> ImagenFlotante -> ImagenFlotante -> ImagenFlotante

--interpreta el operador de encimar
interp_encimar :: ImagenFlotante -> ImagenFlotante -> ImagenFlotante

--interpreta cualquier expresion del tipo Dibujo a
--utilizar foldDib 
interp :: Interpretacion a -> Dibujo a -> ImagenFlotante

