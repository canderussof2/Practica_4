#Practica 03/10
#Archivos binarios
#Un archivo binario es un archivo que contiene información de cualquier tipo
#codificada en bytes con el propósito de almacenar y procesar datos en computadoras.

#Lectura: readBin(archivo, clase, longitud, formato_maquina, tamaño)
#Escrtitura: writeBin(variable, archivo, tamaño, longitud, formato_maquina)

#En general, nos proporcionan un archivo adicional donde está la información de 
#la estructura que tiene el archivo binario. Este archive adicional tiene
#extensión .ctl

#El archivo .ctl en general contiene las siguientes secciones:
#dset ^nombre_archivo: indica cual es el archivo binario asociado
#undef ‘codigo_faltante’: valor que se usa para definir datos faltantes
#title ‘titulo’: descripcion breve del archivo
#options “opciones”: indica si algo debe intrepretarse distinto, el endian, etc.
#ydef nlats linear lat_ini incr: dimension y, cantidad, incremento
#xdef nlongs linear lon_ini incr: dimension x, cantidad, incremento
#tdef ntimes linear time_ini incr: dimension temporal, cantidad, incremento, etc
#zdef nlevs linear lev_ini incr: dimension z, cantidad, incremento, etc
#vars nvars: cantidad de variables que tengo y su descripcion Var1 descripcion

#Es recomendable leer el archivo como un vector largo y luego acomodar (en 
#general en un array) de acuerdo al archivo ctl 

#trabajo con data.ctl y data.r4
#Primero abrimos (con un editor de texto) el archivo data.ctl El
#archivo me muestra los datos

#Es conveniente primero definir las dimensiones del archivo y el código del
#dato faltante en función de los datos del archivo .ctl

nlat <- 181 #cantidad total de la dimension y (o latitudes)
nlon <- 360 #cantidad total de la dimension x (o longitudes)
ntiempos<- 348 #cantidad total de la dimension time (tiempos)
nnivel<- 1 #cantidad total de la dimension z (o niveles)
nvar <- 1 #Cantidad total de variables
dato_faltante<- -999

#Una vez que definí las dimensiones, se que el archivo binario va a tener
#como largo total la multiplicación entre las distintas dimensiones
## N que va a ser longitud del vectorque voy a leer del binario
N<- nlat*nlon*ntiempos*nnivel*nvar

#Ahora puedo abrir leer el archivo binario a partir de la funcion readBin
## antes defino la ruta donde esta el archivo
archivo <-"/home/clinux01/Escritorio/Cande Labo Martes/data.r4"
# ahora si abro los datos
datos<- readBin(archivo, "numeric", n = N, endian = "big", size = 4)
#El archivo es de precision simple (4bytes) y es un archivo big endian

#Ahora quiero manipular la variable datos, primero puedo chequear su longitud
length(datos)

#Chequeo que N sea igual
N

#Ahora puedo cambiar los datos que sean faltantes por NA
datos[which(datos== dato_faltante)] <- NA

#Luego puedo crear un array que tenga los datos que ahora estan en el
#vector. En este caso la variable solo tiene 3 dimensiones, segun el .ctl, y
#son las latitudes, longitudes y tiempos ya que hay un solo nivel y una sola
#variable
# Armo el array teniendo en cuenta que la primer dimension
# tiene que ser la de las longitudes. Luego las latitudes y luego el tiempo
datos_array<- array(data = datos, dim = c(nlon, nlat, ntiempos)) #si hubiera habido
#nivel vertical, deberia haberlo puesto entre nlat y ntiempos
dim(datos_array) 

#Puedo crear un vector con las longitudes y latitudes, para esto voy a
#necesitar los datos del .ctl:
#ydef 181 linear -90.000000 1.000
#xdef 360 linear 0.000000 1.000000
#Entonces las latitudes, van a ser 181 en total, comienzan en -90° y
#van cada 1°.
latitudes <- seq(-90,90,1) #creo el vector latitudes
length(latitudes) #chequeo que tenga como longitud 181
#Las longitudes seran 360 en total, comienzan en 0° y van cada 1°.
longitudes <- seq(0,359,1) #creo el vector longitudes
#chequeo que tenga como longitud 181
length(longitudes)

#Quiero quedarme con el array pero solo para la región de Argentina. Las 
#latitudes de Argentina: -55°S a -20° S y las Longitudes : -75°O a -50°O 
#(o tambien 285° a 310°)

lat_inicio<-which(latitudes==-55)
lat_final<-which(latitudes==-20)
long_inicio<-which(longitudes==285)
long_final<-which(longitudes==310)

argentina<-datos_array[long_inicio:long_final,lat_inicio:lat_final,]
dim(argentina)
#Tiempos son 348 y corresponden a 29 años. Tenemos datos mensuales de 29 años
348/29 #Tengo 12 meses de esos 29 años
#De tener 26 * 36 * 348 quiero pasar a tener 26 * 36 * 29 
#quiero transformar mis 348 en un nuevo array q sea 26 * 36 * 12 * 29
#y desp aplico el apply a la 3era dimension
nlon_arg<-26
nlat_arg<-36
argentina<-array(argentina,dim=c(nlon_arg,nlat_arg,12,29))
prom_anual_arg<-apply(argentina,c(1,2,4),mean)
dim(prom_anual_arg)
prom_anual_espacial_arg<-apply(argentina,c(4),mean,na.rm=T)
length(prom_anual_espacial_arg) #con length xq ya tiene una sola dimension

#---------------------------------------------------------------------
rm(list=ls())

nlat <- 181 #cantidad total de la dimension y (o latitudes)
nlon <- 360 #cantidad total de la dimension x (o longitudes)
ntiempos<- 6 #cantidad total de la dimension time (tiempos)
nnivel<- 1 #cantidad total de la dimension z (o niveles)
nvar <- 4 #Cantidad total de variables
dato_faltante<- 9.999E+20 

#Dimensiones
N<-nlat*nlon*ntiempos*nnivel*nvar

archivo <-"/home/clinux01/Escritorio/Cande Labo Martes/SepIC_nmme_tmpsfc_anom_stdanom.dat"
datos<- readBin(archivo, "numeric", n = N, endian = "big", size = 4)
length(datos) #Chequeo q sea igual al N

#Ahora puedo cambiar los datos que sean faltantes por NA
datos[which(datos== dato_faltante)] <- NA

#Armo array
datos_array<- array(data = datos, dim = c(nlon, nlat, nvar,ntiempos))
dim(datos_array)
#Puedo crear un vector con las longitudes y latitudes, para esto voy a
#necesitar los datos del .ctl:
#ydef 181 linear -90.0 1.0
#xdef 360 linear 0.000000 1.0
#Entonces las latitudes, van a ser 181 en total, comienzan en -90° y
#van cada 1°.
latitudes <- seq(-90,90,1) #creo el vector latitudes
length(latitudes) #chequeo que tenga como longitud 181
#Las longitudes seran 360 en total, comienzan en 0° y van cada 1°.
longitudes <- seq(0,359,1) #creo el vector longitudes
#chequeo que tenga como longitud 181
length(longitudes)


#quiero quedar con los datos de la variable anomalia
anomalias<-datos_array[,,3,] #selecciono la variable anomalia
dim(anomalias)

#quiero quedar con los datos de diciembre
dic<-anomalias[,,3]
dim(dic)

#quiero quedar con los datos de argentina
lat_inicio<-which(latitudes==-55)
lat_final<-which(latitudes==-20)
long_inicio<-which(longitudes==285)
long_final<-which(longitudes==310)

argentina<-dic[long_inicio:long_final,lat_inicio:lat_final]
dim(argentina)
