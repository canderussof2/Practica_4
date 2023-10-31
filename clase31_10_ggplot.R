#Clase 31/10. ggplot
rm(list=ls())
setwd("/home/clinux01/Escritorio/Cande/Practica_4/")
library(ggplot2)
#ggplot tiene distintas capas.

#primera capa: DATOS. Siempre datos en df
datos<-iris

#segunda capa: MAPEO. Como los datos del df se relacionan. Indico quien es x, quien y.
              #Tamb cosas esteticas. 
ggplot(datos, aes(x = Petal.Length, y = Petal.Width, color =Species, shape= Species))

#tercera capa: ESTADISTICAS. En funcion de los datos q le doy. Esta bueno por ej para regresion lineal, box plot y te ubica medias y percentiles porq los calcula solito
ggplot(datos, aes(x = Petal.Length, y = Petal.Width)) +
  geom_smooth(method = "lm", se = FALSE, aes(color = Species))

#cuarta capa: ESCALAS. le puedo dar la escala q quiero. Puede ser continua o discreta o tiempo. Tamb tiene en cuenta la escala de colores
ggplot(datos, aes(x = Petal.Length, y = Petal.Width)) +
  geom_point(aes(color = Species, shape = Species), size = 3, alpha = 0.8) +
  geom_smooth(method = "lm", se = FALSE, aes(color = Species))
scale_color_manual(values = c("darkorange", "purple", "cyan4")) 

#quinta capa:GEOMETRIAS.define el tipo de graf q quiero q haga. El valor con una forma en particular
ggplot(datos, aes(x = Petal.Length, y = Petal.Width)) +
  geom_point(aes(color = Species, shape = Species), size = 3, alpha = 0.8) +
  geom_smooth(method = "lm", se = FALSE, aes(color = Species))

#sexta capa:PANELES. En cada uno grafica algo en particular
ggplot(datos, aes(x = Petal.Length, y = Petal.Width)) +
  geom_point(aes(color = Species, shape = Species), size = 3, alpha = 0.8) +
  geom_smooth(method = "lm", se = FALSE, aes(color = Species))
scale_color_manual(values = c("darkorange", "purple", "cyan4")) +
  facet_wrap(~Species)

#septima capa: COORDENADAS

#octava capa: TEMA. estilo del grafico. Aesthetic








