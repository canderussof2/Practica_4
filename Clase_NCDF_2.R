#################
##################################################################
# # Laboratorio de Procesamiento de Informaci???n Meteorol???gica/Oceanografica
getwd()
# 2??? cuatrimestre 2022
##################################################################

##################################################
#######################################
# clase NCDF 2
#Clase teorica del 26/10
####################
##################################################################
rm(list=ls())
setwd("/home/clinux01/Escritorio/Cande Labo Jueves/Practica_4/")

require(ncdf4)
require(lubridate)

OUTPUTS<- ("/home/clinux01/Escritorio/Cande Labo Jueves/Practica_4/")

lon <- seq(270,320,5)
lats<-seq(-10,-50,-5) 

length(lon)
length(lats)

Months<-as.numeric(seq(as.Date("1979/1/1"), by= "month", length.out= 432)) #secuencia de los meses. Me la genera en dias
Months

##########################
#CUIDADO CON LOS MESES
meses<-seq(as.Date("1950/1/1"), by="days",length.out=120) #Guarda como fechas
mes<-as.numeric(meses) #te lo pasa al codigo raro. Son negativos porq empieza por 1970
time<-ymd_hms("1970-1-1 00:00:00") + days(mes)
head(time)
head(meses)

meses1<-seq(as.Date("1950/1/1"), by="months",length.out=120) #Guarda como fechas
mes1<-as.numeric(meses) #te lo pasa al codigo raro. Son negativos porq empieza por 1970
time1<-ymd_hms("1970-1-1 00:00:00") + days(mes1)
head(time1)
head(meses1)
##########################

#defino dimensiones. Primero creo las dimensiones
dimX<- ncdim_def( "long", "degrees", lon)
dimY<- ncdim_def ( "lat", "degrees", lats )
dimT<- ncdim_def( "Time", "days", Months, unlim=TRUE )

#defino variable. Ahi le asigno las dimensiones
var1d <- ncvar_def("mslp", units= "hPa", longname= "mean sea level pressure", 
                   dim= list(dimX,dimY,dimT), missval= -999, prec="double",verbose=TRUE )
#variable a ser creada, el nombre corto, el largo, la unidad, como defino el nombre faltante, 
#las dimensiones, la precision.

#nc_create es para crear el archivo de escritura
nc<- nc_create(paste(OUTPUTS,"mslp_hPa.nc",sep=""), list(var1d) ) 

MSLP<-runif(42768) #valores aleatorios
#42768 porq son esa cant de puntos de grillas porque 11x9x432

#"lleno la caja". Con ncvar ahi junto todo. Cargo las variables en el archivo
ncvar_put( nc, var1d, MSLP/10) #nc objeto clase NCDF sobre el cual se va a escribir,
                               #var1d la variable a la cual se asignaran los datos, 
                               #MSLP los valores 

nc_close(nc) #Cierro el archivo


##########################

#### ABRIR lo que guardamos

nc<-nc_open("/home/clinux01/Escritorio/Cande Labo Jueves/Practica_4/mslp_hPa.nc")
nc
class(nc)


presion<-ncvar_get(nc,varid="mslp") 

Longitud<-ncvar_get(nc,varid="long")
Latitud<-ncvar_get(nc,varid="lat")
Time<-ncvar_get(nc,varid="Time")

class(presion)
class(Longitud)
class(Latitud)

class(Time)

head(Time)

fecha<-ymd_hms ("1970-1-1 00:00:00") + days(Time) 

head(fecha)
tail(fecha)

presion[2,2,3]

#-------------------------------------------------------------------------------
#Practicar solos 
practicar_solos<-nc_open("/home/clinux01/Escritorio/Cande Labo Jueves/Practica_4/X157.92.28.55.252.12.27.10.nc")
#FIJATE EN EL SCRIPT DE M PAULA


