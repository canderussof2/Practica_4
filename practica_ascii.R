#Pratica del 10/10. Archivos ASCII

rm(list=ls())
setwd("/home/clinux01/Escritorio/Cande Labo Martes/")

#Lectura
#suele utilizar la función read.table():Esta función lee un archivo con formato 
#de tabla y crea un data frame.
#Sintaxis:
  #read.table(archivo)
#Los argumentos utilizados habitualmente para esta función son:
#*header: indica si el archivo tiene encabezado (header=TRUE) o no
#(header=FALSE). Por defecto toma el valor header=FALSE. Si quiero q las lea
#*sep: caracter separador de columnas que por defecto es un espacio en
#blanco (sep=““). Otras opciones serían: sep=”,” si el separador es
#un coma, sep=“:” si el separador son dos puntos, etc.
#*dec: caracter utilizado en el archivo para los números decimales. Por
#defecto se establece dec = “.”. Si los decimales vienen dados por “,”
#se utiliza dec = “,”. Perm indicar como estan separados los decimales

#read.table(archivo, header = FALSE, sep = "", dec = ".")
#En este caso estaria indicando que el archivo NO tiene encabezado, el
#separador de las columnas es un espacio en blanco y el separador decimal
#es un punto

#Mas argumentos
#col.names: vector que tenga el nombre de las columnas.
#na.strings: caracteres que deben tomarse como NA. Los espacios en blanco se consideran NA.
#skip: número entero que especifica el número de filas que NO quieren leerse. 
#Entonces si no quiero leer las primeras tres columnas deboagregar el argumento skip=3
#nrows: número entero que especifica el número de filas quieren leerse del archivo


## seteo la ruta hacia el directorio nombrando primero la carpeta, luego el archivo
archivo<- "/home/clinux01/Escritorio/Cande Labo Martes/boya.txt"
## Primero leo el archivo solo usando read.table sin especificar otro argumento
datos<- read.table(archivo) # Miro como se cargaron los datos. Datos mensuales desde 1982 a 2015
head(datos) # Con head cargo solo las primeras 6 filas
tail(datos) #tail muestra las ultimas

#La primera columna no tiene datos sino el encabezado del archivo.
# Entonces para que la lectura sea correcta tengo que
# agregar el argumento header= TRUE
datos <- read.table(archivo, header = TRUE)
head(datos)
dim(datos) #son 400 filas y 3 columna. Puedo mirar las dim porque read.table() lo carga como un df

#-------------------------------------------------------------------------------
archivo_2<- "/home/clinux01/Escritorio/Cande Labo Martes/boya_2.txt"
# Abrimos el archivo sin especificar otro argumento
datos_2<- read.table(archivo_2)
head(datos_2) #imprimo por pantalla los datos. Los pone en una misma columna

# Podemos ver que el archivo tiene encabezado y ademas esta separado por comas
# Entonces para leerlo correctamente usamos header=TRUE y sep= ","
datos_2<- read.table(archivo_2, header = TRUE, sep = ",")
head(datos_2)

#-------------------------------------------------------------------------------
#SCAN
#devuelve lista con cada una de las columnas
#Los archivos ascii se pueden leer también con la función scan y read.fwf 
#La función scan es muy flexible. A diferencia de read.table, que devuelve un data 
#frame, la función scan devuelve una lista o un
#vector. Esto vuelve a scan menos últil cuando se leen datos tabulado.
#En el argumento what se usa una lista y se colocan las variables.
#Luego de cada variable le decimos a R que tipo de variable es.
#Usamos la función read.fwf para leer datos con formato fijo (ancho
#fijo en las columnas). La cantidad de espacios en cada columna se
#la define con el parámetro width. En meteorología sirve mucho para
#los sondeos porque al usar read.table suele haber problemas en los
#niveles mas altos porque no tenemos todos los datos disponibles.

datos_2<- scan(archivo_2,what = list("numeric(0)","numeric","numeric"),sep = ",")
head(datos_2)

#-------------------------------------------------------------------------------
#WRITE.TABLE()
#La función write.table() se utiliza para guardar una variable en un
#archivo .txt. La variable a guardar debe ser un data.frame para que
#tenga un formato de “tabla”.
#Sintaxis:
#  write.table( variable, file= "archivo.txt",otros_argumentos)

#na: el caracter que se usa como dato faltante
#quote: valor lógico (TRUE o FALSE) para especificar si quiero
#que los caracteres se muestren con comillas o no
#append: si TRUE agrega datos al final del archivo de escritura,
#es decir si quiero no sobreescribir el archivo, sino agregar
#información. 
#row.names/col.names: por default son TRUE. Si quiero
#conservar eliminar el numero de fila como nombre de filas
#especifico row.names=FALSE

# Creo dos vectores
tipo <- c("A", "B", "C")
longitud <- c(120.34, 99.45, 115.67)
## Con los vectores tipo longitud creo un data frame
datos_salida <- data.frame(tipo, longitud)
datos_salida

#primero seteo el directorio de salidas y el nombre del archivo con la funcion here
archivo_salida <- "/home/clinux01/Escritorio/Cande Labo Martes/ejemplo_escritura_datos.txt"
#luego uso la funcion write.table especificando primero la
# variable datos_salida
# y luego el nombre de archivo con su ruta correspondiente
write.table(datos_salida, file = archivo_salida)
# si quiero especificar que los caracteres sean sin comillas uso el argumento
# quote=FALSE
# si ademas quiero eliminar los numeros de fila
#uso row.names=FALSE
write.table(datos_salida, archivo_salida, quote = F, row.names= F)

#-------------------------------------------------------------------------------
#EJERCICIO
rm(list=ls())
setwd("/home/clinux01/Escritorio/Cande Labo Martes/")

archivo<- "/home/clinux01/Escritorio/Cande Labo Martes/datos_estaciones.txt"
datos<- read.table(archivo,header=T)
dato_faltante <- -999
faltante<-which(datos == dato_faltante) #Me da las posiciobnes
length(faltante) #Para ver la cantidad de datos faltantes. 

datos$TEMP[which(datos$TEMP == dato_faltante)] <- NA
datos$HUM[which(datos$HUM == dato_faltante)] <- NA
datos$PNM[which(datos$PNM== dato_faltante)] <- NA
datos$DD[which(datos$DD == dato_faltante)] <- NA
datos$FF[which(datos$FF == dato_faltante)] <- NA

for(variable in 3:5){
 #maximo_T <- c()
 #maximo_H <- c()
 #maximo_P <- c()
  if (variable == 3) {
     maximo_T <- max(datos[,3],na.rm=T)
   } else if (variable==4) {
     maximo_H<- max(datos[,4],na.rm=T)
   } else  {
     maximo_P<-max(datos[,5],na.rm=T)
     }
}

datos$NOMBRE[which(datos$TEMP==maximo_T)]
as.character(datos$NOMBRE[which(datos$TEMP==maximo_T)])






