package fr.uga.pddl4j.planners.statespace;

import fr.uga.pddl4j.heuristics.state.StateHeuristic;
import fr.uga.pddl4j.parser.DefaultParsedProblem;
import fr.uga.pddl4j.parser.Expression;
import fr.uga.pddl4j.plan.Plan;
import fr.uga.pddl4j.plan.SequentialPlan;
import fr.uga.pddl4j.planners.AbstractPlanner;
import fr.uga.pddl4j.planners.ProblemNotSupportedException;
import fr.uga.pddl4j.planners.SearchStrategy;
import fr.uga.pddl4j.planners.statespace.search.ModifiedAStar;
import fr.uga.pddl4j.planners.statespace.search.Node;
import fr.uga.pddl4j.planners.statespace.search.StateSpaceSearch;
import fr.uga.pddl4j.problem.DefaultProblem;
import fr.uga.pddl4j.problem.Problem;
import fr.uga.pddl4j.problem.operator.Action;
import picocli.CommandLine;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

@CommandLine.Command(name = "EPP",
    version = "EPP 1.0",
    description = "Solves a specified planning problem by dividing the problem in more sub problems " +
        "and then executing a sequence of A* searches ",
    sortOptions = false,
    mixinStandardHelpOptions = true,
    headerHeading = "Usage:%n",
    synopsisHeading = "%n",
    descriptionHeading = "%nDescription:%n%n",
    parameterListHeading = "%nParameters:%n",
    optionListHeading = "%nOptions:%n")

public class EmergencyProblemPlanner extends AbstractPlanner {
    private double heuristic_weigth = 1;
    private int split = 2;

    @Override
    public Problem instantiate(DefaultParsedProblem defaultParsedProblem) {
        DefaultProblem p = new DefaultProblem(defaultParsedProblem);
        p.instantiate();
        return p;
    }

    @CommandLine.Option(names = { "-w", "--weight" }, defaultValue = "1.0", paramLabel = "<weight>",
        description = "Set the weight of the heuristic (preset 1.0).")
    public void setHeuristic_weigth(double heuristic_weigth) {
        this.heuristic_weigth = heuristic_weigth;
    }

    @CommandLine.Option(names = { "-s", "--split" }, defaultValue = "2", paramLabel = "<split>",
        description = "Set the split value (preset 2).")
    public void setSplit(final int split) {
        this.split = split;
    }

    @Override
    public Plan solve(Problem problem) throws ProblemNotSupportedException {
        //array di utilità
        Problem[] subProblems = split(problem,split);
        Node[] subSolutions = new Node[subProblems.length];
        Plan[] subplans = new Plan[subProblems.length];

        //parametri algoritmi
        SearchStrategy.Name strategyName = SearchStrategy.Name.ASTAR;
        StateHeuristic.Name heuristic = StateHeuristic.Name.EMERGENCY_PROBLEM;
        int timeout = 1000000;

        //inizialmente usiamo A*
        StateSpaceSearch alg0 = StateSpaceSearch.getInstance(strategyName, heuristic, heuristic_weigth);
        subSolutions[0] = alg0.searchSolutionNode(subProblems[0]);
        subplans[0] = alg0.extractPlan(subSolutions[0],subProblems[0]);
        System.out.println("piano 0: ");
        if(subplans[0] != null)
            printPlan(subplans[0],problem);
        else System.out.println("piano nullo");
        System.out.println("fine piano");
        //risolviamo i sottoproblemi rimanenti usando ModifiedAStar
        for(int i = 1; i<subProblems.length; i++){
            subSolutions[i-1].setParent(null);
            StateSpaceSearch alg = new ModifiedAStar(timeout,heuristic,heuristic_weigth,subSolutions[i-1]);
            subSolutions[i] = alg.searchSolutionNode(subProblems[i]);
            subplans[i] = alg.extractPlan(subSolutions[i],subProblems[i]);
            System.out.printf("piano %d: \n",i);
            if(subplans[i] != null)
                printPlan(subplans[i],problem);
            else System.out.println("piano nullo");
            System.out.println("fine piano");
        }
        List<Action> sol = new LinkedList<>();
        for(Plan p: subplans)
            if(p != null)
                sol.addAll(p.actions());
        Plan solution = new SequentialPlan();
        Iterator<Action> it = sol.iterator();
        for(int i = 0; i<sol.size(); i++)
            solution.add(i,it.next());
        return solution;
    }

    private void printPlan(Plan p, Problem problem){
        System.out.println(
            new StringBuilder().append(problem.toString(p)).toString()
        );
    }

    private Problem[] split(Problem problem, int split){
        List<Expression<String>>[] goals = new List[split];
        DefaultParsedProblem pp = problem.getParsedProblem();
        System.out.println(pp.getConstants());
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
        while(inGoal.size()>0)
            for(int k = 0; k<goals.length; k++) {
                goals[k].add(inGoal.remove(0));
                if(inGoal.isEmpty())break;
            }
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

    public static void main(String[] args) {
        try {
            final EmergencyProblemPlanner planner = new EmergencyProblemPlanner();
            CommandLine cmd = new CommandLine(planner);
            int exitCode = (int) cmd.execute(args);
            if (exitCode == 1) {
                System.out.println(cmd.getUsageMessage());
            }
            System.exit(exitCode);
        } catch (Throwable e) {
            System.err.println(e.getMessage());
        }
    }

}
