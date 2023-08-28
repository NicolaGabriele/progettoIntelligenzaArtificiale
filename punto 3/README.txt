Come eseguire il punto 3:

1) Eseguire il piano con il planner LPG-TD in versione quality, nella cartella di LPG-TD digitare:
	./lpg-td -o punto3_domain.pddl -f instance1_3.pddl -out planquality -quality

2) Eliminare le righe in eccesso nel piano e mantenere solo le azioni, dopo di che sfruttare "script_M2m.py" per rendere il piano compatibile con POPF

3) Inserire il workspace "progettoRobot" all'interno del workspace di plansys2
	N.B. E' consigliato avere il workspace di plansys2 in una cartella diversa da quella di ROS

4) All'interno del workspace progettoRobot\src\crazy_robot eseguire i seguenti comandi:
	colcon build --symlink-install
	source install/setup.bash
	ros2 launch crazy_robot crazy_robot_launch.py
   Aprire un altro terminale e runnare plansys2:
	ros2 run plansys2_terminal plansys2_terminal

5) Caricare il file commands per settare le istanze del problema e poi lanciare il piano per verificare se il piano viene correttamente interpretato e eseguito da plansys2:
	source source /plansys2_ws/src/ros2_planning_system_examples/progettoRobot/src/crazy_robot/launch/commands.txt
    	run plan-file /plansys2_ws/src/ros2_planning_system_examples/progettoRobot/src/crazy_robot/launch/planquality.txt