#Practica 12/10
# Lectura archivos Excel
rm(list=ls())
setwd("/home/clinux01/Escritorio/Cande Labo Jueves/Practica_4/")
path=getwd( )
require(readxl) #cargo libreria
library(readxl)

#Sintaxis:
  #excel_sheets(xls = nombre_archivo_xlsx, sheet = numero_o_nombre_de_hoja_a_abrir, ...)
#el nomnre con la ruta completa
#Observacion:
  # Las celdas vacías las reconoce como NA

#Ejemplo
archivo_ejemplo = "datos.xls"
cantidad_hojas <- length(excel_sheets(archivo_ejemplo)) #veo la cantidad de hojas del archivo
print(paste("El archivo tiene ", cantidad_hojas, " hojas"))
nombre_hojas <- excel_sheets(archivo_ejemplo) #veo los nombres de las hojas del archivo
print(paste("Estas hojas se llaman:",nombre_hojas))
print(nombre_hojas)

abro_archivo_ejemplo <- read_excel(archivo_ejemplo, sheet = 3) #por numero de hoja
#abro_archivo_ejemplo <- read_excel(archivo_ejemplo, sheet = "serie") #otra opcion, por nombre de hoja
head(abro_archivo_ejemplo) #veo las primeras 6 filas
class(abro_archivo_ejemplo) #es un DF

#-------------------------------------------------------------------------------
#ejercicio
rm(list=ls())
setwd("/home/clinux01/Escritorio/Cande Labo Jueves/Practica_4/")
datos_ejercicio = "Historicos_Estacion_3316.xlsx"
length(read_excel(datos_ejercicio))
read_excel(datos_ejercicio)
datos_altura <- read_excel(datos_ejercicio) #cargo datos
head(datos_altura)

#para pasar las fechas a dates
library(lubridate) #cargo libreria

tiempos <- dmy_hm(datos_altura$'Fecha y Hora') #paso columna de fechas a 
anios <- year(tiempos) #extraigo los anios
meses <- month(tiempos) #extraigo los meses
dias <- day(tiempos)
#Armo DataFrame
df_alturas <- data.frame("Anio" = anios, 
                                    "Mes" = meses, 
                                    "Dia" = dias,
                                    "Alturas" = datos_altura$'Altura [m]')
head(df_alturas)

#Calcular el promedio de la altura del río de enero para cada año entre 1980 y 2021
alturas_enero<-df_alturas[,"Alturas"]
anios_enero<-df_alturas[,"Anio"]
df_enero<-data.frame(anios_enero,alturas_enero)

x<-seq(1980,2021,by=1)
promedio_alturas_enero<-c()
for(anio in x){ #Fijate como definio julia lo de los años con length por lo de i
  enero<-df_enero$alturas_enero[df_enero$anios_enero==anio]
  promedio<-mean(enero,na.rm=T)
  promedio_alturas_enero<-c(promedio_alturas_enero,promedio)
}

#Estimar cual es el minimo de la media de altura de río de enero y a que año corresponde


#------------------------------------------------------------------------------
#DE JULIA
#Calculo el promedio de los eneros de cada anio entre 1981 y 2021

medias_eneros <- c()
anios_1981_2021 <- c(1981:2021)
for (i in 1:length(anios_1981_2021)) {
  anio <- anios_1981_2021[i]
  datos_anio <- mi_data_frame_alturas[mi_data_frame_alturas$Anio == anio,]
  enero <- datos_anio[datos_anio$Mes == 1,]
  media_enero <- mean(enero$Alturas, na.rm = TRUE)
  medias_eneros[i] <- media_enero
}
print(medias_eneros)

#calculo el minimo y el anio en que se dio
altura_minima <- min(medias_eneros, na.rm = TRUE)
anio_minima <- anios_1981_2021[which(medias_eneros == altura_minima)]

print(paste("La altura minima media de enero fue de: ", round(altura_minima,2), " en el año: ", anio_minima))

#armo funcion
media_mensual <- function(df,mes) {
  medias_mensuales <- c()
  anios_1981_2021 <- c(1981:2021)
  for (i in 1:length(anios_1981_2021)) {
    anio <- anios_1981_2021[i]
    datos_anio <- df[df$Anio == anio,]
    datos_mes <- datos_anio[datos_anio$Mes == mes,]
    media_mensual <- mean(datos_mes$Alturas, na.rm = T)
    medias_mensuales[i] <- media_mensual
  }
  return(list(medias_mensuales,anios_1981_2021))
}

#calculo, guardo en un dataframe y genero archivos
meses <- c(1:12)
medias_min <- c()
anios_min <- c()
for (mes in meses){
  print(mes)
  medias_mensuales_anios_temp <- media_mensual(mi_data_frame_alturas,mes)
  medias_mensuales_temp <- medias_mensuales_anios_temp[[1]]
  anios_temp <- medias_mensuales_anios_temp[[2]]
  media_min_temp <- min(medias_mensuales_temp,na.rm=T)
  medias_min <- c(medias_min,media_min_temp)
  anios_min <- c(anios_min,anios_temp[which(medias_mensuales_temp==media_min_temp)])
}

mi_data_frame_min_medias_mensuales <- data.frame("Anio" = anios_min, 
                                                 "Mes" = meses, 
                                                 "Medias mensuales altura" = medias_min)

library(writexl)
install.packages("writexl") #Instalar el paquete
write_xlsx(mi_data_frame_min_medias_mensuales, paste(path,"/data_frame_min_mensuales.xlsx",sep="")) #xlsx es de excel
write.csv(mi_data_frame_min_medias_mensuales, paste(path,"/data_frame_min_mensuales.csv",sep="")) #csv archivo de texto donde cada dato lo separa con una coma

