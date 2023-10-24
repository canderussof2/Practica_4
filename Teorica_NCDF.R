#Teorica del 24/10. Clase NCDF
rm(list=ls())
setwd("/home/clinux01/Escritorio/Cande Labo Martes/Practica_4/")

require(ncdf4) #Al inicio del script o antes de llamar a las funciones de la 
              #librería debemos cargar el paquete

#La instrucción para abrir un archivo es nc_open
#nc_open(filename,write=FALSE,readunlim=TRUE,verbose=FALSE,auto_GMT=TRUE,
 #       suppress_dimvals=FALSE )
#filename: nombre del archivo ncdf que desea abrirse
#write: si FALSE (default), entonces el archivo se abre solo para lectura. Si TRUE, la
#escritura también esta habilitada.
#readunlim: Cuanto se llama esta función lee los valores de todas las dimensiones
#asociadas a las variables. Esto puede ser lento en el caso de un archivo grande
#con una dimensión ilimitada. Si FALSE, los valores para la dimensión ilimitada no
#se leen automáticamente (pueden leerse después, manualmente, usando ncvar_get())
#verbose: Si TRUE, se imprimen mensajes durante la ejecución de la función,
#Además de abrir el archivo, en el objeto asignado se almacena información sobre
#el archivo y su contenido. El objeto es de clase ncdf. Esta clase permite al
#usuario acceder a los siguientes campos, en formato solo lectura:
#filename, una cadena de caracteres que contiene el nombre del archivo;
#ndims, un entero que contiene el numero de dimensiones del archivo;
#nvars, un entero que contiene el numero de variables en el archivo que NO son
#variables de coordenadas ;
#natts, un entero que contiene el numero de atribuciones globales;
#unlimdimid, un entero que contiene la id de la dimensión ilimitada, o -1 si no hay;
#dim, una lista de objetos de clase dim.ncdf;
#var, una lista de objetos de clase var.ncdf;
#writable, TRUE or FALSE, dependiendo si el archivo se abrió solo para lectura o
#para lectura y escritura: write=TRUE or write=FALSE

#-------------------------------------------------------------------------------
#Ejemplos
require(ncdf4)
nc<-nc_open ("/home/clinux01/Escritorio/Cande Labo Martes/Practica_4/hgt850.nc")
class(nc)
#Para obtener una variable se utiliza el comando ncvar_get y asigno la salida a
#un objeto, en este caso hgt
hgt850<-ncvar_get(nc, "hgt") #obtengo del archivo nc, la variable hgt. 
#Almaceno en hgt850 lo que esta en nc y lo q esta entre "" es el nombre corto de
#las variables en el coso q aparece por consola para ver como esta almacenado
hgt #escribo el nombre de la variable para ver los datos. Como son??
#asigno las variables de coordenadas a distintas variables. Como son??
Longitud<-ncvar_get(nc,varid="lon")
Latitud<-ncvar_get(nc,varid="lat")
Time<-ncvar_get(nc,varid="time")
#¿Qué pasa con la variable Time?
head(Time) #pido por pantalla los primeros valores de Time
#¿Son fechas? ¿Cuál es el paso (el delta t)? Busquemos en la info, en que unidad
#esta expresado el tiempo. 

#SOLUCIONES (una o la otra)
# UNA forma de poder leer la información de la fecha,
#tengo que saber cuando comienza, el delta t y la cantidad de información
z<-seq(as.Date("1981/1/1"), by= "day", length.out= 12783)
head(z)

# OTRA forma de leer las fechas es por medio de una libreria que hay que instalar
# libreria para transformar las fechas del ncdf a variable
library(lubridate)
require(lubridate)
#transformo los datos del tiempo
# NOTAR que el "comienzo es 1800-1-1)
time <- ymd_hms ("1800-1-1 00:00:00") + hours(Time)
#leer como vienen los datos, hay veces q se cambia el "hours" por "day"
head(time)







