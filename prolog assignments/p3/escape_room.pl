%escape_room.pl
%Student: Zachary Reese
%Major: Computer Science
%Creation Date: 11/01/2024
%Due Date: 11/06/2024 @ 5am
%CPSC 447 Artificial Intelligence I
%Professor: PROFESSOR_NAME_REDACTED
%Assignment: Prolog Project 3
%Description: Modifies the provided code to include rules for finding the list of actions to get to goal state.

% A person trying to escape a room. The person is at the door, but the door is
% locked. There is a window in the room, but it is too high to climb out from
% the floor. There is a box in the middle of the room that the person can push
% around and climb on. Can the person escape through the window?

% Legal actions

% Climb out the window
action( state( atwindow , onbox, atwindow, trapped),
      climb,
      state( atwindow, onbox, atwindow, free) ).

% Climb the box
action( state( P, onfloor, P, H),
      climb,
      state( P, onbox, P, H) ).

% Push box from P1 to P2
action( state( P1, onfloor, P1, H),
      push( P1, P2),
      state( P2, onfloor, P2, H) ).

% Walk from P1 to P2
action( state( P1, onfloor, B, H),
      walk( P1, P2),
      state( P2, onfloor, B, H) ).

% escape( State): the person can escape
escape( state( _, _, _, free) ).

escape( State1) :-
    action( State1, _, State2),
    escape( State2).

% Example query
% escape( state(atdoor, onfloor, middle, trapped) ).

%MODIFICATIONS BEGIN HERE!

%base case: no more actions required at goal state.
escape(state(_, _, _, free), []).
%recursive case: find list of actions.
escape(State, [Action | Actions]) :-
	action(State, Action, NextState), %determine next action and the resulting state
	escape(NextState, Actions). %find next best action to escape to goal