package fr.uga.pddl4j.heuristics.state;

import fr.uga.pddl4j.parser.NamedTypedList;
import fr.uga.pddl4j.parser.Symbol;
import fr.uga.pddl4j.parser.SymbolType;
import fr.uga.pddl4j.parser.TypedSymbol;
import fr.uga.pddl4j.planners.statespace.search.Node;
import fr.uga.pddl4j.problem.*;
import fr.uga.pddl4j.problem.operator.Condition;
import fr.uga.pddl4j.util.BitVector;

import java.util.*;
import java.util.stream.Collectors;


public class EmergencyProblemHeuristic extends RelaxedGraphHeuristic {

    private Problem p;
    private double alpha = 1, rate = 0.1;
    private final int maxNumPlace = 4;
    private HashMap<String,List<Integer>> predicates;
    private HashMap<String, Integer> constants;
    private HashMap<String,Integer> predicateCodes;
    private HashMap<Integer, List<String>> fluents;
    protected EmergencyProblemHeuristic(Problem problem) {
        super(problem);
        this.p = problem;
        this.predicates = extractPredicates();
        this.constants = extractConstants();
        this.predicateCodes = extractPredicateCodes();
        this.fluents = extractFluents();
        problem.getConstantSymbols().stream().filter(e -> e.contains("place")).count();
    }

    private HashMap<String,Integer> extractPredicateCodes(){
        HashMap<String,Integer> ret = new HashMap<>();
        int index = 0;
        for(String s: p.getPredicateSymbols())
            ret.put(s,0);
        return ret;
    }
    private HashMap<String, List<Integer>> extractPredicates(){
        HashMap<String,List<Integer>> ret = new HashMap<>();
        int index = 0;
        for(Fluent f: p.getFluents()) {
            String key = new StringTokenizer(p.toString(f),"( )",false).nextToken();
            if(ret.get(key) == null)
                ret.put(key, new LinkedList<>());
            ret.get(key).add(index);
            index++;
        }
        return ret;
    }

    private HashMap<Integer, List<String>> extractFluents(){
        HashMap<Integer,List<String>> ret = new HashMap<>();
        int index = 0;
        for(Fluent f: p.getFluents()) {
            StringTokenizer st = new StringTokenizer(p.toString(f),"( )",false);
            if(ret.get(index)==null)
                ret.put(index,new ArrayList<>());
            while(st.hasMoreTokens())
                ret.get(index).add(st.nextToken());
            index++;
        }
        return ret;
    }

    private HashMap<String,Integer> extractConstants(){
        HashMap<String,Integer> ret = new HashMap<>();
        int index  = 0;
        for(String s: p.getConstantSymbols()) {
            ret.put(s,index);
            index++;
        }
        return ret;
    }



    @Override
    public int estimate(State state, Condition goal) {
        super.setGoal(goal);
        this.expandRelaxedPlanningGraph(state);
        boxCostraints(state,goal);
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

        return value+boxCostraints(state,goal)+countSatisfied(state, "emptybox");
    }

    @Override
    public double estimate(Node node, Condition goal) {
        return this.estimate((State)node,goal);
    }

    private int countSatisfied(State state, String predName){
        List<Integer> preds = this.predicates.get(predName);
        int count = 0;
        for(int i: preds){
            BitVector tmp = new BitVector();
            tmp.set(i);
            if(state.satisfy(new Condition(tmp,new BitVector())))
                count++;
        }
        return count;
    }

    private int boxCostraints(State state,Condition goal){
        List<Integer> soddisfatti = new ArrayList<>();
        for(int i = goal.getPositiveFluents().nextSetBit(0); i>=0; i = goal.getPositiveFluents().nextSetBit(i+1)){
            BitVector bv = new BitVector();
            bv.set(i);
            if(!state.satisfy(new Condition(bv, new BitVector())))
                soddisfatti.add(i);
        }
        LinkedList<String> contents = new LinkedList<>();
        for(int i: soddisfatti)
            if(fluents.get(i).size()>2)
                contents.add(this.fluents.get(i).get(2));
        List<Integer> predicates = this.predicates.get("inbox").stream()
            .filter(e->{
              BitVector bv = new BitVector();
              bv.set(e);
              return state.satisfy(new Condition(bv, new BitVector()));
            }).collect(Collectors.toList());
        List<String> contentsInBox = new LinkedList<>();
        for(Integer i: predicates)
            if(fluents.get(i).size()>2)
                contentsInBox.add(this.fluents.get(i).get(2));
        while(!contents.isEmpty()){
            String content = contents.removeFirst();
            Iterator<String> it = contentsInBox.iterator();
            while(it.hasNext()){
                String next = it.next();
                if(content.equals(next)) {
                    it.remove();
                    break;
                }
            }
        }
        return contentsInBox.size();
    }

}
