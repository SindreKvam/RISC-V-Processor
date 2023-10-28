# Øving 4
# Ikke bry deg om denne delen, move along
.data
function_error_str: .string "ERROR: Woops, programmet returnerte ikke fra et funksjonskall!"

.text
# Her starter programmet


# Test Mode
# Sett a7 til 1 for å teste med veridene under Test - Start
# Sett a7 til 0 når du skal levere
li a7, 1
beq a7, zero, load_complete

# Test - Start
li a0 6
li a1 5
li a2 4
li a3 3
li a4 2
li a5 1
#Test Slutt

load_complete:

# Globale Registre:
# s0-s5 : Foreløpig liste
# s6    : Har byttet verdier denne syklusen (0/1)

# Hopp forbi funksjoner
j main


# Funksjoner:
    
swap:
    # Args: a0, a1
    # Outputs: a0, a1
    
    # TODO
    # Sammenlikn a0 og a1
    # Putt den minste av dem i a0 og den største i a1
    # Hvis den byttet a0 og a1, sett den globale variablen s6 til 1 for å markere dette til resten av koden
    
    # Hopp direkte til slutt av denne funksjonen dersom a1 er større eller lik a0
    bge a1, a0, swap_complete
    
    # Bytt verdiene
    mv t0, a1
    mv a1, a0
    mv a0, t0
    
    li s6, 1
    
    
swap_complete:
    # TODO 
    # Returner til instruksjonen etter funksjonskallet (en instruksjon)
    jr ra

# Hvis programmet kommer hit har den ikke greid å returnere fra funksjonen over
# Dette bør aldri skje
la a0, function_error_str
li a7, 4
ecall
j end


# Main
main:
    # TODO
    # Last in s0-s5 med verdiene fra a0-a5
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    
loop:
    # TODO
    # Reset verdibytteindikator (en instruksjon)
    li s6, 0
    
    # TODO
    # Sorter alle
    # Repeter følgende logikk:
    # Ta s[i] og s[i+1], og lagre dem som argumenter
    # Kall funksjonen `swap` som sorterer dem
    # Nå skal `swap` ha outputet de to verdiene i to registre
    # Putt den minste verdien i s[i], og den største i s[i+1]
    # Repeter for i=0..4
    
    # TODO
    # 0 <-> 1
    mv a0, s0
    mv a1, s1
    jal ra, swap
    mv s0, a0
    mv s1, a1
    
    # TODO
    # 1 <-> 2
    mv a0, s1
    mv a1, s2
    jal ra, swap
    mv s1, a0
    mv s2, a1

    # TODO
    # 2 <-> 3
    mv a0, s2
    mv a1, s3
    jal ra, swap
    mv s2, a0
    mv s3, a1

    # TODO
    # 3 <-> 4
    mv a0, s3
    mv a1, s4
    jal ra, swap
    mv s3, a0
    mv s4, a1
    
    # TODO
    # 4 <-> 5
    mv a0, s4
    mv a1, s5
    jal ra, swap
    mv s4, a0
    mv s5, a1
    
    # TODO
    # Fortsett loop hvis noe ble endret (en instruksjon)
    bne s6, zero, loop
    # Hvis ingenting ble byttet er listen sortert
loop_end:
    
    # TODO
    # Flytt alt til output-registrene
    mv a0, s0
    mv a1, s1
    mv a2, s2
    mv a3, s3
    mv a4, s4
    mv a5, s5
    
end:
    nop
    