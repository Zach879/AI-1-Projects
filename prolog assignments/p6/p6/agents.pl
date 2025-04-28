%agents.pl
%Student: Zachary Reese
%Major: Computer Science
%Creation Date: 11/29/2024
%Due Date: 12/12/2024 @ 5am
%CPSC 447 Artificial Intelligence I
%Professor: Dr. Schwesinger
%Assignment: Prolog Project 6
%Description: This file defines a logic agent that attempts to solve basic wumpus board problems logically (no luck) on the first try.
  %However, the agent is missing implementation for going back to the start and then climbing up the ladder to complete the game, as
  %well as prioritizing hunting wumpus when his location is known/ has been deduced. The agent is able to navigate around the board, 
  %perceive and memorize perceived information, deduce contradictions and act upon them, search until all unvisited-safe squares have 
  %been visited, and by then the agent should have (hopefully) found the gold.

:- dynamic([
    current_position/2,
    current_orientation/1,
    visited/2,
    safe/2,
    wumpus_alive/1,
    have_gold/1,
    wumpus_possible_positions/1,
    pit_possible_positions/1,
    backtrack_path/1
]).

%Initialize the agent's state
init_agent :-
    retractall(current_position(_, _)),
    retractall(current_orientation(_)),
    retractall(visited(_, _)),
    retractall(safe(_, _)),
    retractall(wumpus_alive(_)),
    retractall(have_gold(_)),
    retractall(wumpus_possible_positions(_)),
    retractall(pit_possible_positions(_)),
    retractall(backtrack_path(_)),
    assertz(current_position(1, 1)),
    assertz(current_orientation(0)), %East
    assertz(visited(1, 1)),
    assertz(safe(1, 1)),
    assertz(wumpus_alive(yes)),
    assertz(have_gold(no)),
    assertz(wumpus_possible_positions([])),
    assertz(pit_possible_positions([])),
    assertz(backtrack_path([])).

%Restart the agent (re-initialize)
restart_agent :-
    init_agent.

%Orientation: 0=East, 90=North, 180=West, 270=South
left_turn(0, 90).
left_turn(90, 180).
left_turn(180, 270).
left_turn(270, 0).

right_turn(0, 270).
right_turn(270, 180).
right_turn(180, 90).
right_turn(90, 0).

%Return adjacent squares (no diagonals)
adjacent((X, Y), (X2, Y)) :- X2 is X + 1, X2 >= 1.
adjacent((X, Y), (X2, Y)) :- X2 is X - 1, X2 >= 1.
adjacent((X, Y), (X, Y2)) :- Y2 is Y + 1, Y2 >= 1.
adjacent((X, Y), (X, Y2)) :- Y2 is Y - 1, Y2 >= 1.

%Synchronize agent's state with the environment
sync_agent_state :-
    agent_location(X, Y),
    agent_orientation(D),
    retractall(current_position(_, _)),
    retractall(current_orientation(_)),
    assertz(current_position(X, Y)),
    assertz(current_orientation(D)),
    ( \+ visited(X, Y) -> assertz(visited(X, Y)) ; true ),
    ( \+ safe(X, Y) -> assertz(safe(X, Y)) ; true ).

%Update knowledge based on percepts
update_knowledge([Stench, Breeze, Glitter, Bump, Scream]) :-
    sync_agent_state,
    current_position(X, Y),
    ( Scream = yes ->
        retract(wumpus_alive(_)),
        assertz(wumpus_alive(no)),
        retract(wumpus_possible_positions(_)),
        assertz(wumpus_possible_positions([]))
    ; true ),
    ( Stench = yes, wumpus_alive(yes) ->
        findall((Ax, Ay),
            ( adjacent((X, Y), (Ax, Ay)),
              \+ visited(Ax, Ay),
              \+ safe(Ax, Ay)
            ),
            Candidates),
        wumpus_possible_positions(Old),
        append(Old, Candidates, Combined),
        sort(Combined, New),
        retract(wumpus_possible_positions(_)),
        assertz(wumpus_possible_positions(New))
    ; true ),
    ( Breeze = yes, Glitter = no ->
        findall((Px, Py),
            ( adjacent((X, Y), (Px, Py)),
              \+ visited(Px, Py),
              \+ safe(Px, Py)
            ),
            Candidates),
        pit_possible_positions(Old),
        append(Old, Candidates, Combined),
        sort(Combined, New),
        retract(pit_possible_positions(_)),
        assertz(pit_possible_positions(New))
    ; true ),
    check_contradictions.

