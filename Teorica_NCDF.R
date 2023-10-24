#Teorica del 24/10. Clase NCDF
rm(list=ls())
setwd("/home/clinux01/Escritorio/Cande/Practica_4/")

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
nc<-nc_open ("/home/clinux01/Escritorio/Cande/Practica_4/hgt850.nc")
class(nc)
#Para obtener una variable se utiliza el comando ncvar_get y asigno la salida a
#un objeto, en este caso hgt
hgt850<-ncvar_get(nc, "hgt") #obtengo del archivo nc, la variable hgt. 
#Almaceno en hgt850 lo que esta en nc y lo q esta entre "" es el nombre corto de
#las variables en el coso q aparece por consola para ver como esta almacenado
hgt850 #escribo el nombre de la variable para ver los datos. Como son??
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
z<-seq(as.Date("1981/1/1"), by= "day", length.out= 12783) #Mas arcaica.
head(z)

# OTRA forma de leer las fechas es por medio de una libreria que hay que instalar
# libreria para transformar las fechas del ncdf a variable. Esta es mas correcta
library(lubridate)
require(lubridate)
#transformo los datos del tiempo
# NOTAR que el "comienzo es 1800-1-1)
time <- ymd_hms ("1800-1-1 00:00:00") + hours(Time) #En Time estaban esos numeros
                                                    #de un millon y pico
#leer como vienen los datos, hay veces q se cambia el "hours" por "day"
head(time)

fechas<-as.Date(Time/24,origin="1800-01-01") #poneme como fecha a Time (numeros raros), lo divido por 24 (xq son 
                        #datos diarios pero estan cada 24 hrs) y le pongo el origen
head(fechas)

dimnames(hgt850)<-list(lon=Longitud,lat=Latitud,date=as.character(time))

str(hgt850) #Me da info de mi variable

#-------------------------------------------------------------------------------
#1) Leer el set de datos de hgt desde el archivo
#Corroborar su lectura ploteando un campo bidimensional (es decir 1 solo día)
#contour(“variable a graficar”) mi variable es hgt
contour(hgt850[,,1]) #Todas las lat, long pero el tiempo 1 (dia 1). 
#En el N paralelas en el S mas chanfleado. Esta mal. Esta al reves. Lat quedaron al reves, siempre pasa. 

#-------------------------------------------------------------------------------
#2) Leer los datos de hgt para la banda de latitud 20S-40S exclusivamente.
#Corroborar su lectura ploteando un campo bidimensional. Me quiero quedar con una banda

#Hay dos formas
#a mano. Vas a latitud y contas las posiciones a mano
contour(hgt850[,9:17,1]) #con este tengo el problema de las latitudes
#con which
lat20<-which(Latitud==-20) #con menos porq es al S
lat40<-which(Latitud==-40)
contour(hgt850[,lat20:lat40,1]) #con este tengo el problema de las latitudes

contour(hgt850[,lat40:lat20,1]) #con este ya reverti el problema de las latitudes q tenia

#-------------------------------------------------------------------------------
#3) Leer los datos de hgt para el periodo 1990-2000 exclusivamente.
#Corroborar su lectura ploteando un campo bidimensional (31/12/1996)

fecha<-which(z=="1996-12-31")
fecha2<-which(time=="1996-12-31") #me da problemas
fecha2<-which(time=="1996-12-31 UTC") #me da problemas
fecha2<-which(format(time,"%Y-%m-%d")=="1996-12-31") #tiene un formato

contour(hgt850[,,fecha]) #con este tengo el problema de las latitudes 
contour(hgt850[,,fecha2]) #con este tengo el problema de las latitudes

#-------------------------------------------------------------------------------
#practicar solos
#-------------------------------------------------------------------------------
#radiacion onda larga valores medios mensuales 
ncolr<-nc_open("olr.mon.mean.nc")
ncolr #para ver la informacion
#3 dimens:lat, long, tiempo
#rangos no impoprta
#unidades w/m**2
#factor suma y factor escala. Ver q era algo de sumar y restar
#codigo dato faltante
#el nombre correcto
#de donde salio

#4dimens:
 # lomgitudes de 0 a 360-> todo el globo en grados este. en x Tengo 144 valores
 # latitudes de 90 a -90. en y. Tengo 73 valors
 # tiempos 438. empieza en el 1-1-1 a las 00 con un delta de un mes(un valor por mes). Son medias mensuales pero estan en horas

class(ncolr)
#extraigo la info
olr<-ncvar_get(ncolr, "olr") 
olr
Longitud<-ncvar_get(ncolr,varid="lon")
Latitud<-ncvar_get(ncolr,varid="lat")
Time<-ncvar_get(ncolr,varid="time")

#Hay q tener cuidado porq los dias de los meses van variando. Por eso la seq estaria mal
library(lubridate)
require(lubridate)

time0<-ymd_hms("1-1-1 00:00:0.0") + hours(Time) #tira error porq no identifica cual es el mes, año y dia
time<-ymd_hms("0000-1-1 00:00:00") + hours(Time) 
head(time)

dimnames(orl)<-list()

#grafico
contour(olr[,,100])

#-------------------------------------------------------------------------------
var<-nc_open("X157.92.28.55.252.12.27.10.nc")

#2 variables
#Temp media mensuak de la superficie Del Mar
#No tiene los factores de corrección
#En grados centígrados 

#4 dimens 
#Lat: 41 valores. 20 grados N a -60 (grados sur). En el Pacífico 
#Longitud: 81 valores 
#Tiempo:1980 valores. Delta de 1 mes

ssts<- ncvar_get(var, "sst") 
Longitud<-ncvar_get(var,varid="lon")
Latitud<-ncvar_get(var,varid="lat")
Time<-ncvar_get(var,varid="time")

library(lubridate)
require(lubridate)

time<-ymd_hms("1800-1-1 00:00:00") + hours(Time) 
tiempo<-as.Date(Time,origin="1800-1-1 00:00:00")
head(time)
head(tiempo)
dimnames(sst)<-

contour(ssts[,,3]) #no se q pingo es :). Todas las lat, todas las long para el tiempo 3. No me sirve xq quiero serie temp
#serie temporal para algún punto de retícula.
plot(ssts[15,15,],type="l",col="sky blue") #  conviene ya que solo hay una variable que se va a mover, la temporal

#-------------------------------------------------------------------------------
pp<-nc_open("pp_gfdl_hist_2001.nc")

#Variable Flujo de precipitacion
#unidades: kg/m**2 s
#valor faltante
#3 dimens :lat long tiempo
#long: 133 valores, grados este, le falta el rango
#lat: 153 valores, grados norte, le falta el rango
#tiempo: 365 valores,unidad de dias. primer dia 1 enero 1961, calendario gregoriano
#en los global atributes puedo ver en history como se fue modificando el archivo

pr<- ncvar_get(pp, "pr") 
Longitud<-ncvar_get(pp,varid="lon")
Latitud<-ncvar_get(pp,varid="lat")
Time<-ncvar_get(pp,varid="time")
max(pr) #Maximo de precipitacion. Muy chiquito porq es flujo de precipitacion

pp_mm<-pr*86400 #conversion a mm
max<-max(pp_mm)

posiciones<-which(pp_mm==max, arr.ind = T )
Longitud[84]
Latitud[39]











