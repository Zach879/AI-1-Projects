% Some simple test agents.
%
% To define an agent within the run_trials.pl scenario, define:
%   init_agent
%   restart_agent
%   run_agent


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Agent to solve figure 7.2

:- dynamic([fig72acts/1]).

init_agent :-
  retractall(fig72acts(_)),
  asserta(fig72acts([goforward,turnleft,goforward,goforward,grab,
                    turnleft,turnleft,goforward,goforward,turnright,
                    goforward,climb])).

restart_agent :-
  init_agent.

run_agent(_,Action) :-
  retract(fig72acts([Action|Actions])),
  asserta(fig72acts(Actions)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Agent that only performs goforward

%init_agent.
%
%restart_agent.
%
%run_agent(_, goforward).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Agent that only performs random actions

%init_agent.
%
%restart_agent.
%
%run_agent(_, Action) :-
%  random_member(Action,[goforward,turnleft,turnright,grab,shoot,climb]).