%Check for contradictions in Wumpus and pit knowledge
check_contradictions :-
    wumpus_possible_positions(WList),
    pit_possible_positions(PList),
    findall((X, Y), (member((X, Y), WList), member((X, Y), PList)), Contradictions),
    ( Contradictions \= [] ->
        forall(member((X, Y), Contradictions), 
               (assertz(safe(X, Y)), 
                retractall(wumpus_possible_positions(_)), 
                retractall(pit_possible_positions(_)), 
                assertz(wumpus_possible_positions([])), 
                assertz(pit_possible_positions([]))))
    ; true ).

%A square is unsafe if it might contain a Wumpus or pit
unsafe(X, Y) :-
    wumpus_possible_positions(WList),
    pit_possible_positions(PList),
    (member((X, Y), WList); member((X, Y), PList)).

%Compute frontier squares to explore
frontier_squares(Frontier) :-
    findall((Xv, Yv), visited(Xv, Yv), VisitedList),
    findall((Xa, Ya),
        ( member((Xv, Yv), VisitedList),
          adjacent((Xv, Yv), (Xa, Ya)),
          \+ visited(Xa, Ya),
          \+ unsafe(Xa, Ya) 
        ),
        FrontierRaw),
    sort(FrontierRaw, Frontier),
    (Frontier == [] -> 
        Frontier = [(CurX, CurY)], 
        current_position(CurX, CurY) 
    ; true).

%Helper to orient towards a target square
desired_direction((X, Y), (Tx, Ty), Dir) :-
    DX is Tx - X, DY is Ty - Y,
    ( abs(DX) > abs(DY) ->
        (DX > 0 -> Dir = 0 ; Dir = 180)
    ; (DY > 0 -> Dir = 90 ; Dir = 270)
    ).

%Turn to face a direction from current direction
turn_to_direction(CurrentD, GoalD, Action) :-
    ( CurrentD = GoalD -> Action = goforward
    ; left_turn(CurrentD, Dl), Dl = GoalD -> Action = turnleft
    ; right_turn(CurrentD, Dr), Dr = GoalD -> Action = turnright
    ; Action = turnleft
    ).

%Backtrack to the most recent visited square
backtrack(Action) :-
    backtrack_path([Back|RemainingPath]),
    current_position(CurX, CurY),
    current_orientation(CurDir),
    ( CurX = Back, CurY = Back ->
        retract(backtrack_path(_)),
        assertz(backtrack_path(RemainingPath)),
        Action = turnleft
    ; desired_direction((CurX, CurY), Back, GoalDir),
      turn_to_direction(CurDir, GoalDir, Action)
    ).

%Decide next action based on percepts
decide_action([_Stench, _Breeze, Glitter, Bump, _Scream], Action) :-
    have_gold(G),
    current_position(X, Y),
    current_orientation(D),
    ((Glitter = yes, G = no) ->
	write('Gold detected. Grabbing it now.\n'),
        Action = grab,
        retract(have_gold(_)),
        assertz(have_gold(yes))
    ; (G = yes, X = 1, Y = 1) -> 
        Action = climb
    ; (Bump = yes) -> 
        Action = turnleft
    ; frontier_squares(Frontier),
      ( Frontier = [] ->
          backtrack(Action)
      ; Frontier = [(Fx, Fy)|_],
        desired_direction((X, Y), (Fx, Fy), GoalDir),
        turn_to_direction(D, GoalDir, Action)
      )
    ).

%Run the agent
run_agent(Percept, Action) :-
    update_knowledge(Percept),
    decide_action(Percept, Action).
