
import fr.uga.pddl4j.heuristics.state.StateHeuristic;
import fr.uga.pddl4j.parser.DefaultParsedProblem;
import fr.uga.pddl4j.plan.Plan;
import fr.uga.pddl4j.planners.AbstractPlanner;
import fr.uga.pddl4j.planners.InvalidConfigurationException;
import fr.uga.pddl4j.planners.ProblemNotSupportedException;
import fr.uga.pddl4j.planners.SearchStrategy;

import fr.uga.pddl4j.planners.statespace.search.Node;
import fr.uga.pddl4j.planners.statespace.search.StateSpaceSearch;
import fr.uga.pddl4j.problem.DefaultProblem;
import fr.uga.pddl4j.problem.Problem;

import java.io.FileNotFoundException;


public class Punto2 {


    public static void main(String...args) throws InvalidConfigurationException, FileNotFoundException {

        MyPlanner planner = new MyPlanner();
        planner.setDomain(Settings.domain);
        planner.setProblem(Settings.instance1);
        Plan p = planner.solve();
        System.out.println(p);
    }
}


class MyPlanner extends AbstractPlanner {

    private final int heuristic_weigth = 100;

    @Override
    public Problem instantiate(DefaultParsedProblem defaultParsedProblem) {
        DefaultProblem p = new DefaultProblem(defaultParsedProblem);
        p.instantiate();
        return p;
    }

    @Override
    public Plan solve(Problem problem) throws ProblemNotSupportedException {
        StateSpaceSearch search = StateSpaceSearch.getInstance(SearchStrategy.Name.ASTAR, StateHeuristic.Name.AJUSTED_SUM2,heuristic_weigth);
        Node solution = search.searchSolutionNode(problem);
        return search.extractPlan(solution,problem);
    }

    @Override
    public boolean isSupported(Problem problem) {
        return true;
    }

}


