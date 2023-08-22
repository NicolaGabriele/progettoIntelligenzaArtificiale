
import fr.uga.pddl4j.heuristics.state.StateHeuristic;
import fr.uga.pddl4j.parser.DefaultParsedProblem;
import fr.uga.pddl4j.parser.Expression;
import fr.uga.pddl4j.plan.Plan;
import fr.uga.pddl4j.plan.SequentialPlan;
import fr.uga.pddl4j.planners.AbstractPlanner;
import fr.uga.pddl4j.planners.InvalidConfigurationException;
import fr.uga.pddl4j.planners.ProblemNotSupportedException;
import fr.uga.pddl4j.planners.SearchStrategy;

import fr.uga.pddl4j.planners.statespace.search.ModifiedAStar;
import fr.uga.pddl4j.planners.statespace.search.Node;
import fr.uga.pddl4j.planners.statespace.search.StateSpaceSearch;
import fr.uga.pddl4j.problem.DefaultProblem;
import fr.uga.pddl4j.problem.Problem;
import fr.uga.pddl4j.problem.operator.Action;
import java.io.FileNotFoundException;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;


public class Punto2 {


    public static void main(String...args) throws InvalidConfigurationException, FileNotFoundException {

        long start = System.currentTimeMillis();
        MyPlanner planner = new MyPlanner();
        planner.setTimeout(1000000);
        planner.setDomain(Settings.domain);
        planner.setProblem(Settings.instance2);
        planner.solve();
        System.out.println((System.currentTimeMillis()-start)/1000);




    }
}


class MyPlanner extends AbstractPlanner {

    private final int heuristic_weigth = 10;

    @Override
    public Problem instantiate(DefaultParsedProblem defaultParsedProblem) {
        DefaultProblem p = new DefaultProblem(defaultParsedProblem);
        p.instantiate();
        return p;
    }

    @Override
    public Plan solve(Problem problem) throws ProblemNotSupportedException {
        //array di utilità
        Problem[] subProblems = split(problem,5);//createSubProblems(problem);
        Node[] subSolutions = new Node[subProblems.length];
        Plan[] subplans = new Plan[subProblems.length];

        //parametri algoritmi
        SearchStrategy.Name strategyName = SearchStrategy.Name.ASTAR;
        StateHeuristic.Name heuristic = StateHeuristic.Name.MAX;
        int timeout = 1000000;

        //inizialmente usiamo A*
        StateSpaceSearch alg0 = StateSpaceSearch.getInstance(strategyName, heuristic, heuristic_weigth);
        subSolutions[0] = alg0.searchSolutionNode(subProblems[0]);
        subplans[0] = alg0.extractPlan(subSolutions[0],subProblems[0]);
        //risolviamo i sottoproblemi rimanenti usando ModifiedAStar
        for(int i = 1; i<subProblems.length; i++){
            subSolutions[i-1].setParent(null);
            StateSpaceSearch alg = new ModifiedAStar(timeout,heuristic,heuristic_weigth,subSolutions[i-1]);
            subSolutions[i] = alg.searchSolutionNode(subProblems[i]);
            subplans[i] = alg.extractPlan(subSolutions[i],subProblems[i]);
        }
        List<Action> sol = new LinkedList<>();
        for(Plan p: subplans)
            sol.addAll(p.actions());
        Plan solution = new SequentialPlan();
        Iterator<Action> it = sol.iterator();
        for(int i = 0; i<sol.size(); i++)
            solution.add(i,it.next());
        return solution;
    }


    private Problem[] split(Problem problem, int split){
        List<Expression<String>>[] goals = new List[split];
        DefaultParsedProblem pp = problem.getParsedProblem();
        List<Expression<String>> inGoal = pp.getGoal().getChildren();
        int bias = inGoal.size()/split;
        int j = 0;
        Iterator<Expression<String>> it = inGoal.iterator();
        for(int i = 0; i<goals.length; i++){
            goals[i] = new LinkedList<>();
            int k = 0;
            for(;k<bias; k++) {
                goals[i].add(it.next());
                it.remove();
            }
            j+=k;
        }
        if(inGoal.size()>0)
            goals[goals.length-1].addAll(inGoal);
        Problem[] ret = new DefaultProblem[split];
        for(int i = 0; i<ret.length; i++){
            Expression<String> tmp = new Expression<>();
            tmp.setChildren(goals[i]);
            System.out.println("Goal"+i+": "+tmp);
            pp.setGoal(tmp);
            ret[i] = new DefaultProblem(pp);
            ret[i].instantiate();
        }
        return ret;
    }

    @Override
    public boolean isSupported(Problem problem) {
        return true;
    }

}

//CONFRONTO TRA SUM E EMERGENCYhEURISTIC
/*
    RUN     SUM     EM_HEUR
     1      17        17
     2      17        17
     3      18        21
     4
     5
 */


