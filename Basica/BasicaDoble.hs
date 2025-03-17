module Basica.BasicaDoble where
import Dibujo
import Interp
import Basica.Comun

data Basica = Triangulo | TrainguloVioleta

ejemplo :: Dibujo Basica
ejemplo = Apilar 1 1 (Figura Triangulo) (Rotar (Figura TrainguloVioleta))

interpBas :: Basica -> ImagenFlotante
interpBas Triangulo = triangulo
interpBas TrainguloVioleta = trianguloVioleta
