' Generado por IA Esto se llama Síntesis de Audio.
' version 1 la uso para frecuencias de bienestar en consola
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
Sub EmitirTono(frecuencia As Double, duracion As Double)
    
    ' 1. Calcular tamaños
    Dim numMuestras As UInteger = SAMPLE_RATE * duracion
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
    
    Dim ptrMuestras As Short Ptr = Cast(Short Ptr, p)
    
    For i As UInteger = 0 To numMuestras - 1
        Dim tiempo As Double = i / SAMPLE_RATE
        
        ' FORMULA DEL SENO: Amplitud * Sin(2 * PI * Frecuencia * Tiempo)
        Dim valorFlotante As Double = Sin(2.0 * PI * frecuencia * tiempo)
        
        ' Escalar a rango 16-bit (-32768 a 32767)
        ' Multiplicamos por 32767 para volumen maximo. Usa 10000 para volumen medio.
        Dim muestra As Short = valorFlotante * 32767
        
        ptrMuestras[i] = muestra
    Next
    
    ' 5. Reproducir usando API de Windows
    ' SND_MEMORY = El sonido esta en memoria
    ' SND_SYNC   = Esperar a que termine el sonido antes de seguir (no superponer notas)
    PlaySound(Cast(ZString Ptr, buffer), NULL, SND_MEMORY Or SND_SYNC)

    ' 6. Liberar memoria
    Deallocate(buffer)
    
End Sub

' ==========================================
' PRUEBA
' ==========================================

Print "Generando ondas senoidales..."
Print "Reproduciendo Ondas Sanadoras... "
Print "Descargo de responsabilidad: Las frecuencias no sustituyen "
Print "tratamientos médicos y sus efectos varían individualmente"

' Frecuencias aproximadas de la escala (Octava 4) reemplazdo por ondas de bienestar
'-----modificaciones

Dim  As Integer tipo, segundos
Print " La Durcion Se habla de 15 min a 30 min, yo empezaria de a poco"
Print " =============================================================="

Print "Las 9 frecuencias restantes de Solfeggio "
Print"
Print "1) 174 Hz 	Alivio del dolor, conexión a tierra   Sanación física, seguridad."
Print "2) 285 Hz 	Curación celular, regeneración 	     Reparación de tejidos, vitalidad"
Print "3) 396 Hz 	Liberación del miedo/culpa            Liberación emocional, chakra raíz"
Print "4) 417 Hz 	Transformación, cambio 	              Dejar ir, nuevos comienzos"
Print "5) 528 Hz 	Amor, reparación del ADN              Sanación del corazón, transformación"
Print "6) 639 Hz 	Conexión, relaciones                  Comunicación, armonía"
Print "7) 741 Hz 	Expresión, desintoxicación 	        Claridad, resolución de problemas"
Print "8) 852 Hz 	Intuición, conciencia espiritual      Tercer ojo, sabiduría interior"
Print "9) 963 Hz 	Conexión divina, iluminación 	        Chakra corona, unidad" 
Print "  otras adicionales"
Print "10) 432 Alinearse con el Universo(la musica del medioevo)    = 432 "



Input "elegir  tipo de onda 1, a 10 ... ", tipo
Print " 15 min son 900 segundos, 30 min 1800 segundos"
Input "Duracion en segundos que se desea escuchar ", segundos

Select Case tipo 
 Case 1 
 EmitirTono(174.0, segundos)
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

End Select


Print "Fin."
Sleep
