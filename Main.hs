module Main where
import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Display
import Graphics.UI.GLUT.Begin
import Dibujo
import Interp
import qualified Basica.Ejemplo as E
import qualified Graphics.Gloss.Data.Point.Arithmetic as V

--Funciones para rellenar el fondo de la imagen inicial

-- comprender esta función es un buen ejericio.
lineasH :: Vector -> Float -> Float -> [Picture]
lineasH origen@(x, y) longitud separacion = map (lineaH . (*separacion)) [0..]
  where lineaH h = line [(x, y + h), (x + longitud, y + h)]

-- Una grilla de n líneas, comenzando en origen con una separación de sep y
-- una longitud de l (usamos composición para no aplicar este
-- argumento)
grilla :: Int -> Vector -> Float -> Float -> Picture
grilla n origen sep l = pictures [ls, lsV]
  where ls = pictures $ take (n+1) $ lineasH origen sep l
        lsV = translate 0 (l*toEnum n) (rotate 90 ls)

-- Configuración para interpretar un dibujo
data Conf a = Conf {
    basic :: a -> ImagenFlotante
  , fig  :: Dibujo a
  , width :: Float
  , height :: Float
  , r :: Picture -> Picture  -- Reposicionar figura
  }

ej ancho alto = Conf {
                basic = E.interpBas
              , fig = E.ejemplo
              , width = ancho
              , height = alto
              , r = id
              }

moverCentro :: Float -> Float -> Picture -> Picture
moverCentro ancho alto p = translate (-ancho / 2) (-alto / 2) p

ejCentro ancho alto = Conf {
                basic = E.interpBas
              , fig = E.ejemplo
              , width = ancho
              , height = alto
              , r = moverCentro ancho alto
              }

-- Dada una computación que construye una configuración, mostramos por
-- pantalla la figura de la misma de acuerdo a la interpretación para
-- las figuras básicas. Permitimos una computación para poder leer
-- archivos, tomar argumentos, etc.
inicial :: IO (Conf E.Basica) -> IO ()
inicial cf = cf >>= \cfg ->
    let ancho  = (width cfg, 0)
        alto  = (0, height cfg)
        imagen = interp (basic cfg) (fig cfg) (0, 0) ancho alto
    in display win white . withGrid $ imagen
  where grillaGris = color grey $ grilla 10 (0, 0) 100 10
        withGrid p = pictures [p, grillaGris]
        grey = makeColorI 120 120 120 120

win = InWindow "Paradigmas 2025 - Lab1" (500, 500) (0, 0)
main = inicial $ return (ej 100 100)
