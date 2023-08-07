import sys

def trasforma_testo_in_minuscolo(file_input, file_output):
    try:
        # Apri il file di input in modalità lettura
        with open(file_input, 'r') as f_input:
            testo_maiuscolo = f_input.read()

        # Trasforma il testo da maiuscolo a minuscolo
        testo_minuscolo = testo_maiuscolo.lower()

        # Apri il file di output in modalità scrittura
        with open(file_output, 'w') as f_output:
            f_output.write(testo_minuscolo)

        print("Trasformazione completata. Testo in minuscolo salvato in", file_output)

    except FileNotFoundError:
        print("Errore: Il file", file_input, "non esiste.")
    except Exception as e:
        print("Si è verificato un errore durante la trasformazione:", str(e))


if __name__ == "__main__":
    # Verifica che siano stati forniti entrambi i nomi dei file di input e output
    if len(sys.argv) != 3:
        print("Utilizzo: python nome_script.py file_input file_output")
        sys.exit(1)

    # Ottieni i nomi dei file di input e output dagli argomenti della riga di comando
    file_input = sys.argv[1]
    file_output = sys.argv[2]

    # Chiama la funzione per trasformare il testo in minuscolo
    trasforma_testo_in_minuscolo(file_input, file_output)

