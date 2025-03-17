module Basica.Comun where
import Graphics.Gloss
import Graphics.Gloss.Data.Vector
import Graphics.Gloss.Data.Color
import Graphics.Gloss.Geometry.Angle
import qualified Graphics.Gloss.Data.Point.Arithmetic as V

import Dibujo
import Interp

-- el vector nulo
vCero :: Vector
vCero = (0,0)

-- figuras adaptables comunes
-- [a, a + (b/2 + c), a + b, a]
triangulo :: ImagenFlotante
triangulo a b c = line $ map (a V.+) [vCero, mitad b V.+ c , b , vCero]

trianguloVioleta :: ImagenFlotante
trianguloVioleta a b c = color violet $ triangulo a b c

-- Poligono de color solido que une una lista de coordenadas
trianguloRecto :: ImagenFlotante
trianguloRecto origen ancho alto =
    color violet $ polygon $ map (origen V.+) [vCero, ancho, alto, vCero]

trianguloBorde :: ImagenFlotante
trianguloBorde origen ancho alto =
    let relleno = trianguloRecto origen ancho alto
        borde = color white $ line $ map (origen V.+) [vCero, ancho, alto, vCero]
    in pictures [relleno, borde]

nada :: ImagenFlotante
nada _ _ _ = blank

formaF :: ImagenFlotante
formaF a b c = line . map (a V.+) $
    [ vCero, uX, p13, p33, p33 V.+ uY , p13 V.+ uY
    , uX V.+ 4 V.* uY ,uX V.+ 5 V.* uY, x4 V.+ y5
    , x4 V.+ 6 V.* uY, 6 V.* uY, vCero]
  where p33 = 3 V.* (uX V.+ uY)
        p13 = uX V.+ 3 V.* uY
        x4 = 4 V.* uX
        y5 = 5 V.* uY
        uX = (1/6) V.* b
        uY = (1/6) V.* c