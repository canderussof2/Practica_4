#CLASE PRACTICA AGGREGATE 02/11
rm(list=ls())
setwd("/home/clinux01/Escritorio/Cande Labo Jueves/Practica_4/")
#solo se puede usar para df
#La función Aggregate divide los datos de un dataframe en subconjuntos, calcula estadísticas para cada subconjunto y devuelve el resultado en un nuevo data.frame. Es similar al apply de los array/matrices
# Data frame
aggregate(x, # Objeto de R
          by, # Lista de variables (elementos que forman los grupos)
          FUN, # Función a ser aplicada para crear el resumen estadístico
          ..., # Argumentos adicionales a ser pasados a FUN
          simplify = TRUE, # Simplificar el resultado lo máximo posible                               (TRUE) o no (FALSE)
          drop = TRUE) # Deshechar las combinaciones no usadas de grupos                         (TRUE) o no (FALSE).
#by: lista de variables donde yo voy a hacer mi grupo de datos
#fun es la func q voy a aplicar

#Usamos siguiente conjunto de datos de R
df <- chickwts
head(df)

group_mean <- aggregate(df$weight, list(df$feed), mean) #a quien se lo aplico (weigth). Tomo datos peso, los separo en func de la comida q hay y le calculo el promedio
group_mean <- aggregate(weight ~ feed, data = df, mean) # Equivalente
group_mean
class(group_mean) #df

#para longitud
aggregate(chickwts$feed, by = list(chickwts$feed), FUN = length) 

#Vamos a crear una nueva variable categórica llamada cat_var.
set.seed(1)
cat_var <- sample(c("A", "B", "C"), nrow(df), replace = TRUE)
df_2 <- cbind(df, cat_var)
head(df_2)

#Aplico la funcion "sum" teniendo en cuenta la categoria del feed y de cat_var
aggregate(df_2$weight, by = list(df_2$feed, df_2$cat_var), FUN = sum)
#by me da la cant de columnas q voy a tener. Me hace dos grupos, el de comida y el de categoria




