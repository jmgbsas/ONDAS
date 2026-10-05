' Generado por IA Esto se llama Síntesis de Audio.
' version 2 la uso para frecuencias de bienestar en consola
'Para hacer esto en FreeBASIC sin usar librerías externas, utilizaremos la API de Windows.
'La lógica es:

'Crear un bloque de memoria en la RAM.
'Escribir un encabezado WAV falso (solo para que Windows sepa qué formato es).
'Llenar los datos con la fórmula matemática del seno: 
'y=sin(2·p·frecuencia·tiempo)
'.
'Ordenar a Windows que reproduzca ese bloque de memoria.
'Nota: Este código está diseñado para Windows (usa windows.bi).

'Código Generador de Ondas Senoidales
'freebasic

' Generador de Onda Senoidal y Reproductor
' Requiere compilador para Windows
' unico error de la IA los 2 encabezados include de win
#include once "windows.bi"
#include once "win\mmsystem.bi"
#include "crt/math.bi" ' Para M_PI (Pi) o define tu propia constante

Const PI As Double = 3.1415926535897932
Const SAMPLE_RATE As Integer = 44100 ' Calidad CD
Const BITS As Integer = 16          ' 16-bit (Estándar)
Const CANALES As Integer = 1        ' 1 = Mono, 2 = Estereo

' Función para generar y tocar un tono
Sub EmitirTono(frecuencia As double, duracion As Double)
 
   
    ' 1. Calcular tamaños
    Dim numMuestras As UInteger = SAMPLE_RATE * duracion '''* delta
    Dim bytesPorMuestra As Integer = (BITS \ 8) * CANALES
    Dim tamDatos As UInteger = numMuestras * bytesPorMuestra
    Dim tamTotal As UInteger = 44 + tamDatos ' 44 bytes header + datos
    
    ' 2. Reservar memoria (Buffer)
    Dim buffer As Byte Ptr = Allocate(tamTotal) 
    If buffer = 0 Then
        Print "Error: No se pudo reservar memoria."
        Exit Sub
    End If
    
    ' 3. Escribir el Encabezado WAV (Formateamos el buffer para que parezca un WAV)
    Dim p As Byte Ptr = buffer
    
    ' "RIFF"
    *p = &H52: p+=1: *p = &H49: p+=1: *p = &H46: p+=1: *p = &H46: p+=1
    ' File Size
    Dim tamArchivo As UInteger = tamTotal - 8
    Dim i As Integer
    Dim tamBytes As UByte Ptr = @tamArchivo ' Truco para escribir bytes endian correcto en Little Endian (Intel/Windows)
    For i = 0 To 3: *p = tamBytes[i]: p+=1: Next
    
    ' "WAVE"
    *p = &H57: p+=1: *p = &H41: p+=1: *p = &H56: p+=1: *p = &H45: p+=1
    
    ' "fmt "
    *p = &H66: p+=1: *p = &H6D: p+=1: *p = &H74: p+=1: *p = &H20: p+=1
    
    ' Chunk size (16 for PCM)
    Dim tamFmt As UInteger = 16
    tamBytes = @tamFmt
    For i = 0 To 3: *p = tamBytes[i]: p+=1: Next
    
    ' Audio Format (1 = PCM)
    Dim fmt As UShort = 1
    Dim tamShort As UByte Ptr = @fmt
    *p = tamShort[0]: p+=1: *p = tamShort[1]: p+=1
    
    ' Channels (1 = Mono)
    Dim chan As UShort = CANALES
    tamShort = @chan
    *p = tamShort[0]: p+=1: *p = tamShort[1]: p+=1
    
    ' Sample Rate (44100)
    Dim sRate As UInteger = SAMPLE_RATE
    tamBytes = @sRate
    For i = 0 To 3: *p = tamBytes[i]: p+=1: Next
    
    ' Byte Rate (SampleRate * Channels * BitsPerSample/8)
    Dim bRate As UInteger = SAMPLE_RATE * CANALES * (BITS \ 8)
    tamBytes = @bRate
    For i = 0 To 3: *p = tamBytes[i]: p+=1: Next
    
    ' Block Align (Channels * BitsPerSample/8)
    Dim bAlign As UShort = CANALES * (BITS \ 8)
    tamShort = @bAlign
    *p = tamShort[0]: p+=1: *p = tamShort[1]: p+=1
    
    ' Bits Per Sample (16)
    Dim bPS As UShort = BITS
    tamShort = @bPS
    *p = tamShort[0]: p+=1: *p = tamShort[1]: p+=1
    
    ' "data"
    *p = &H64: p+=1: *p = &H61: p+=1: *p = &H74: p+=1: *p = &H61: p+=1
    
    ' Data Size
    tamBytes = @tamDatos

    For i = 0 To 3: *p = tamBytes[i]: p+=1: Next
    
    ' 4. Generar la Onda Senoidal
    ' Ahora apuntamos al area de datos (el puntero p ya esta ahí despues del header)
    Dim As UInteger xx=0
    Dim ptrMuestras As Short Ptr = Cast(Short Ptr, p)
    Dim As Double tiempo  

       For i As UInteger = 0 To numMuestras - 1
           tiempo  = i/ SAMPLE_RATE
        
        ' FORMULA DEL SENO: Amplitud * Sin(2 * PI * Frecuencia * Tiempo)
          Dim valorFlotante As Double = Sin(2.0 * PI * frecuencia * (tiempo ))
        
        ' Escalar a rango 16-bit (-32768 a 32767)
        ' Multiplicamos por 32767 para volumen maximo. Usa 10000 para volumen medio.
          Dim muestra As Short = valorFlotante * 32767
          
          ptrMuestras[i+xx] = muestra
      Next i
       PlaySound(Cast(ZString Ptr, buffer), NULL, SND_MEMORY Or SND_SYNC)
       PlaySound (NULL,NULL,null)
       

    ' 5. Reproducir usando API de Windows
    ' SND_MEMORY = El sonido esta en memoria
    ' SND_SYNC   = Esperar a que termine el sonido antes de seguir (no superponer notas)
    
     
    ' 6. Liberar memoria
    Deallocate(buffer)
    
End Sub

' ==========================================
' PRUEBA
' ==========================================

Width 100,40 ''' Console.SetWindowSize(100, 40)
Print "  Generando ondas senoidales..."
Print "  Reproduciendo Ondas Sanadoras... "
Print "  Descargo de responsabilidad: Las frecuencias no sustituyen "
Print "  tratamientos medicos y sus efectos varian individualmente"
Print "  No usar con volumen muy alto puede perjudicar a los oidos"
Print "  Cualquier frecuencia que se desee  experimentar"
Print "  se puede crearla con la opcion 24 incluso con decimales "
Print "  Los decimales seran con punto o coma [.] ej 4.5 depende de tu configuracion" 
Print "  pulse cualqueir tecla para comenzar"
Sleep
' Frecuencias  ondas de bienestar
'-----modificaciones

