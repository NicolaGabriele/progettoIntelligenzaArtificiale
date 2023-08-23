package fr.uga.pddl4j.heuristics.state;

import fr.uga.pddl4j.planners.statespace.search.Node;
import fr.uga.pddl4j.problem.*;
import fr.uga.pddl4j.problem.operator.Condition;
import fr.uga.pddl4j.util.BitVector;


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
        this.expandRelaxedPlanningGraph(state);
        BitVector positiveFluents = goal.getPositiveFluents();
        int count = 0;
        for(int i = positiveFluents.nextSetBit(0); i>=0; i = positiveFluents.nextSetBit(i+1)){
            BitVector tmp = new BitVector();
            tmp.set(i);
            if(state.satisfy(new Condition(tmp,new BitVector())))count++;
        }
        BitVector negativeFluents = goal.getNegativeFluents();
        for(int i = negativeFluents.nextSetBit(0); i>=0; i = negativeFluents.nextSetBit(i+1)){
            BitVector tmp = new BitVector();
            tmp.set(i);
            if(state.satisfy(new Condition(tmp,new BitVector())))count++;
        }
        int value = goal.cardinality() - count;
        return value;
    }

    @Override
    public double estimate(Node node, Condition goal) {
        return this.estimate((State)node,goal);
    }
}
