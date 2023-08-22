package fr.uga.pddl4j.heuristics.state;

import fr.uga.pddl4j.heuristics.state.RelaxedGraphHeuristic;
import fr.uga.pddl4j.parser.DefaultParsedProblem;
import fr.uga.pddl4j.parser.Parser;
import fr.uga.pddl4j.planners.InvalidConfigurationException;
import fr.uga.pddl4j.planners.LogLevel;
import fr.uga.pddl4j.planners.ProblemNotSupportedException;
import fr.uga.pddl4j.planners.statespace.FF;
import fr.uga.pddl4j.planners.statespace.search.Node;
import fr.uga.pddl4j.problem.*;
import fr.uga.pddl4j.problem.operator.Action;
import fr.uga.pddl4j.problem.operator.Condition;

import java.io.FileNotFoundException;
import java.util.Arrays;

public class EmergencyProblemHeuristic extends RelaxedGraphHeuristic {

    private Problem p;
    private double alpha = 1, rate = 0.1;
    protected EmergencyProblemHeuristic(Problem problem) {
        super(problem);
        this.p = problem;
    }

    @Override
    public int estimate(State state, Condition goal) {
        super.setGoal(goal);
        final int level = this.expandRelaxedPlanningGraph(state);
        final int max = super.getMaxValue();
        final double value =(level > 3)?max:super.getSumValue();//super.getSumValue()+alpha*(level-super.getMaxValue());
        alpha-=rate;
        //System.out.println(value);
        return (isGoalReachable())?(int)value:Integer.MAX_VALUE;

    }

    @Override
    public double estimate(Node node, Condition goal) {
        return this.estimate((State)node,goal);
        /*super.setGoal(goal);
        final int level = this.expandRelaxedPlanningGraph(node);
        System.out.println(level+"\n"+"MAX_VALUE: "+super.getMaxValue()+"\n");
        final double value =super.getSumValue()+alpha*(level-super.getMaxValue());
        alpha-=rate;
        //System.out.println(value);
        return (isGoalReachable())?value:Integer.MAX_VALUE;*/
    }
}
