#Practica 31/10. NCDF
rm(list=ls())
setwd("/home/clinux01/Escritorio/Cande/Practica_4/")
library(ncdf4) #cargo libreria ncdf4
archivo <- "/home/clinux01/Escritorio/Cande/Practica_4/air.mon.mean.nc" #donde esta el archivo
nc<- nc_open(archivo) #abro el archivo netCDF
# Si queremos extraer la variable Monthly Mean Air Temp:
temp_aire<- ncvar_get(nc, "air")
#Miro de que clase y las dimensiones de los datos
class(temp_aire) # es un array

# Si queremos extraer la variable Monthly Mean Air Temp:
latitudes<- ncvar_get(nc, "lat")
longitudes<- ncvar_get(nc, "lon")
tiempos<- ncvar_get(nc, "time")
#imprimos por pantalla las primeras posiciones del
#vector que tiene los tiempos
head(tiempos)

tiempos_legibles<- as.Date(tiempos/24,origin="1800-01-01")
head(tiempos_legibles) #miro los primeros tiempos
tail (tiempos_legibles) #miro los ultimos tiempos

#si uso lubridate
library(lubridate)

#------------------------------------------------------------------------------
#Seleccionar los datos de temperatura del mes de marzo.
head(months(tiempos_legibles))
datos_temp_marzo <- temp_aire[, ,months(tiempos_legibles) == "marzo"]
dim(datos_temp_marzo) #tengo las 144 lon, 73 lat y 74 tiempos que corresponden a los datos de marzo

#------------------------------------------------------------------------------
#Usando metR
#Cargamos el paquete metR y udunits2
library(udunits2)
library(metR)
GlanceNetCDF(archivo) #Vemos las dimensiones del archivo con la función GlanceNetCDF. Este te devuelve en forma de df

datos <- ReadNetCDF(archivo, vars = "air") #abro los datos. El equivalente a nvar_get
head(datos) #miro las primeras filas
dim(datos) #calculo las dimensiones

#------------------------------------------------------------------------------
#Si quiero los datos de una region sola
datos_region<- ReadNetCDF(archivo, vars = "air", subset = list(lat = c(-65,-20),lon = c(280, 310)))

#------------------------------------------------------------------------------
#Ejercicio
#con GlanceNetNCDF
library(udunits2)
library(metR)
u850<-"/home/clinux01/Escritorio/Cande/Practica_4/datos_u850.nc"
GlanceNetCDF(u850) #veo las dimensiones
datos_cuenca_plata<- ReadNetCDF(u850, vars = "ua850", subset = list(lat = c(-38.75,-23.75),lon = c(-64.25, -51.25))) #oeste y Sur es negat

#quiero quedar con el promedio de cada año
head(datos_cuenca_plata)
anios<- year(datos_cuenca_plata$time)#me da los años de los datos
dato_todos_los_anios<-c()
for(anio in 2005:2010){
  dato_por_anio<-mean(datos_cuenca_plata$ua850[which(year(datos_cuenca_plata$time)==anio)],rm.na=T)
  dato_todos_los_anios<-c(dato_todos_los_anios,dato_por_anio)
}
data_frame_todos<-data.frame(2005:2010,dato_todos_los_anios)
colnames(data_frame_todos)<-c("Anio","Componente u")

#con ncdf4
rm(list=ls())
setwd("/home/clinux01/Escritorio/Cande/Practica_4/")
library(ncdf4) #cargo libreria ncdf4
u850<-"/home/clinux01/Escritorio/Cande/Practica_4/datos_u850.nc"
nc<- nc_open(u850) #abro el archivo netCDF
comp_u_850<- ncvar_get(nc, "ua850") #extraer la variable
latitudes<- ncvar_get(nc, "lat")
longitudes<- ncvar_get(nc, "lon")
tiempos<- ncvar_get(nc, "time")
tiempos_legibles<- as.Date(tiempos,origin="1949-12-01 00:00:00")
head(tiempos_legibles) #miro los primeros tiempos
tail (tiempos_legibles) #miro los ultimos tiempos

#Seleccionar los datos del 2005.
head(year(tiempos_legibles))
tail(year(tiempos_legibles))

#library(lubridate)
#tiempos_legibles_2<-ymd_hms()
#tiempos_legibles_2_dia<-tiempos_legibles_2+days(1)
#head(tiempos_legibles_2_dia)
#tail(tiempos_legibles_2_dia)




