come eseguire il nostro planner:

1) Spostarsi nella cartella "punto2" della directory di progetto

2) eseguire il comando:
	java -cp pddl4j-4.0.0.jar fr.uga.pddl4j.planners.statespace.EmergencyProblemPlanner" <domain_file> <problem_file> 

3) aggiungere eventualmente le opzioni -w <peso> per cambiare il peso dell'euristica e -s <num_split> per cambiare il numero
   di sottoproblemi in cui viene suddiviso il problema iniziale

Nota: per comodità una copia dei nostri file di dominio e i file delle istanze del problema sono presenti nella stessa cartella "punto2"