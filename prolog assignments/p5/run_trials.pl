%run_trials.pl
%Student: Zachary Reese
%Major: Computer Science
%Creation Date: 11/18/2024, (restarted) 11/20/2024
%Due Date: 11/25/2024 @ 5am
%CPSC 447 Artificial Intelligence I
%Professor: PROFESSOR_NAME_REDACTED
%Assignment: Prolog Project 5
%Description: This file defines the predicates necessary to initiate agent trials within the Wumpus world.

max_agent_trials(10).
max_agent_actions(100).

%Goal condition: agent has left the cave with at least one piece of gold.
goal_reached :-
    agent_in_cave(no),
    agent_gold(Gold),
    Gold > 0.

%Main predicate to initiate running the agent within the Wumpus world.
run_trials(Actions, Score, Iterations) :-
    initialize(_Percept), %_ prevents prolog interpreter from produces singleton variable warning upon compilation.
    init_agent,
    max_agent_trials(MaxTrials),
    run_trials_loop(1, MaxTrials, 0, Actions, Score, Iterations).

%Loop over the necessary or maximum number of trials.
run_trials_loop(TrialNum, MaxTrials, TotalScore, Actions, Score, Iterations) :-
    ( TrialNum > MaxTrials ->
        %Exceeded maximum number of trials.
        Actions = [],
        Score = TotalScore,
        Iterations = MaxTrials
    ;
        %Restart the world and agent for a new trial.
        restart(Percept),
        restart_agent,
        inner_loop(0, Percept, ActionsTrial),
        agent_score(TrialScore),
        NewScore is TotalScore + TrialScore,
        ( goal_reached ->
            %Trial found a solution.
            Actions = ActionsTrial,
            Score = NewScore,
            Iterations = TrialNum
        ;
            %Continue to the nth trial
            TrialNum1 is TrialNum + 1,
            run_trials_loop(TrialNum1, MaxTrials, NewScore, Actions, Score, Iterations)
        )
    ).

%inner_loop recursively loops over actions within a trial.
%case: agent is dead.
inner_loop(_, _, []) :-
    agent_health(dead),
    !.

%case: agent has left the cave
inner_loop(_, _, []) :-
    agent_in_cave(no),
    !.

%case: exceeded maximum number of trials.
inner_loop(NumActions, _, []) :-
    max_agent_actions(N),
    NumActions >= N,
    !.

inner_loop(NumActions, Percept, [Action | Actions]) :-
    run_agent(Percept, Action), %decide best action based on current Percept.
    execute(Action, NewPercept), %execute the action and obtain the resulting NewPercept.
    NumActions1 is NumActions + 1,
    inner_loop(NumActions1, NewPercept, Actions). %continue onto the next action