Dim  As Integer tipo, segundos=30
Dim As String dura

Do

Print "  =============================================================="
Print "         Las 9 frecuencias  de Solfeggio "
Print "  =============================================================="
Print "  La Duracion Se habla de 15 min a 30 min, yo empezaria de a poco"
Print "  15 min son 900 segundos, 30 min 1800 segundos, por omision 30 para probar"
Print "  5 mim son 300 segundos"
Print "  01) 174 Hz 	Alivio del dolor, conexion a tierra   Sanacion fisica, seguridad."
Print "  02) 285 Hz    Curacion celular, regeneracion        Reparacion de tejidos, vitalidad"
Print "  03) 396 Hz 	Liberación del miedo/culpa            Liberacion emocional, chakra raiz"
Print "  04) 417 Hz 	Transformación, cambio 	              Dejar ir, nuevos comienzos"
Print "  05) 528 Hz 	Amor, reparación del ADN              Sanacion del corazon, transformacion"
Print "  06) 639 Hz 	Conexion, relaciones                  Comunicacion, armonia"
Print "  07) 741 Hz 	Expresion, desintoxicacion            Claridad, resolucion de problemas"
Print "  08) 852 Hz 	Intuicion, conciencia espiritual      Tercer ojo, sabiduria interior"
Print "  09) 963 Hz 	Conexion divina, iluminacion 	      Chakra corona, unidad"
Print "  ==============================================================" 
Print "           Otras Ondas adicionales : "
Print "  =============================================================="
Print "  10) 432 Alinearse con el Universo(la NOTA LA musica del medioevo)    = 432 "
Print "  -------------------------------------------------------------------"
Print "  11) 7.83 Frecuencia Shuman la usaba Edgar Cayce  Curaciones "
Print "     Armonicos de 7,83 multiplicar por un nro -> 15,66, audibles ->{ 23,49 -> 31,32-> 39,15...."
Print "  12) Armonico * 3    -> 23,49"
Print "  13) Armonico * 4    -> 31,32"
Print "  14) Armonico * 5    -> 39,15"
Print "  15) Armonico * 6    -> 46,98"
Print "  16) Armonico * 7    -> 54,81"
Print "  17) Armonico * 8    -> 62,64"
Print "  18) Armonico * 9    -> 70,47"
Print "  19) Armonico * 10   -> 78,3 "
Print "  20) Armonico * 20   -> 156,6 "
Print "  21) Armonico * 100  -> 783  "
Print "  22) Armonico * 1000 -> 7830 "
Print "  23) Armonico a eleccion entre el Nro a multiplicar "
Print "  24) El ronroneo del gato va de 25 a 140, experimental ..
Print "      pero es por contacto 140-25=115 PROMEDIO 57.5 "
Print "      TAMBIEN SIRVE PARA CUALQUIER FRECUENCIA EJ LA/8=54"
Print "  25) LA MITAD DE NOTA LA DE 10) 432/2 = 216 
Print "  26) UN CUARTO  DE NOTA LA DE 10) 432/4 = 108 
Do While InKey <>"" : Loop
Input "  Duracion en segundos por omision 30 segundos "; dura

Do While InKey <>"" : Loop

Input "  Elegir  tipo de onda 1, a 26 ... ", tipo

If dura > "" Then
   segundos=CInt(dura)
Else
   segundos=30
EndIf
Select Case tipo 
 Case 1 
 EmitirTono(174.0,segundos)
Case 2
 EmitirTono(285.0, segundos)
 Case 3
 EmitirTono(396.0, segundos)
 Case 4
 EmitirTono(417.0, segundos)
  Case 5
 EmitirTono(528.0, segundos)
Case 6
 EmitirTono(639.0, segundos)
Case 7
 EmitirTono(741.0, segundos)
Case 8
 EmitirTono(852.0, segundos)
Case 9
 EmitirTono(963.0, segundos)
Case 10
 EmitirTono(432.0, segundos)
Case 11
 EmitirTono(7.83, segundos)
Case 12
 EmitirTono(23.49, segundos)
Case 13
 EmitirTono(31.32, segundos)
Case 14
 EmitirTono(39.15, segundos)

Case 15
 EmitirTono(46.98, segundos)
Case 16
 EmitirTono(54.81, segundos)
Case 17
 EmitirTono(62.64, segundos)
Case 18
 EmitirTono(70.47, segundos)
Case 19
 EmitirTono(78.3 , segundos)
Case 20
 EmitirTono(156.6 , segundos)

Case 21
 EmitirTono(783 , segundos)
Case 22
 EmitirTono(7830, segundos)
Case 23 
Dim num  As Integer
Dim fusu As Double
 Input "Numero a multiplicar a 7.83 ", num
 fusu=num*7.83
Print "Frecuencia resultante ";fusu
 EmitirTono(fusu, segundos)
Case 24
Do While InKey <>"" : Loop
Dim fGATO As Double
 Print "SI NO SE ENTRA UNA FRECUENCIA TOMA 57.5 (decimal el punto .)(115/2)
 Print "Frecuencia a experimentar,(las de gato van de 25 a 140,PERO SU EFECTO ES POR CONTACTO NO AUDIBLE). "
 Input "Entre la frecuencia deseada.-> ", fGATO 
 Print "frecuencia entrada , verificar el simbolo del decimal -> ",fGATO
If FGATO=0 Then FGATO=57.5 
 EmitirTono(fGATO, segundos)
Case 25
 EmitirTono(216.0, segundos)
Case 26
 EmitirTono(108.0, segundos)

Case Else
Exit Do

End Select
Cls
Loop
Print "  Fin."
Print "  Generando ondas senoidales..."
Print "  Descargo de responsabilidad: Las frecuencias no sustituyen "
Print "  tratamientos medicos y sus efectos varian individualmente"
Print "  No usar con volumen muy alto puede perjudicar a los oidos"
Sleep
